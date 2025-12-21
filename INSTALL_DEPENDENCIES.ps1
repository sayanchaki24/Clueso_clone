# Clueso Clone - Install All Dependencies
# Run this ONCE before starting services for the first time

Write-Host "Installing Clueso Clone Dependencies..." -ForegroundColor Cyan
Write-Host ""

$rootDir = $PSScriptRoot

# Install Node.js Backend Dependencies
Write-Host "1/4 Installing Node.js Backend dependencies..." -ForegroundColor Yellow
cd (Join-Path $rootDir "Clueso_Node_layer")
npm install
if ($LASTEXITCODE -eq 0) {
    Write-Host "   Node.js Backend dependencies installed!" -ForegroundColor Green
} else {
    Write-Host "   Failed to install Node.js dependencies" -ForegroundColor Red
}
Write-Host ""

# Install Frontend Dependencies
Write-Host "2/4 Installing Next.js Frontend dependencies..." -ForegroundColor Yellow
cd (Join-Path $rootDir "Clueso_Frontend_layer")
npm install
if ($LASTEXITCODE -eq 0) {
    Write-Host "   Frontend dependencies installed!" -ForegroundColor Green
} else {
    Write-Host "   Failed to install Frontend dependencies" -ForegroundColor Red
}
Write-Host ""

# Install Extension Dependencies and Build
Write-Host "3/4 Installing Chrome Extension dependencies..." -ForegroundColor Yellow
cd (Join-Path $rootDir "Clueso_extension")
npm install
if ($LASTEXITCODE -eq 0) {
    Write-Host "   Extension dependencies installed!" -ForegroundColor Green
    Write-Host "   Building extension..." -ForegroundColor Yellow
    npm run build
    if ($LASTEXITCODE -eq 0) {
        Write-Host "   Extension built successfully!" -ForegroundColor Green
    } else {
        Write-Host "   Failed to build extension" -ForegroundColor Red
    }
} else {
    Write-Host "   Failed to install Extension dependencies" -ForegroundColor Red
}
Write-Host ""

# Setup Python Virtual Environment
Write-Host "4/4 Setting up Python AI Layer..." -ForegroundColor Yellow
cd (Join-Path $rootDir "python-genai")

if (!(Test-Path "venv")) {
    Write-Host "   Creating Python virtual environment..." -ForegroundColor Yellow
    python -m venv venv
}

Write-Host "   Activating virtual environment..." -ForegroundColor Yellow
& ".\venv\Scripts\Activate.ps1"

Write-Host "   Installing Python dependencies..." -ForegroundColor Yellow
pip install -r requirements.txt

if ($LASTEXITCODE -eq 0) {
    Write-Host "   Python dependencies installed!" -ForegroundColor Green
} else {
    Write-Host "   Failed to install Python dependencies" -ForegroundColor Red
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Installation Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Next Steps:" -ForegroundColor Yellow
Write-Host "1. Make sure .env files are configured with your API keys" -ForegroundColor White
Write-Host "2. Run .\START_ALL_SERVICES.ps1 to start all services" -ForegroundColor White
Write-Host "3. Load the Chrome extension from Clueso_extension\dist" -ForegroundColor White
Write-Host ""
Write-Host "Press any key to exit..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
