@echo off
REM Fixed whisper installation that handles Python 3.14 numba issues

echo ========================================
echo Installing Whisper (Fixed for Python 3.14)
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

echo Step 1: Installing required dependencies first...
pip install --upgrade pip setuptools wheel --quiet

echo.
echo Step 2: Installing torch (required by whisper)...
pip install torch --quiet
if %ERRORLEVEL% NEQ 0 (
    echo Installing torch (this may take a while)...
    pip install torch
)

echo.
echo Step 3: Installing numpy and soundfile...
pip install numpy soundfile --quiet

echo.
echo Step 4: Installing whisper WITHOUT numba (workaround for Python 3.14)...
echo.
echo Attempting to install whisper...
pip install openai-whisper --no-deps
if %ERRORLEVEL% EQU 0 (
    echo Installing whisper dependencies manually...
    pip install tiktoken more-itertools
    echo.
    echo ✓ Whisper installed (without numba - may have limited functionality)
    echo.
    echo Testing import...
    python -c "import whisper; print('✓ Whisper imported successfully!')" 2>nul
    if %ERRORLEVEL% EQU 0 (
        echo ✓ Whisper is working!
        goto :success
    )
)

echo.
echo Method 1 failed. Trying method 2: Install numba separately...
echo.
echo Installing numba (this may take several minutes and requires compilation)...
pip install numba
if %ERRORLEVEL% EQU 0 (
    echo Installing whisper with all dependencies...
    pip install openai-whisper
    python -c "import whisper; print('✓ Whisper installed successfully!')" 2>nul
    if %ERRORLEVEL% EQU 0 (
        goto :success
    )
)

echo.
echo Method 2 failed. Trying method 3: Use older compatible versions...
echo.
pip install "numba<0.60" 2>nul
pip install openai-whisper
python -c "import whisper; print('✓ Whisper installed!')" 2>nul
if %ERRORLEVEL% EQU 0 (
    goto :success
)

echo.
echo ========================================
echo ✗ All installation methods failed!
echo ========================================
echo.
echo RECOMMENDED SOLUTION: Use Python 3.11 or 3.12
echo.
echo Python 3.14 has compatibility issues with:
echo   - pydantic-core (needs Rust)
echo   - numba (needs compilation)
echo   - Many other packages
echo.
echo Steps to switch:
echo   1. Install Python 3.11 or 3.12 from python.org
echo   2. Delete venvs: rmdir /s /q ml_model\.venv backend\.venv
echo   3. Run: setup_all.bat
echo.
pause
exit /b 1

:success
echo.
echo ========================================
echo ✓ Whisper installed successfully!
echo ========================================
echo.
echo You can now run the backend with:
echo   run_backend.bat
echo.
pause
exit /b 0

