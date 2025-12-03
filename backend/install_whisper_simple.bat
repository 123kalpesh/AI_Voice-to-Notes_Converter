@echo off
REM Simple whisper installer that works with Python 3.14

echo ========================================
echo Installing Whisper
echo ========================================
echo.

cd /d "%~dp0"

if not exist ".venv" (
    echo ERROR: Backend virtual environment not found!
    pause
    exit /b 1
)

call .venv\Scripts\activate.bat

echo Python version:
python --version
echo.

echo Step 1: Upgrading pip...
python -m pip install --upgrade pip --quiet

echo.
echo Step 2: Installing torch...
pip install torch --quiet
if %ERRORLEVEL% NEQ 0 (
    echo Installing torch (this may take a while)...
    pip install torch
)

echo.
echo Step 3: Installing numpy and soundfile...
pip install numpy soundfile --quiet

echo.
echo Step 4: Installing whisper...
echo This may take several minutes...
pip install openai-whisper

echo.
echo Step 5: Verifying installation...
python -c "import whisper; print('SUCCESS: Whisper installed!')" 2>nul
if %ERRORLEVEL% EQU 0 (
    echo.
    echo ========================================
    echo SUCCESS: Whisper installed!
    echo ========================================
    echo.
    echo You can now run: run_backend.bat
    echo.
) else (
    echo.
    echo ========================================
    echo ERROR: Whisper installation failed!
    echo ========================================
    echo.
    python --version
    echo.
    python -c "import sys; print('Python version:', sys.version)" 2>nul | findstr "3.14"
    if %ERRORLEVEL% EQU 0 (
        echo.
        echo URGENT: You are using Python 3.14!
        echo.
        echo numba DOES NOT support Python 3.14.
        echo Error: "only versions ^>=3.10,^<3.14 are supported"
        echo.
        echo YOU MUST SWITCH TO PYTHON 3.11 OR 3.12
        echo.
        echo See URGENT_PYTHON_SWITCH.md for instructions.
        echo Or run: SWITCH_PYTHON_NOW.bat
        echo.
    ) else (
        echo.
        echo This may be due to other compatibility issues.
        echo See FINAL_SOLUTION.md for troubleshooting.
        echo.
    )
)

pause

