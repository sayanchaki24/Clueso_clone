# Clueso Clone - Stop All Services Script
# This script stops all running services

Write-Host "Stopping Clueso Clone Services..." -ForegroundColor Red
Write-Host ""

# Function to kill processes by port
function Stop-ServiceByPort {
    param(
        [int]$Port,
        [string]$Name
    )
    
    Write-Host "Stopping $Name (Port $Port)..." -ForegroundColor Yellow
    
    try {
        $connections = Get-NetTCPConnection -LocalPort $Port -ErrorAction SilentlyContinue
        
        if ($connections) {
            foreach ($conn in $connections) {
                $process = Get-Process -Id $conn.OwningProcess -ErrorAction SilentlyContinue
                if ($process) {
                    Write-Host "  Killing process: $($process.Name) (PID: $($process.Id))" -ForegroundColor Gray
                    Stop-Process -Id $process.Id -Force -ErrorAction SilentlyContinue
                }
            }
            Write-Host "  $Name stopped" -ForegroundColor Green
        } else {
            Write-Host "  $Name not running" -ForegroundColor Gray
        }
    } catch {
        Write-Host "  Could not stop $Name : $_" -ForegroundColor Yellow
    }
}

# Stop all services
Stop-ServiceByPort -Port 3002 -Name "Node.js Backend"
Stop-ServiceByPort -Port 8000 -Name "Python AI Layer"
Stop-ServiceByPort -Port 3000 -Name "Next.js Frontend"

# Also try to stop by process name
Write-Host ""
Write-Host "Stopping Node.js processes..." -ForegroundColor Yellow
Get-Process node -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue

Write-Host "Stopping Python processes..." -ForegroundColor Yellow
Get-Process python -ErrorAction SilentlyContinue | Where-Object { $_.MainWindowTitle -like "*uvicorn*" } | Stop-Process -Force -ErrorAction SilentlyContinue

Write-Host ""
Write-Host "All services stopped!" -ForegroundColor Green
Write-Host ""
Write-Host "Press any key to exit..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
