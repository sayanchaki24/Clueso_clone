# Clueso Node.js Backend

Express.js backend server for managing recordings, orchestrating AI processing, and serving the frontend.

## Features

- **Recording Management** - Handle video/audio chunk uploads
- **Deepgram Integration** - Transcribe audio to text
- **Python AI Orchestration** - Send data to Python for AI processing
- **WebSocket Server** - Real-time updates to frontend via Socket.IO
- **Static File Serving** - Serve recordings and AI-generated audio

## Installation

```bash
npm install
```

## Configuration

Create `.env` file:

```env
DEEPGRAM_API_KEY=your_deepgram_key_here
PORT=3002
PYTHON_API_URL=http://localhost:8000
```

## Running

```bash
npm start
```

Server runs on: **http://localhost:3002**

## API Endpoints

**POST** `/api/recording/video-chunk` - Upload video chunk  
**POST** `/api/recording/audio-chunk` - Upload audio chunk  
**POST** `/api/recording/process-recording` - Finalize recording

**GET** `/recordings/:filename` - Raw WebM files  
**GET** `/ai-audio/:filename` - AI-generated MP3

## License

MIT
