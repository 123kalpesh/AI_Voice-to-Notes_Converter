@echo off
REM Complete Frontend Runner Script
REM This script handles all setup and runs the frontend dev server

echo ========================================
echo AI Voice-to-Notes Converter - Frontend
echo ========================================
echo.

REM Check if Node.js is available
where node >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Node.js is not installed or not in PATH!
    echo.
    echo Please install Node.js LTS from: https://nodejs.org
    echo Make sure to check "Add to PATH" during installation.
    echo.
    echo After installing, restart this terminal and try again.
    pause
    exit /b 1
)

echo Node.js found:
node -v
npm -v
echo.

REM Navigate to frontend directory
cd /d "%~dp0frontend"
if not exist "src" (
    echo ERROR: Frontend directory structure not found!
    pause
    exit /b 1
)

REM Check if node_modules exists
if not exist "node_modules" (
    echo Installing npm dependencies (this may take a few minutes)...
    call npm install
    if %ERRORLEVEL% NEQ 0 (
        echo ERROR: Failed to install npm dependencies!
        pause
        exit /b 1
    )
) else (
    echo Checking for npm dependency updates...
    call npm install
)

REM Create .env.local if it doesn't exist
if not exist ".env.local" (
    echo Creating .env.local file...
    echo VITE_API_BASE_URL=http://localhost:8000 > .env.local
    echo ✓ Created .env.local
) else (
    echo ✓ .env.local already exists
)

echo.
echo ========================================
echo Starting Vite dev server...
echo ========================================
echo Frontend will be available at: http://localhost:5173
echo Press CTRL+C to stop
echo.

REM Start Vite dev server
call npm run dev -- --port 5173

