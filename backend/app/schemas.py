from datetime import datetime
from pydantic import BaseModel
from typing import Optional, List


class TranscriptionResponse(BaseModel):
  text: str
  confidence: float


class UrlConvertRequest(BaseModel):
  url: str


class NoteCreate(BaseModel):
  title: Optional[str] = None
  content: str


class Note(BaseModel):
  id: int
  title: Optional[str]
  content: str
  created_at: datetime
  updated_at: datetime

  class Config:
    from_attributes = True


