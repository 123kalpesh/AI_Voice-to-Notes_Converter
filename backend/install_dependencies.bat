@echo off
REM Smart dependency installer that handles Python 3.14 compatibility issues

echo ========================================
echo Installing Backend Dependencies
echo ========================================
echo.

REM Check Python version
python --version
for /f "tokens=2" %%i in ('python --version') do set PYTHON_VERSION=%%i
echo Detected Python version: %PYTHON_VERSION%

REM Activate venv if not already active
if not defined VIRTUAL_ENV (
    if exist ".venv\Scripts\activate.bat" (
        call .venv\Scripts\activate.bat
    )
)

REM Upgrade pip first
echo.
echo Upgrading pip...
python -m pip install --upgrade pip setuptools wheel

REM Try to install pydantic-core from pre-built wheel first
echo.
echo Attempting to install pydantic-core (pre-built wheel)...
python -m pip install --only-binary :all: pydantic-core 2>nul
if %ERRORLEVEL% EQU 0 (
    echo ✓ pydantic-core installed from pre-built wheel
) else (
    echo ⚠ Pre-built wheel not available for this Python version
    echo   Trying to install compatible version...
    python -m pip install "pydantic-core>=2.23.0" --prefer-binary
)

REM Install other dependencies
echo.
echo Installing other dependencies...
python -m pip install fastapi==0.115.0
python -m pip install "uvicorn[standard]==0.30.0"
python -m pip install python-multipart==0.0.9
python -m pip install "pydantic>=2.9.0"
python -m pip install "pydantic-settings>=2.4.0"
python -m pip install SQLAlchemy==2.0.35
python -m pip install alembic==1.13.3
python -m pip install requests==2.32.3

REM Verify installation
echo.
echo Verifying installation...
python -c "import pydantic; import pydantic_core; print('✓ Pydantic installed successfully!')" 2>nul
if %ERRORLEVEL% EQU 0 (
    echo ✓ All dependencies installed successfully!
) else (
    echo.
    echo ⚠ WARNING: pydantic-core installation may have issues
    echo.
    echo Solutions:
    echo   1. Use Python 3.11 or 3.12 (recommended for best compatibility)
    echo   2. Install Rust: https://rustup.rs/ (if you must use Python 3.14)
    echo   3. Try: pip install --upgrade pydantic pydantic-core --no-cache-dir
    echo.
)

echo.
pause

