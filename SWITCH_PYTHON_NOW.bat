@echo off
REM Guide script to switch from Python 3.14 to Python 3.11/3.12

echo ========================================
echo Python Version Switch Guide
echo ========================================
echo.
echo CURRENT ISSUE:
echo   numba does NOT support Python 3.14
echo   Error: "only versions ^>=3.10,^<3.14 are supported"
echo.
echo SOLUTION: Switch to Python 3.11 or 3.12
echo.
echo ========================================
echo STEP 1: Check Current Python Version
echo ========================================
python --version
echo.
echo ========================================
echo STEP 2: Download Python 3.11 or 3.12
echo ========================================
echo.
echo Please download and install one of these:
echo.
echo   Python 3.11.9 (Recommended):
echo   https://www.python.org/downloads/release/python-3119/
echo.
echo   Python 3.12.4 (Alternative):
echo   https://www.python.org/downloads/release/python-3124/
echo.
echo IMPORTANT: During installation, check "Add Python to PATH"
echo.
pause
echo.
echo ========================================
echo STEP 3: Verify New Python Version
echo ========================================
echo.
echo After installing, close this window and open a NEW terminal.
echo Then run: python --version
echo.
echo It should show Python 3.11.x or 3.12.x (NOT 3.14)
echo.
pause
echo.
echo ========================================
echo STEP 4: Clean Up Old Installation
echo ========================================
echo.
echo After verifying Python version, run these commands:
echo.
echo   rmdir /s /q ml_model\.venv
echo   rmdir /s /q backend\.venv
echo   setup_all.bat
echo.
echo This will recreate everything with the correct Python version.
echo.
pause
echo.
echo ========================================
echo STEP 5: Run the Project
echo ========================================
echo.
echo After setup completes:
echo.
echo   Terminal 1: run_backend.bat
echo   Terminal 2: run_frontend.bat
echo.
echo Then visit: http://localhost:5173
echo.
echo ========================================
pause

