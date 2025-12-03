from datetime import datetime
from typing import List

from fastapi import APIRouter, HTTPException

from ..schemas import Note, NoteCreate


router = APIRouter(prefix="/api/notes", tags=["notes"])

_notes: List[Note] = []
_counter = 1


@router.post("", response_model=Note)
def create_note(note_in: NoteCreate) -> Note:
  global _counter
  now = datetime.utcnow()
  note = Note(
    id=_counter,
    title=note_in.title,
    content=note_in.content,
    created_at=now,
    updated_at=now,
  )
  _notes.append(note)
  _counter += 1
  return note


@router.get("", response_model=List[Note])
def list_notes() -> List[Note]:
  return _notes


@router.get("/{note_id}", response_model=Note)
def get_note(note_id: int) -> Note:
  for n in _notes:
    if n.id == note_id:
      return n
  raise HTTPException(status_code=404, detail="Note not found")


