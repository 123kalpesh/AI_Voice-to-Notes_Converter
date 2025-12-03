@echo off
REM Backend Setup Script for Windows
echo Setting up backend environment...

REM Activate virtual environment
call .venv\Scripts\activate

REM Upgrade pip first
python -m pip install --upgrade pip

REM Uninstall potentially corrupted pydantic packages
pip uninstall -y pydantic pydantic-core pydantic-settings

REM Reinstall all dependencies
pip install -r requirements.txt

REM Verify installation
python -c "import pydantic; import pydantic_core; print('Pydantic installed successfully!')"

echo.
echo Backend setup complete!
echo.
echo To run the backend:
echo   1. Activate venv: .venv\Scripts\activate
echo   2. Set PYTHONPATH: set PYTHONPATH=..
echo   3. Start server: uvicorn app.main:app --reload --port 8000

