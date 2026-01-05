# AI-Powered Screen Recording Platform

A complete full-stack application for recording screen interactions with AI-generated narration. Capture user actions, generate professional product demo scripts, and create polished presentations automatically.

## 🎯 Features

- **Screen + Audio Recording** - Chrome extension captures screen, microphone, and DOM events
- **AI Transcription** - Deepgram converts speech to text with word-level timing
- **AI Script Generation** - Google Gemini creates professional demo scripts from transcripts
- **AI Narration** - Deepgram TTS generates natural-sounding voiceover
- **Interactive Player** - Timeline scrubber, event markers, transcript panel
- **Export Options** - Download recordings with original or AI narration

## 🏗️ Architecture

### **Chrome Extension** (`Clueso_extension/`)
- React 19.2.0 + Vite 7.2.4
- Manifest V3 with offscreen document API
- Captures: Screen video (VP9), audio (Opus), DOM events
- Real-time streaming to backend via FormData chunks

### **Frontend** (`Clueso_Frontend_layer/`)
- Next.js 16.0.7 + React 19.2.0
- WebSocket connection for real-time updates
- Video player with timeline, events overlay, transcript sync
- Runs on: **http://localhost:3000**

### **Node.js Backend** (`Clueso_Node_layer/`)
- Express 5.1.0 + Socket.IO 4.8.1
- Handles recording chunks, orchestrates AI pipeline
- Deepgram SDK 4.11.2 for transcription
- Runs on: **http://localhost:3002**

### **Python AI Layer** (`python-genai/`)
- FastAPI + Google GenAI SDK 1.56.0
- Gemini 2.5 Flash for script generation
- Deepgram TTS for voice synthesis
- Runs on: **http://localhost:8000**

## 🚀 Quick Start

### Prerequisites
- Node.js 18+ and npm
- Python 3.10+
- Chrome browser
- API Keys:
  - Google Gemini API key
  - Deepgram API key

### 1. Install Dependencies
```powershell
.\INSTALL_DEPENDENCIES.ps1
```

### 2. Configure API Keys

**Node.js Backend** (`Clueso_Node_layer/.env`):
```env
DEEPGRAM_API_KEY=your_deepgram_key
PORT=3002
```

**Python AI Layer** (`python-genai/.env`):
```env
GEMINI_API_KEY=your_gemini_key
DEEPGRAM_API_KEY=your_deepgram_key
PORT=8000
```

### 3. Start All Services
```powershell
.\START_ALL_SERVICES.ps1
```

This starts:
- ✅ Node.js Backend (Port 3002)
- ✅ Python AI Layer (Port 8000)  
- ✅ Next.js Frontend (Port 3000)

### 4. Load Chrome Extension
1. Open Chrome: `chrome://extensions/`
2. Enable "Developer mode"
3. Click "Load unpacked"
4. Select: `Clueso_extension/dist`

### 5. Record a Demo
1. Open any website
2. Click Clueso extension icon
3. Grant screen + microphone permissions
4. Click "Start Recording"
5. Perform actions on the page
6. Click "Stop Recording"
7. Go to `http://localhost:3000` to view

## 📁 Project Structure

