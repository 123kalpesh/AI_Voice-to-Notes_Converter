@echo off
REM Verification Script - Checks if everything is set up correctly

echo ========================================
echo Project Setup Verification
echo ========================================
echo.

set ERRORS=0

REM Check Python
echo [1] Checking Python...
python --version >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo   ✗ Python not found!
    set /a ERRORS+=1
) else (
    python --version
    echo   ✓ Python found
)
echo.

REM Check Node.js
echo [2] Checking Node.js...
where node >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo   ✗ Node.js not found!
    set /a ERRORS+=1
) else (
    node -v
    echo   ✓ Node.js found
)
echo.

REM Check ml_model setup
echo [3] Checking ML Model setup...
if not exist "ml_model\.venv" (
    echo   ✗ ML Model virtual environment not found!
    echo     Run: cd ml_model ^&^& python -m venv .venv
    set /a ERRORS+=1
) else (
    echo   ✓ ML Model venv exists
    ml_model\.venv\Scripts\python.exe -c "import whisper" >nul 2>&1
    if %ERRORLEVEL% NEQ 0 (
        echo   ✗ Whisper not installed in ML Model venv!
        echo     Run: cd ml_model ^&^& .venv\Scripts\activate ^&^& pip install -r requirements.txt
        set /a ERRORS+=1
    ) else (
        echo   ✓ Whisper installed
    )
)
echo.

REM Check backend setup
echo [4] Checking Backend setup...
if not exist "backend\.venv" (
    echo   ✗ Backend virtual environment not found!
    echo     Run: cd backend ^&^& python -m venv .venv
    set /a ERRORS+=1
) else (
    echo   ✓ Backend venv exists
    backend\.venv\Scripts\python.exe -c "import fastapi" >nul 2>&1
    if %ERRORLEVEL% NEQ 0 (
        echo   ✗ FastAPI not installed in Backend venv!
        echo     Run: cd backend ^&^& .venv\Scripts\activate ^&^& pip install -r requirements.txt
        set /a ERRORS+=1
    ) else (
        echo   ✓ FastAPI installed
    )
)
echo.

REM Check frontend setup
echo [5] Checking Frontend setup...
if not exist "frontend\node_modules" (
    echo   ✗ Frontend node_modules not found!
    echo     Run: cd frontend ^&^& npm install
    set /a ERRORS+=1
) else (
    echo   ✓ Frontend node_modules exists
    if not exist "frontend\.env.local" (
        echo   ⚠ Frontend .env.local not found (will be created automatically)
    ) else (
        echo   ✓ Frontend .env.local exists
    )
)
echo.

REM Check project structure
echo [6] Checking project structure...
if not exist "ml_model\main.py" (
    echo   ✗ ml_model\main.py not found!
    set /a ERRORS+=1
) else (
    echo   ✓ ml_model\main.py exists
)
if not exist "backend\app\main.py" (
    echo   ✗ backend\app\main.py not found!
    set /a ERRORS+=1
) else (
    echo   ✓ backend\app\main.py exists
)
if not exist "frontend\src\App.tsx" (
    echo   ✗ frontend\src\App.tsx not found!
    set /a ERRORS+=1
) else (
    echo   ✓ frontend\src\App.tsx exists
)
echo.

REM Summary
echo ========================================
if %ERRORS% EQU 0 (
    echo ✓ All checks passed! Project is ready to run.
    echo.
    echo To start the project:
    echo   1. Run run_backend.bat in one terminal
    echo   2. Run run_frontend.bat in another terminal
) else (
    echo ✗ Found %ERRORS% issue(s). Please fix them before running.
    echo.
    echo Quick fix: Run setup_all.bat to set up everything automatically.
)
echo ========================================
echo.
pause

