import os


def ensure_wav(input_path: str) -> str:
  """
  Hook for audio normalization / conversion to 16kHz mono WAV.
  Currently returns absolute path unchanged.
  """
  return os.path.abspath(input_path)


