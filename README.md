# AI Voice-to-Notes Converter

Full-stack application that records or uploads audio, transcribes it with an AI speech model, and lets the user edit/save notes. The repo is organized as three independent workspaces so each tier can scale separately.

## Tech Stack

- **Frontend:** React + Vite (TypeScript), Tailwind CSS, Axios, MediaRecorder API
- **Backend:** FastAPI, Uvicorn, Pydantic, Requests
- **ML Model:** `openai-whisper` (PyTorch), optional GPU acceleration

## Repository Layout

```
project-root/
├── frontend/          # React client
├── backend/           # FastAPI service
└── ml_model/          # Whisper-based transcription module
```

Key frontend elements: upload/record UI, editable notes view, Axios API layer, `.env` support via `VITE_API_BASE_URL`.  
Backend routes:

- `POST /api/upload-audio` – accepts multipart audio, saves temp file, transcribes
- `POST /api/convert` – downloads audio from a public URL, transcribes
- `POST /api/notes` – create note (example in-memory store)
- `GET /api/notes` – list notes (extend to full CRUD as needed)

`ml_model/main.py` exposes a single `transcribe_audio(file_path)` entry point. Whisper weights are cached by `openai-whisper`; `ml_model/model/whisper_model.pt` is a placeholder should you want to pin weights locally.

## 🚀 Quick Start (Easiest Method)

### Automated Setup (Recommended)

1. **Run complete setup:**
   ```bat
   setup_all.bat
   ```

2. **Verify setup:**
   ```bat
   verify_setup.bat
   ```

3. **Run the project:**
   - **Terminal 1:** `run_backend.bat`
   - **Terminal 2:** `run_frontend.bat`
   - Visit: **http://localhost:5173**

See `QUICK_START.md` for detailed instructions and troubleshooting.

---

## Setup & Installation (Manual)

1. **ML model environment**
   ```bash
   cd ml_model
   python -m venv .venv
   .\.venv\Scripts\activate
   pip install -r requirements.txt
   ```
   - Install `ffmpeg` and add to PATH (required by Whisper).

2. **Backend**
   ```bash
   cd backend
   python -m venv .venv
   .\.venv\Scripts\activate
   pip install -r requirements.txt
   ```
   - Use `run_backend.bat` which handles PYTHONPATH automatically, or manually set `set PYTHONPATH=..` before running uvicorn.

3. **Frontend**
   ```bash
   cd frontend
   npm install
   ```
   - `.env.local` is created automatically by `run_frontend.bat`, or manually create it with `VITE_API_BASE_URL=http://localhost:8000`.

## Running the Stack (Dev)

### Using Helper Scripts (Recommended)

| Service   | Command                    |
|-----------|----------------------------|
| Backend   | `run_backend.bat`          |
| Frontend  | `run_frontend.bat`         |

### Manual Commands

| Service   | Command                                                                 |
|-----------|--------------------------------------------------------------------------|
| Backend   | `cd backend && .\.venv\Scripts\activate && set PYTHONPATH=.. && uvicorn app.main:app --reload --port 8000` |
| Frontend  | `cd frontend && npm run dev -- --port 5173`                              |

Visit `http://localhost:5173` to use the app:

1. Record audio (MediaRecorder) or upload a file.
2. Optionally paste a public audio URL to transcribe via `/api/convert`.
3. Review/edit transcription, then click **Save Note** which calls `/api/notes`.

## Testing & Manual Verification

### API Smoke Tests

```bash
curl http://localhost:8000/health

curl -X POST "http://localhost:8000/api/upload-audio" ^
  -H "accept: application/json" ^
  -F "file=@C:\path\to\sample.wav"

curl -X POST "http://localhost:8000/api/convert" ^
  -H "Content-Type: application/json" ^
  -d "{\"url\":\"https://example.com/audio.mp3\"}"

curl -X POST "http://localhost:8000/api/notes" ^
  -H "Content-Type: application/json" ^
  -d "{\"title\":\"Test\",\"content\":\"Generated note\"}"

curl http://localhost:8000/api/notes
```

### Suggested Automated Tests

- **Frontend:** React Testing Library for record/upload components (mock Axios).
- **Backend:** `pytest` + `httpx.AsyncClient` for each route, fixtures for temp files.
- **ML Model:** Unit test that stubs Whisper and verifies `transcribe_audio` response handling.

## Deployment Guidance

- **Containerize** each service; use GPU-enabled base image for `ml_model`/backend if Whisper runs server-side.
- **Env config:** set `BACKEND_CORS_ORIGINS` to production frontend, secure notes endpoints with auth (JWT, API keys).
- **Static hosting** for frontend (Vercel, Netlify) pointing at deployed FastAPI service.
- **Scaling:** break `ml_model` into its own microservice when needed; backend can then call it via REST/gRPC.
- **Monitoring:** add structured logging, request metrics, tracing, and Sentry/Prometheus as appropriate.

## Performance & Security Best Practices

- Load Whisper once per process (`@lru_cache` already applied).
- Enforce 25 MB limit, validate MIME types, and delete temp files immediately after use.
- Add rate limiting / auth for public deployments.
- For large workloads, push transcription jobs to a worker queue and return job IDs to the client.
- Serve everything over HTTPS in production; terminate TLS at a reverse proxy (Nginx, Caddy, cloud LB).

## Next Improvements

- Persist notes in PostgreSQL/SQLite via SQLAlchemy models + Alembic migrations.
- Add frontend view to list/edit/delete notes.
- Provide background job status updates for long transcriptions.
- Integrate GPU inference and expose model selection (tiny/base/small) for latency vs. accuracy trade-offs.


