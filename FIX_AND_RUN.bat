@echo off
REM Complete Fix and Run Script
REM This fixes pydantic-core and runs the backend

echo ========================================
echo Fixing pydantic-core and Starting Backend
echo ========================================
echo.

cd /d "%~dp0backend"

REM Check if venv exists
if not exist ".venv" (
    echo ERROR: Virtual environment not found!
    echo Please run setup_all.bat first.
    pause
    exit /b 1
)

REM Activate venv
call .venv\Scripts\activate.bat

echo Python version:
python --version
echo.

REM Check if pydantic-core is broken
python -c "import pydantic_core._pydantic_core" 2>nul
if %ERRORLEVEL% EQU 0 (
    echo ✓ pydantic-core is working!
    goto :start_server
)

echo ✗ pydantic-core is broken. Fixing...
echo.

REM Uninstall broken packages
echo Step 1: Removing broken packages...
pip uninstall -y pydantic pydantic-core pydantic-settings 2>nul

REM Upgrade pip
echo Step 2: Upgrading pip...
python -m pip install --upgrade pip setuptools wheel --quiet

REM Try to install pydantic-core
echo Step 3: Installing pydantic-core...
echo.

REM Method 1: Try latest version (might have Python 3.14 support)
pip install --upgrade --no-cache-dir "pydantic-core>=2.23.0" 2>nul
if %ERRORLEVEL% EQU 0 (
    python -c "import pydantic_core._pydantic_core" 2>nul
    if %ERRORLEVEL% EQU 0 (
        echo ✓ pydantic-core installed successfully!
        goto :install_rest
    )
)

REM Method 2: Check for Rust
echo Checking for Rust compiler...
where rustc >nul 2>&1
where cargo >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo Rust found! Building from source...
    pip install --no-binary pydantic-core "pydantic-core>=2.23.0" --no-cache-dir
    python -c "import pydantic_core._pydantic_core" 2>nul
    if %ERRORLEVEL% EQU 0 (
        echo ✓ pydantic-core built successfully!
        goto :install_rest
    )
) else (
    echo.
    echo ✗ Rust not found. Cannot build from source.
    echo.
)

REM If we get here, installation failed
echo.
echo ========================================
echo ✗ FAILED to fix pydantic-core!
echo ========================================
echo.
echo SOLUTIONS:
echo.
echo Option 1: Install Rust (allows building from source)
echo   1. Download from: https://rustup.rs/
echo   2. Install and restart terminal
echo   3. Run this script again
echo.
echo Option 2: Use Python 3.11 or 3.12 (RECOMMENDED)
echo   1. Install Python 3.11/3.12 from python.org
echo   2. Delete venvs: rmdir /s /q ml_model\.venv backend\.venv
echo   3. Run: setup_all.bat
echo.
echo See SOLUTION_NOW.md for detailed instructions.
echo.
pause
exit /b 1

:install_rest
echo.
echo Step 4: Installing pydantic packages...
pip install "pydantic>=2.9.0" --quiet
pip install "pydantic-settings>=2.4.0" --quiet

echo.
echo Step 5: Verifying...
python -c "import pydantic; import pydantic_core; print('✓ All pydantic packages working!')" 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo ✗ Verification failed!
    pause
    exit /b 1
)

:start_server
echo.
echo ========================================
echo Starting Backend Server...
echo ========================================
echo.

REM Set PYTHONPATH
cd ..
set PYTHONPATH=%CD%
cd backend

REM Start server
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000

