@echo off
REM Fix pydantic-core installation issue for Python 3.14

echo ========================================
echo Fixing pydantic-core Installation
echo ========================================
echo.

REM Activate venv
if exist ".venv\Scripts\activate.bat" (
    call .venv\Scripts\activate.bat
) else (
    echo ERROR: Virtual environment not found!
    echo Run setup_all.bat first.
    pause
    exit /b 1
)

echo Current Python version:
python --version
echo.

echo Step 1: Uninstalling broken pydantic packages...
pip uninstall -y pydantic pydantic-core pydantic-settings 2>nul

echo.
echo Step 2: Upgrading pip, setuptools, wheel...
python -m pip install --upgrade pip setuptools wheel

echo.
echo Step 3: Attempting to install pydantic-core...
echo Trying method 1: Pre-built binary wheel...
pip install --only-binary :all: pydantic-core 2>nul
if %ERRORLEVEL% EQU 0 (
    echo ✓ pydantic-core installed from pre-built wheel
    goto :install_rest
)

echo.
echo Pre-built wheel not available. Trying method 2: Latest version...
pip install --upgrade --no-cache-dir pydantic-core
if %ERRORLEVEL% EQU 0 (
    echo ✓ pydantic-core installed
    goto :install_rest
)

echo.
echo Method 2 failed. Trying method 3: Build from source (requires Rust)...
echo.
echo WARNING: This requires Rust/Cargo to be installed!
echo If Rust is not installed, this will fail.
echo.
echo Checking for Rust...
where rustc >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    where cargo >nul 2>&1
    if %ERRORLEVEL% NEQ 0 (
        echo.
        echo ✗ Rust/Cargo not found!
        echo.
        echo SOLUTIONS:
        echo   1. Install Rust from https://rustup.rs/ (then restart terminal and run this script again)
        echo   2. Use Python 3.11 or 3.12 instead (recommended - see PYTHON_VERSION_FIX.md)
        echo.
        echo For now, trying to install without pydantic-core (may not work)...
        pip install pydantic --no-deps
        pip install pydantic-settings --no-deps
        echo.
        echo ⚠ WARNING: Installation incomplete. Backend may not work.
        echo Please install Rust or switch to Python 3.11/3.12.
        pause
        exit /b 1
    )
)

echo Rust found! Building from source...
pip install --no-binary pydantic-core pydantic-core
if %ERRORLEVEL% NEQ 0 (
    echo.
    echo ✗ Failed to build pydantic-core from source!
    echo.
    echo RECOMMENDED SOLUTION: Use Python 3.11 or 3.12
    echo See PYTHON_VERSION_FIX.md for details.
    pause
    exit /b 1
)

:install_rest
echo.
echo Step 4: Installing pydantic and pydantic-settings...
pip install "pydantic>=2.9.0"
pip install "pydantic-settings>=2.4.0"

echo.
echo Step 5: Verifying installation...
python -c "import pydantic; import pydantic_core; print('✓ SUCCESS: pydantic-core is working!')" 2>nul
if %ERRORLEVEL% EQU 0 (
    echo.
    echo ========================================
    echo ✓ pydantic-core fixed successfully!
    echo ========================================
    echo.
    echo You can now run the backend with:
    echo   run_backend.bat
    echo.
) else (
    echo.
    echo ✗ Verification failed!
    echo pydantic-core is still not working properly.
    echo.
    echo RECOMMENDED: Switch to Python 3.11 or 3.12
    echo See PYTHON_VERSION_FIX.md
    echo.
)

pause

