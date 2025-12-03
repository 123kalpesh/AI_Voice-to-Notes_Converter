@echo off
REM Frontend Setup Script for Windows
echo Setting up frontend environment...

REM Check if Node.js is installed
where node >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Node.js is not installed or not in PATH!
    echo Please install Node.js from https://nodejs.org
    echo Make sure to check "Add to PATH" during installation.
    pause
    exit /b 1
)

echo Node.js found!
node -v
npm -v

REM Install dependencies
echo.
echo Installing npm dependencies...
call npm install

REM Create .env.local if it doesn't exist
if not exist .env.local (
    echo VITE_API_BASE_URL=http://localhost:8000 > .env.local
    echo Created .env.local file
)

echo.
echo Frontend setup complete!
echo.
echo To run the frontend:
echo   npm run dev -- --port 5173

