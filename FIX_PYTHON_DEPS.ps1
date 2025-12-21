# Quick fix for Python dependencies
Write-Host "Installing missing Python dependencies..." -ForegroundColor Yellow

cd W:\GCU\Project\Clueso_clone_example\python-genai
& ".\venv\Scripts\Activate.ps1"

pip install audioop-lts

Write-Host ""
Write-Host "Dependencies updated!" -ForegroundColor Green
Write-Host "Restart the Python service (close the Python window and run START_ALL_SERVICES.ps1 again)" -ForegroundColor Yellow
