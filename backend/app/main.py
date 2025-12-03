from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from .config import settings
from .routers import audio, notes

app = FastAPI(title=settings.PROJECT_NAME)

app.add_middleware(
  CORSMiddleware,
  allow_origins=settings.BACKEND_CORS_ORIGINS,
  allow_credentials=True,
  allow_methods=["*"],
  allow_headers=["*"],
)

app.include_router(audio.router)
app.include_router(notes.router)


@app.get("/health")
def health() -> dict:
  return {"status": "ok"}