```
Clueso_clone_example/
├── START_ALL_SERVICES.ps1      # Launch all services
├── STOP_ALL_SERVICES.ps1        # Stop all services
├── TEST_AUDIO_PIPELINE.ps1      # Diagnostic tool
│
├── Clueso_extension/            # Chrome Extension
│   ├── dist/                    # Built extension (load this in Chrome)
│   ├── public/                  # Source files
│   │   ├── background.js        # Service worker
│   │   ├── content-script.js    # DOM event capture
│   │   ├── offscreen.js         # Screen recording
│   │   └── manifest.json        # Extension config
│   └── src/                     # React popup UI
│
├── Clueso_Frontend_layer/       # Next.js Frontend
│   ├── app/
│   │   ├── page.tsx             # Home page
│   │   └── recording/[sessionId]/page.tsx  # Player
│   ├── components/
│   │   ├── VideoPlayerLayout.tsx           # Main player
│   │   ├── Timeline.tsx                    # Scrubber
│   │   ├── TranscriptPanel.tsx             # Transcript
│   │   └── EventOverlay.tsx                # DOM event markers
│   └── hooks/
│       └── useWebSocketConnection.ts       # Socket.IO client
│
├── Clueso_Node_layer/           # Node.js Backend
│   ├── src/
│   │   ├── index.js             # Server entry
│   │   ├── controllers/         # Request handlers
│   │   ├── services/            # Business logic
│   │   │   ├── recording-service.js
│   │   │   ├── deepgram-service.js
│   │   │   ├── python-service.js
│   │   │   └── frontend-service.js
│   │   └── routes/              # API routes
│   ├── recordings/              # AI-generated MP3 files
│   └── src/recordings/          # Raw WebM recordings
│
└── python-genai/                # Python AI Layer
    ├── app/
    │   ├── main.py              # FastAPI server
    │   └── services/
    │       ├── gemini_service.py           # AI script generation
    │       ├── script_generation_service.py # RAG-based processing
    │       ├── synced_narration_service.py # Timeline sync
    │       └── elevenlabs_service.py       # Deepgram TTS (misnamed)
    └── requirements.txt
```

## 🔄 Data Flow

1. **Recording Phase**
   - Extension captures screen/audio/events → Chunks → Node.js
   - Node.js saves to `src/recordings/`

2. **AI Processing Phase**
   - Node.js → Deepgram → Transcription
   - Node.js → Python → Gemini AI → Script
   - Python → Deepgram TTS → MP3 narration
   - Python → Node.js → `recordings/*.mp3`

3. **Playback Phase**
   - Frontend connects via WebSocket
   - Node.js broadcasts: video, audio, transcript, events
   - Player displays timeline with event markers

## 🛠️ API Endpoints

### Node.js Backend (Port 3002)

**Recording:**
- `POST /api/recording/video-chunk` - Upload video chunk
- `POST /api/recording/audio-chunk` - Upload audio chunk
- `POST /api/recording/process-recording` - Finalize recording

**Static Files:**
- `GET /recordings/*` - Raw WebM files (video/audio)
- `GET /ai-audio/*` - AI-generated MP3 narration

### Python AI (Port 8000)

- `POST /audio-full-process` - Full AI pipeline
- `GET /docs` - Swagger API documentation

## 🧪 Testing

Test the AI pipeline without recording:
```powershell
.\TEST_AUDIO_PIPELINE.ps1
```

This checks:
1. ✅ Audio file exists
2. ✅ Deepgram transcription works
3. ✅ Python service is running
4. ✅ Full AI processing succeeds
5. ✅ MP3 file generated

## 🐛 Troubleshooting

**Video not loading?**
- Check browser console (F12) for 404 errors
- Verify services running: `Get-Process node,python`
- Check static routes in Node.js logs

**Timeline scrubber not working?**
- Open browser console (F12)
- Look for `[VideoPlayerLayout]` and `[Timeline]` logs
- Verify video metadata loaded

**Extension not recording?**
- Reload extension: `chrome://extensions/`
- Check extension console: Right-click extension → "Inspect popup"
- Verify permissions granted

## 📦 Dependencies

**Extension:**
- react@19.2.0, vite@7.2.4

**Frontend:**
- next@16.0.7, react@19.2.0, socket.io-client@4.8.1

**Node.js:**
- express@5.1.0, socket.io@4.8.1, @deepgram/sdk@4.11.2, multer@1.4.5-lts.1

**Python:**
- fastapi, uvicorn, google-genai@1.56.0, requests, python-dotenv

## 🔑 API Keys Setup

### Get Deepgram API Key
1. Go to https://deepgram.com/
2. Sign up for free account
3. Copy API key from dashboard
4. Add to both `.env` files

### Get Gemini API Key
1. Go to https://aistudio.google.com/
2. Click "Get API Key"
3. Create new key
4. Add to `python-genai/.env`

## 📝 License

MIT

## 🙏 Credits

Built with:
- Google Gemini AI
- Deepgram (Transcription + TTS)
- React + Next.js
- FastAPI
- Express + Socket.IO
