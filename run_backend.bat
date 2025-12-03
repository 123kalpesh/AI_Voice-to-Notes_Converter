@echo off
REM Complete Backend Runner Script
REM This script handles all setup and runs the backend server

echo ========================================
echo AI Voice-to-Notes Converter - Backend
echo ========================================
echo.

REM Check if Python is available
python --version >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Python is not installed or not in PATH!
    echo Please install Python 3.10+ from https://www.python.org
    pause
    exit /b 1
)

echo Python found:
python --version
echo.

REM Navigate to backend directory
cd /d "%~dp0backend"
if not exist "app" (
    echo ERROR: Backend directory structure not found!
    pause
    exit /b 1
)

REM Check if virtual environment exists
if not exist ".venv" (
    echo Creating virtual environment...
    python -m venv .venv
    if %ERRORLEVEL% NEQ 0 (
        echo ERROR: Failed to create virtual environment!
        pause
        exit /b 1
    )
)

REM Activate virtual environment
echo Activating virtual environment...
call .venv\Scripts\activate.bat
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Failed to activate virtual environment!
    pause
    exit /b 1
)

REM Upgrade pip
echo Upgrading pip...
python -m pip install --upgrade pip --quiet

REM Install/upgrade dependencies
echo Installing dependencies...
REM Try smart installer first (handles Python 3.14 issues)
if exist "install_dependencies.bat" (
    call install_dependencies.bat
    if %ERRORLEVEL% NEQ 0 (
        echo Trying standard installation...
        pip install -r requirements.txt
        if %ERRORLEVEL% NEQ 0 (
            echo.
            echo ERROR: Failed to install dependencies!
            echo.
            echo This is likely due to Python 3.14 compatibility issues.
            echo Solutions:
            echo   1. Use Python 3.11 or 3.12 (recommended)
            echo   2. Install Rust from https://rustup.rs/
            echo   3. Try: pip install --upgrade pydantic pydantic-core --no-cache-dir
            pause
            exit /b 1
        )
    )
) else (
    pip install -r requirements.txt --quiet
    if %ERRORLEVEL% NEQ 0 (
        echo ERROR: Failed to install dependencies!
        echo Trying with verbose output...
        pip install -r requirements.txt
        if %ERRORLEVEL% NEQ 0 (
            echo.
            echo ERROR: Installation failed!
            echo This may be due to Python 3.14 compatibility issues.
            echo Try using Python 3.11 or 3.12 instead.
            pause
            exit /b 1
        )
    )
)

REM Set PYTHONPATH to project root (parent of backend)
cd ..
set PYTHONPATH=%CD%
cd backend

REM Install ML dependencies in backend venv (needed for ml_model import)
echo Checking ML dependencies...
python -c "import whisper" 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo Whisper not found in backend venv.
    echo.
    echo Attempting to install whisper...
    echo NOTE: If this fails, you may need to switch to Python 3.11/3.12
    echo See FINAL_SOLUTION.md for details.
    echo.
    if exist "install_whisper_simple.bat" (
        call install_whisper_simple.bat
    ) else if exist "install_whisper_fixed.bat" (
        call install_whisper_fixed.bat
    ) else (
        pip install openai-whisper --quiet
        if %ERRORLEVEL% NEQ 0 (
            echo Installing whisper (this may take a few minutes)...
            pip install openai-whisper
        )
    )
    echo.
    REM Verify again
    python -c "import whisper" 2>nul
    if %ERRORLEVEL% NEQ 0 (
        echo.
        echo ERROR: Whisper installation failed!
        echo.
        echo RECOMMENDED: Switch to Python 3.11 or 3.12
        echo See FINAL_SOLUTION.md for instructions.
        echo.
        pause
        exit /b 1
    )
)

REM Verify ml_model can be imported
echo Verifying ml_model import...
python -c "import sys; sys.path.insert(0, '..'); from ml_model.main import transcribe_audio; print('✓ ml_model import successful')" 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo WARNING: ml_model import test failed!
    echo.
    echo Installing ML dependencies...
    if exist "install_ml_dependencies.bat" (
        call install_ml_dependencies.bat
    ) else (
        pip install openai-whisper torch numpy soundfile
    )
    echo.
    echo Testing again...
    python -c "import sys; sys.path.insert(0, '..'); from ml_model.main import transcribe_audio; print('✓ ml_model import successful')" 2>nul
    if %ERRORLEVEL% NEQ 0 (
        echo ERROR: ml_model still cannot be imported!
        echo Make sure ml_model folder exists and dependencies are installed.
        pause
        exit /b 1
    )
)

echo.
echo ========================================
echo Starting FastAPI server...
echo ========================================
echo Server will be available at: http://localhost:8000
echo API docs at: http://localhost:8000/docs
echo Press CTRL+C to stop
echo.

REM Start uvicorn server
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000

