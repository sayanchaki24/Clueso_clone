# Clueso Clone - Start All Services Script
# This script starts all required services in separate PowerShell windows

Write-Host "Starting Clueso Clone Services..." -ForegroundColor Cyan
Write-Host ""

# Get the root directory
$rootDir = $PSScriptRoot

# Function to start a service in a new window
function Start-Service {
    param(
        [string]$Name,
        [string]$Path,
        [string]$Command,
        [string]$Color = "Green"
    )
    
    Write-Host "Starting $Name..." -ForegroundColor $Color
    
    $fullPath = Join-Path $rootDir $Path
    
    if (Test-Path $fullPath) {
        Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$fullPath'; Write-Host '$Name' -ForegroundColor $Color; $Command"
        Write-Host "$Name started in new window" -ForegroundColor Green
    } else {
        Write-Host "Path not found: $fullPath" -ForegroundColor Red
    }
    
    Start-Sleep -Seconds 2
}

# Check for .env files
Write-Host "Checking configuration files..." -ForegroundColor Yellow
Write-Host ""

$nodeEnv = Join-Path $rootDir "Clueso_Node_layer\.env"
$pythonEnv = Join-Path $rootDir "python-genai\.env"
$frontendEnv = Join-Path $rootDir "Clueso_Frontend_layer\.env.local"

if (!(Test-Path $nodeEnv)) {
    Write-Host "Warning: Clueso_Node_layer\.env not found" -ForegroundColor Yellow
    Write-Host "   Copy .env.example to .env and add your API keys" -ForegroundColor Yellow
}

if (!(Test-Path $pythonEnv)) {
    Write-Host "Warning: python-genai\.env not found" -ForegroundColor Yellow
    Write-Host "   Copy .env.example to .env and add your API keys" -ForegroundColor Yellow
}

if (!(Test-Path $frontendEnv)) {
    Write-Host "Warning: Clueso_Frontend_layer\.env.local not found" -ForegroundColor Yellow
    Write-Host "   Copy .env.example to .env.local" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Starting services in 3 seconds..." -ForegroundColor Cyan
Start-Sleep -Seconds 3

# Start Node.js Backend (Port 3002)
Start-Service -Name "Node.js Backend (Port 3002)" `
              -Path "Clueso_Node_layer" `
              -Command "npm run dev" `
              -Color "Blue"

# Wait for Node.js to start
Start-Sleep -Seconds 5

# Start Python AI Layer (Port 8000)
Start-Service -Name "Python AI Layer (Port 8000)" `
              -Path "python-genai" `
              -Command ".\venv\Scripts\Activate.ps1; uvicorn app.main:app --reload --host 0.0.0.0 --port 8000" `
              -Color "Green"

# Wait for Python to start
Start-Sleep -Seconds 5

# Start Next.js Frontend (Port 3000)
Start-Service -Name "Next.js Frontend (Port 3000)" `
              -Path "Clueso_Frontend_layer" `
              -Command "npm run dev" `
              -Color "Magenta"

Write-Host ""
Write-Host "All services started!" -ForegroundColor Green
Write-Host ""
Write-Host "Access Points:" -ForegroundColor Cyan
Write-Host "   Frontend:  http://localhost:3000" -ForegroundColor White
Write-Host "   Node API:  http://localhost:3002" -ForegroundColor White
Write-Host "   Python API: http://localhost:8000/docs" -ForegroundColor White
Write-Host ""
Write-Host "Next Steps:" -ForegroundColor Yellow
Write-Host "   1. Load Chrome Extension from Clueso_extension/dist" -ForegroundColor White
Write-Host "   2. Open http://localhost:3000 in your browser" -ForegroundColor White
Write-Host "   3. Click the extension icon to start recording" -ForegroundColor White
Write-Host ""
Write-Host "Press any key to exit this window..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
