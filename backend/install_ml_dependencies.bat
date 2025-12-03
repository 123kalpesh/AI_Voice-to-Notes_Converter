@echo off
REM Install ML model dependencies in backend venv
REM This is needed because backend imports ml_model which needs whisper

echo ========================================
echo Installing ML Dependencies in Backend
echo ========================================
echo.

cd /d "%~dp0"

if not exist ".venv" (
    echo ERROR: Backend virtual environment not found!
    echo Run setup_all.bat first.
    pause
    exit /b 1
)

call .venv\Scripts\activate.bat

echo Installing whisper and ML dependencies...
echo.

REM Install whisper (openai-whisper)
pip install openai-whisper --quiet
if %ERRORLEVEL% NEQ 0 (
    echo Installing whisper with verbose output...
    pip install openai-whisper
)

REM Install other ML dependencies that might be needed
pip install torch --quiet 2>nul
pip install numpy --quiet 2>nul
pip install soundfile --quiet 2>nul

echo.
echo Verifying installation...
python -c "import whisper; print('✓ Whisper installed successfully!')" 2>nul
if %ERRORLEVEL% EQU 0 (
    echo ✓ All ML dependencies installed!
) else (
    echo ✗ Whisper installation failed!
    echo Trying again with full output...
    pip install openai-whisper
    python -c "import whisper; print('✓ Whisper installed!')"
)

echo.
pause

