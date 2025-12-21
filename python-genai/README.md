# Clueso Python AI Layer

FastAPI service for AI-powered script generation and text-to-speech narration.

## Features

- **AI Script Generation** - Google Gemini creates polished demo scripts
- **RAG Processing** - Combines transcript + word timings + DOM events
- **Text-to-Speech** - Deepgram TTS generates natural voiceover
- **Word Timing Analysis** - Detects gaps, fillers, low-confidence words

## Installation

```bash
python -m venv venv
.\venv\Scripts\Activate.ps1  # Windows
pip install -r requirements.txt
```

## Configuration

Create `.env` file:

```env
GEMINI_API_KEY=your_gemini_api_key
DEEPGRAM_API_KEY=your_deepgram_api_key
PORT=8000
```

## Running

```bash
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

Server runs on: **http://localhost:8000**  
API Docs: **http://localhost:8000/docs**

## API Endpoints

**POST** `/audio-full-process` - Full AI processing pipeline  
**GET** `/health` - Health check

## Models

- **Gemini 2.5 Flash** - Script generation
- **Deepgram Aura 2** - Text-to-speech (MP3)

## License

MIT
