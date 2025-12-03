# Quick Start Guide - AI Voice-to-Notes Converter

## 🚀 Fastest Way to Get Started

### Option 1: Automated Setup (Recommended)

Run the complete setup script:
```bat
setup_all.bat
```

This will set up everything automatically. Then run:

**Terminal 1 - Backend:**
```bat
run_backend.bat
```

**Terminal 2 - Frontend:**
```bat
run_frontend.bat
```

Visit: **http://localhost:5173**

---

### Option 2: Manual Setup

#### Prerequisites Check
- ✅ Python 3.10+ installed
- ✅ Node.js 18+ installed  
- ✅ FFmpeg installed (for Whisper)

#### Step-by-Step

**1. ML Model Setup**
```bat
cd ml_model
python -m venv .venv
.venv\Scripts\activate
pip install -r requirements.txt
deactivate
cd ..
```

**2. Backend Setup**
```bat
cd backend
python -m venv .venv
.venv\Scripts\activate
pip install -r requirements.txt
deactivate
cd ..
```

**3. Frontend Setup**
```bat
cd frontend
npm install
echo VITE_API_BASE_URL=http://localhost:8000 > .env.local
cd ..
```

**4. Run Services**

**Terminal 1:**
```bat
cd backend
.venv\Scripts\activate
set PYTHONPATH=..
uvicorn app.main:app --reload --port 8000
```

**Terminal 2:**
```bat
cd frontend
npm run dev -- --port 5173
```

---

## 🔧 Troubleshooting

### "node is not recognized"
- Install Node.js from https://nodejs.org
- Make sure "Add to PATH" is checked during installation
- Restart your terminal after installation

### "pydantic_core module not found"
```bat
cd backend
.venv\Scripts\activate
pip uninstall -y pydantic pydantic-core pydantic-settings
pip install --upgrade pip
pip install -r requirements.txt
```

### "No module named 'ml_model'"
- Make sure you set `PYTHONPATH=..` before running uvicorn
- Or use `run_backend.bat` which handles this automatically

### "FFmpeg not found" (Whisper error)
- Install FFmpeg from https://ffmpeg.org/download.html
- Add to Windows PATH:
  - System Properties → Environment Variables → Path → Add FFmpeg bin folder

### Python 3.14 Compatibility Issues
- If you have issues with Python 3.14, use Python 3.11 or 3.12 instead
- These versions have better package compatibility

---

## 📝 Testing the API

Once backend is running, test with:

```bat
REM Health check
curl http://localhost:8000/health

REM Upload audio (replace path with your audio file)
curl -X POST "http://localhost:8000/api/upload-audio" -F "file=@C:\path\to\audio.wav"

REM Create note
curl -X POST "http://localhost:8000/api/notes" -H "Content-Type: application/json" -d "{\"title\":\"Test\",\"content\":\"Hello\"}"
```

---

## 🎯 Project Structure

```
AI_Voice-to-Notes_Converter/
├── ml_model/          # Whisper transcription module
├── backend/           # FastAPI server
├── frontend/          # React + Vite app
├── setup_all.bat      # Complete setup script
├── run_backend.bat    # Backend runner
├── run_frontend.bat   # Frontend runner
└── README.md          # Full documentation
```

---

## ✅ Verification Checklist

After setup, verify:

- [ ] Backend starts without errors: `http://localhost:8000/health` returns `{"status":"ok"}`
- [ ] Frontend starts without errors: `http://localhost:5173` loads
- [ ] Frontend can connect to backend (check browser console for errors)
- [ ] Audio upload works (try recording or uploading a file)
- [ ] Transcription appears in notes editor

---

## 🆘 Still Having Issues?

1. Check all error messages carefully
2. Make sure all prerequisites are installed
3. Try running `setup_all.bat` again
4. Check `SETUP.md` for detailed troubleshooting
5. Verify Python and Node versions:
   ```bat
   python --version  (should be 3.10+)
   node -v           (should be 18+)
   ```

