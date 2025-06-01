# agents.kelly

**Google ADK Agent with Streaming Audio & Real-time Chat**

A sophisticated AI agent implementation using Google's Agent Development Kit (ADK) framework with FastAPI backend, featuring real-time streaming communication, audio interface, and Google Search integration.

## 🌟 Features

- **🔍 Google Search Agent**: Real-time search capabilities using Google's search API
- **🎙️ Audio Streaming**: Voice-to-voice communication with audio processing
- **⚡ Real-time Chat**: Server-Sent Events (SSE) for instant messaging
- **🔄 Auto-reload**: Development server with hot reload
- **🎯 Multiple Endpoints**: RESTful API with streaming support

## 🚀 Quick Start

### Prerequisites

- Python 3.9+ 
- Virtual environment activated
- Google API Key (for search functionality)

### Installation

1. **Install Dependencies**:
   ```bash
   pip install google-adk
   ```

2. **Set Environment Variables**:
   ```bash
   # In app/.env file
   GOOGLE_GENAI_USE_VERTEXAI=FALSE
   GOOGLE_API_KEY=your_google_api_key_here
   ```

3. **Run the Application**:
   ```bash
   cd app/
   uvicorn main:app --reload --host 127.0.0.1 --port 8000
   ```

4. **Access the Interface**:
   - Open browser: http://127.0.0.1:8000
   - Click "Start Audio" for voice interface
   - Type messages for text chat

## 📁 Project Structure

```
agents.kelly/
├── app/                          # FastAPI Application
│   ├── .env                     # Environment variables
│   ├── main.py                  # FastAPI server with streaming
│   ├── google_search_agent/     # Agent implementation
│   │   ├── __init__.py
│   │   └── agent.py            # Google Search Agent definition
│   └── static/                  # Frontend assets
│       ├── index.html          # Web interface
│       └── js/                 # Audio worklets & client code
│           ├── app.js          # Main client application
│           ├── audio-player.js  # Audio playback handling
│           ├── audio-recorder.js # Audio recording handling
│           ├── pcm-player-processor.js  # Audio worklet
│           └── pcm-recorder-processor.js # Audio worklet
├── chatty-kelly/               # Legacy agent (alternative)
├── Makefile                    # Build & run commands
├── README.md                   # This file
└── workflow_state.md          # Development log
```

## 🔧 Development Commands

Use the Makefile for common development tasks:

```bash
make help          # Show available commands
make install       # Install dependencies
make run-uvicorn   # Run with uvicorn (recommended)
make run-adk       # Run with ADK web (if adk installed)
make dev-uvicorn   # Run uvicorn + open browser
make clean         # Clean temporary files
make status        # Show project status
```

## 🌐 API Endpoints

- **GET /**: Web interface (index.html)
- **GET /events/{user_id}**: SSE endpoint for real-time agent communication
- **POST /send/{user_id}**: Send messages/audio to agent
- **Static files**: `/static/*` for frontend assets

## 🎙️ Audio Features

The application supports full-duplex audio communication:

- **Audio Input**: 16kHz PCM recording from microphone
- **Audio Output**: 24kHz PCM playback to speakers  
- **Real-time Processing**: Streaming audio via WebRTC-like protocols
- **Format Support**: PCM audio encoding/decoding

## 🔍 Google Search Integration

The agent uses Google's search API to provide real-time information:

- **Tool**: `google_search` from Google ADK
- **Model**: `gemini-2.0-flash-exp` or `gemini-2.0-flash-live-001`
- **Capabilities**: Web search, information retrieval, Q&A

## 🔧 Troubleshooting

### Common Issues

1. **ModuleNotFoundError: No module named 'google'**
   ```bash
   pip install google-adk
   ```

2. **Server not accessible**
   - Check if port 8000 is available
   - Verify server is running: `ps aux | grep uvicorn`
   - Try: `curl http://127.0.0.1:8000`

3. **Audio not working**
   - Enable microphone permissions in browser
   - Check console for JavaScript errors
   - Verify audio worklet files are served correctly

4. **Environment variables**
   - Ensure `.env` file exists in `app/` directory
   - Verify `GOOGLE_API_KEY` is set correctly

## 📊 Performance

- **Startup Time**: ~2-3 seconds
- **Audio Latency**: <200ms for voice processing
- **Memory Usage**: ~60-80MB (with Google ADK)
- **Concurrent Users**: Supports multiple simultaneous sessions

## 🔄 Alternative Running Methods

### Method 1: uvicorn (Recommended)
```bash
cd app/
uvicorn main:app --reload --host 127.0.0.1 --port 8000
```

### Method 2: Google ADK (if available)
```bash
cd app/
adk web
```

## 📝 Development Notes

- Uses Google ADK 1.1.1+ for agent framework
- FastAPI for web server and API endpoints  
- WebRTC audio worklets for real-time audio processing
- Server-Sent Events for real-time communication
- Environment-based configuration via `.env`

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test with `make dev-uvicorn`
5. Submit a pull request

## 📄 License

GNU Affero General Public License v3.0 - see LICENSE file for details.
