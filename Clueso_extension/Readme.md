# Clueso Chrome Extension

Chrome extension for capturing screen recordings with audio and DOM events.

## Features

- **Screen Recording** - Capture screen video using Chrome's MediaRecorder API
- **Audio Recording** - Record microphone audio simultaneously
- **DOM Event Capture** - Track clicks, inputs, scrolls, and interactions
- **Real-time Streaming** - Upload chunks to backend while recording
- **Session Management** - Unique session IDs for each recording

## Tech Stack

- React 19.2.0
- Vite 7.2.4
- Chrome Manifest V3
- Offscreen Document API

## Installation

### Development Mode

1. **Install dependencies:**
   ```bash
   npm install
   ```

2. **Build the extension:**
   ```bash
   npm run build
   ```

3. **Load in Chrome:**
   - Open `chrome://extensions/`
   - Enable "Developer mode"
   - Click "Load unpacked"
   - Select the `dist/` folder

### Production Build

```bash
npm run build
```

The built extension will be in the `dist/` folder.

## Usage

1. Click the Clueso icon in Chrome toolbar
2. Click "Start Recording"
3. Select screen to share
4. Grant microphone permission
5. Perform actions on the webpage
6. Click "Stop Recording"
7. View recording at http://localhost:3000

## Architecture

### Files

- **background.js** - Service worker, manages recording lifecycle
- **content-script.js** - Injected into pages to capture DOM events
- **offscreen.js** - Offscreen document for screen capture
- **popup.jsx** - Extension popup UI (React)
- **manifest.json** - Extension configuration

### Recording Flow

```
User clicks Start
  ↓
background.js creates offscreen document
  ↓
offscreen.js starts MediaRecorder
  ↓
Chunks streamed to Node.js backend
  ↓
content-script.js captures DOM events
  ↓
User clicks Stop
  ↓
Finalize request to backend
```

### Data Captured

**Video:**
- Codec: VP9
- Container: WebM
- Sent as binary chunks

**Audio:**
- Codec: Opus
- Container: WebM
- Sent as binary chunks

**DOM Events:**
- Click, input, focus, blur, scroll
- Element selector, text, position
- Timestamp relative to recording start

## Configuration

Backend URL is configured in `background.js`:

```javascript
const NODE_SERVER_URL = "http://localhost:3002/api/recording/process-recording";
```

## API Endpoints

The extension calls these Node.js backend endpoints:

- `POST /api/recording/video-chunk` - Upload video chunk
- `POST /api/recording/audio-chunk` - Upload audio chunk  
- `POST /api/recording/process-recording` - Finalize recording

## Permissions

Required permissions (in manifest.json):

- `activeTab` - Access current tab
- `tabCapture` - Capture screen
- `offscreen` - Create offscreen document
- `storage` - Store session data

## Development

### Reload Extension After Changes

1. `npm run build`
2. Go to `chrome://extensions/`
3. Click reload icon on Clueso extension

### Debug Extension

- **Popup:** Right-click extension icon → "Inspect popup"
- **Background:** `chrome://extensions/` → "Inspect views: background page"
- **Content Script:** Open page console (F12)

### Build Commands

```bash
npm run dev      # Development mode (watch)
npm run build    # Production build
npm run preview  # Preview build
```

## Troubleshooting

**Extension not loading?**
- Check console for errors: `chrome://extensions/`
- Ensure all files in `dist/` folder
- Verify manifest.json is valid

**Recording not starting?**
- Check permissions granted
- Verify backend is running (http://localhost:3002)
- Check network tab for failed requests

**No audio captured?**
- Grant microphone permission
- Check browser mic settings
- Verify AudioContext created successfully

**Events not captured?**
- Open page console to see content-script logs
- Verify content-script.js injected
- Check if page has CSP blocking scripts

## License

MIT
