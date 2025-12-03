@echo off
REM Quick fix for "No module named 'whisper'" error

cd backend

if exist "install_whisper_simple.bat" (
    call install_whisper_simple.bat
) else if exist "install_whisper_fixed.bat" (
    call install_whisper_fixed.bat
) else (
    echo Using standard installation...
    call .venv\Scripts\activate.bat
    pip install openai-whisper
    python -c "import whisper; print('SUCCESS: Whisper installed!')"
)

