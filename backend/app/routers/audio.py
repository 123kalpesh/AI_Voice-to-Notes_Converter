import os
import sys
import uuid
from pathlib import Path
from urllib.parse import urlparse

import requests
from fastapi import APIRouter, UploadFile, File, HTTPException, BackgroundTasks
from fastapi.concurrency import run_in_threadpool

from ..config import settings
from ..schemas import TranscriptionResponse, UrlConvertRequest

# Ensure project root is on PYTHONPATH for ml_model import
PROJECT_ROOT = Path(__file__).parent.parent.parent.parent
if str(PROJECT_ROOT) not in sys.path:
    sys.path.insert(0, str(PROJECT_ROOT))

# Import ML model function
try:
    from ml_model.main import transcribe_audio
except ImportError as e:
    raise ImportError(
        f"Failed to import ml_model. Make sure ml_model folder exists at {PROJECT_ROOT / 'ml_model'}. "
        f"Original error: {e}"
    ) from e


router = APIRouter(prefix="/api", tags=["audio"])

os.makedirs(settings.TEMP_AUDIO_DIR, exist_ok=True)

MAX_FILE_SIZE = 25 * 1024 * 1024  # 25MB


def remove_file(path: Path) -> None:
  try:
    path.unlink(missing_ok=True)
  except Exception:
    pass


def _write_temp_file(data: bytes, suffix: str) -> Path:
  temp_filename = f"{uuid.uuid4()}{suffix}"
  temp_path = Path(settings.TEMP_AUDIO_DIR) / temp_filename
  with temp_path.open("wb") as f:
    f.write(data)
  return temp_path


def download_audio_to_temp(url: str) -> Path:
  """
  Download audio file from URL, enforce max size, persist to temp file.
  Runs in a thread via run_in_threadpool.
  """
  try:
    resp = requests.get(url, stream=True, timeout=30)
  except requests.RequestException as exc:
    raise HTTPException(status_code=400, detail="Unable to fetch audio URL") from exc

  if resp.status_code >= 400:
    raise HTTPException(status_code=resp.status_code, detail="Audio URL responded with error")

  content_type = resp.headers.get("Content-Type", "")
  if content_type and not content_type.startswith("audio/"):
    raise HTTPException(status_code=400, detail="URL is not an audio resource")

  suffix = Path(urlparse(url).path).suffix or ".wav"
  temp_filename = f"{uuid.uuid4()}{suffix}"
  temp_path = Path(settings.TEMP_AUDIO_DIR) / temp_filename

  total = 0
  try:
    with temp_path.open("wb") as f:
      for chunk in resp.iter_content(chunk_size=512 * 1024):
        if not chunk:
          continue
        total += len(chunk)
        if total > MAX_FILE_SIZE:
          raise HTTPException(status_code=413, detail="Remote audio exceeds 25MB limit")
        f.write(chunk)
  except HTTPException:
    remove_file(temp_path)
    raise
  except Exception as exc:
    remove_file(temp_path)
    raise HTTPException(status_code=400, detail="Failed to download audio") from exc

  return temp_path


@router.post("/upload-audio", response_model=TranscriptionResponse)
async def upload_audio(
  background_tasks: BackgroundTasks,
  file: UploadFile = File(...)
) -> TranscriptionResponse:
  if not file.content_type.startswith("audio/"):
    raise HTTPException(status_code=400, detail="Invalid file type")

  suffix = Path(file.filename).suffix or ".wav"
  content = await file.read()
  if len(content) > MAX_FILE_SIZE:
    raise HTTPException(status_code=413, detail="File too large (max 25MB)")

  temp_path = _write_temp_file(content, suffix)
  background_tasks.add_task(remove_file, temp_path)

  text, confidence = transcribe_audio(str(temp_path))
  return TranscriptionResponse(text=text, confidence=confidence)


@router.post("/convert", response_model=TranscriptionResponse)
async def convert_from_url(payload: UrlConvertRequest) -> TranscriptionResponse:
  temp_path = await run_in_threadpool(download_audio_to_temp, payload.url)
  try:
    text, confidence = transcribe_audio(str(temp_path))
  finally:
    remove_file(temp_path)
  return TranscriptionResponse(text=text, confidence=confidence)


