@echo off
REM Complete Project Setup Script
REM This script sets up all three parts: ml_model, backend, and frontend

echo ========================================
echo AI Voice-to-Notes Converter
echo Complete Project Setup
echo ========================================
echo.

REM Get project root directory
set PROJECT_ROOT=%~dp0
cd /d "%PROJECT_ROOT%"

REM ========================================
REM Step 1: ML Model Setup
REM ========================================
echo [1/3] Setting up ML Model...
echo.

cd ml_model
if not exist ".venv" (
    echo Creating virtual environment...
    python -m venv .venv
)
call .venv\Scripts\activate.bat
python -m pip install --upgrade pip --quiet
echo Installing ML model dependencies...
pip install -r requirements.txt
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Failed to install ML model dependencies!
    pause
    exit /b 1
)
echo ✓ ML Model setup complete
call deactivate
cd ..

echo.

REM ========================================
REM Step 2: Backend Setup
REM ========================================
echo [2/3] Setting up Backend...
echo.

REM Check Python version
python --version
echo.

cd backend
if not exist ".venv" (
    echo Creating virtual environment...
    python -m venv .venv
)
call .venv\Scripts\activate.bat
python -m pip install --upgrade pip --quiet

REM Try smart installer if available
if exist "install_dependencies.bat" (
    echo Installing backend dependencies (smart installer)...
    call install_dependencies.bat
    if %ERRORLEVEL% NEQ 0 (
        echo WARNING: Smart installer had issues, trying standard method...
        pip install -r requirements.txt
        if %ERRORLEVEL% NEQ 0 (
            echo.
            echo ERROR: Failed to install backend dependencies!
            echo.
            echo This may be due to Python 3.14 compatibility issues.
            echo See PYTHON_VERSION_FIX.md for solutions.
            echo.
            echo Quick fix: Use Python 3.11 or 3.12 instead.
            pause
            exit /b 1
        )
    )
) else (
    echo Installing backend dependencies...
    pip install -r requirements.txt
    if %ERRORLEVEL% NEQ 0 (
        echo ERROR: Failed to install backend dependencies!
        echo See PYTHON_VERSION_FIX.md for solutions.
        pause
        exit /b 1
    )
)

REM Install ML dependencies (whisper) needed for ml_model import
echo Installing ML dependencies (whisper)...
pip install openai-whisper --quiet
if %ERRORLEVEL% NEQ 0 (
    echo Installing whisper (this may take a few minutes)...
    pip install openai-whisper
)

echo ✓ Backend setup complete
call deactivate
cd ..

echo.

REM ========================================
REM Step 3: Frontend Setup
REM ========================================
echo [3/3] Setting up Frontend...
echo.

REM Check Node.js
where node >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo WARNING: Node.js not found!
    echo Please install Node.js from https://nodejs.org
    echo Skipping frontend setup...
    goto :end_frontend
)

cd frontend
echo Installing npm dependencies...
call npm install
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Failed to install npm dependencies!
    pause
    exit /b 1
)

if not exist ".env.local" (
    echo VITE_API_BASE_URL=http://localhost:8000 > .env.local
    echo ✓ Created .env.local
)
echo ✓ Frontend setup complete
cd ..

:end_frontend

echo.
echo ========================================
echo Setup Complete!
echo ========================================
echo.
echo To run the project:
echo   1. Backend:  Run run_backend.bat (or cd backend ^&^& .venv\Scripts\activate ^&^& set PYTHONPATH=.. ^&^& uvicorn app.main:app --reload --port 8000)
echo   2. Frontend: Run run_frontend.bat (or cd frontend ^&^& npm run dev -- --port 5173)
echo.
echo Then visit: http://localhost:5173
echo.
pause

