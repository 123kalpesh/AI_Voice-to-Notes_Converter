from functools import lru_cache
import os
import sys

import whisper

# Handle both relative and absolute imports
try:
    from .utils.audio_preprocess import ensure_wav
except ImportError:
    # Fallback for when ml_model is imported directly
    sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
    from ml_model.utils.audio_preprocess import ensure_wav


@lru_cache(maxsize=1)
def get_model():
  """
  Load Whisper model once and cache it.
  """
  model = whisper.load_model("base")
  return model


def transcribe_audio(file_path: str) -> tuple[str, float]:
  """
  Called by backend.
  Returns (text, confidence).
  """
  normalized_path = ensure_wav(file_path)
  model = get_model()
  result = model.transcribe(normalized_path)
  text = result.get("text", "").strip()
  segments = result.get("segments") or []
  if segments:
    avg_no_speech_prob = sum(
      s.get("no_speech_prob", 0.0) for s in segments
    ) / len(segments)
    confidence = float(max(0.0, min(1.0, 1.0 - avg_no_speech_prob)))
  else:
    confidence = 0.5 if text else 0.0
  return text, confidence


