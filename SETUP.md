# Setup Instructions - AI Voice-to-Notes Converter

## Quick Fix for Current Errors

### Error 1: npm install from wrong directory
**Problem:** Running `npm install` from project root instead of `frontend/` folder.

**Solution:**
```bat
cd frontend
npm install
```

Or use the provided script:
```bat
cd frontend
setup_frontend.bat
```

---

### Error 2: pydantic_core module not found
**Problem:** Corrupted or incomplete pydantic installation (common with Python 3.14).

**Solution:** Reinstall backend dependencies:

```bat
cd backend
.venv\Scripts\activate
pip uninstall -y pydantic pydantic-core pydantic-settings
pip install --upgrade pip
pip install -r requirements.txt
```

Or use the provided script:
```bat
cd backend
setup_backend.bat
```

---

## Complete Setup Guide

### Prerequisites
1. **Python 3.10+** (3.11 or 3.12 recommended; Python 3.14 may have compatibility issues)
2. **Node.js 18+** (LTS version from https://nodejs.org)
3. **FFmpeg** (for Whisper audio processing) - add to PATH

### Step 1: ML Model Setup
```bat
cd ml_model
python -m venv .venv
.venv\Scripts\activate
pip install -r requirements.txt
```

### Step 2: Backend Setup
```bat
cd ..\backend
python -m venv .venv
.venv\Scripts\activate
pip install --upgrade pip
pip install -r requirements.txt
```

**Important:** Always set PYTHONPATH when running backend:
```bat
set PYTHONPATH=..
uvicorn app.main:app --reload --port 8000
```

### Step 3: Frontend Setup
```bat
cd ..\frontend
npm install
```

Create `.env.local`:
```bat
echo VITE_API_BASE_URL=http://localhost:8000 > .env.local
```

Run frontend:
```bat
npm run dev -- --port 5173
```

---

## Troubleshooting

### Python 3.14 Compatibility Issues
If you're using Python 3.14 and getting `pydantic_core` errors:
- **Option 1:** Use Python 3.11 or 3.12 (recommended)
- **Option 2:** Force reinstall pydantic-core:
  ```bat
  pip uninstall -y pydantic-core
  pip install --no-cache-dir pydantic-core
  ```

### Node.js Not Found
- Install Node.js from https://nodejs.org
- Make sure "Add to PATH" is checked during installation
- Restart your terminal after installation

### ml_model Import Error
- Make sure `PYTHONPATH=..` is set **before** running uvicorn
- Run backend from `backend/` directory, not project root

---

## Running All Services

**Terminal 1 - Backend:**
```bat
cd backend
.venv\Scripts\activate
set PYTHONPATH=..
uvicorn app.main:app --reload --port 8000
```

**Terminal 2 - Frontend:**
```bat
cd frontend
npm run dev -- --port 5173
```

Visit: http://localhost:5173

