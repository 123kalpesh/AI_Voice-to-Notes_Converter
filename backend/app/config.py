from typing import List

from pydantic_settings import BaseSettings


class Settings(BaseSettings):
  PROJECT_NAME: str = "AI Voice-to-Notes Backend"
  BACKEND_CORS_ORIGINS: List[str] = ["http://localhost:5173"]
  TEMP_AUDIO_DIR: str = "tmp_audio"

  class Config:
    env_file = ".env"


settings = Settings()


