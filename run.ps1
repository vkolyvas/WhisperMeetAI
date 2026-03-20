# WhisperMeet Web - Auto Start Script
# Double-click this file to start the server and open the app

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  WhisperMeet Web - Starting..." -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

# Change to script directory
Set-Location $ScriptDir

# Kill any existing python server on common ports
Get-NetTCPConnection -LocalPort 8080 -ErrorAction SilentlyContinue | ForEach-Object {
    Stop-Process -Id $_.OwningProcess -Force -ErrorAction SilentlyContinue
}

# Start Python HTTP server in background
$Process = Start-Process -FilePath "python" -ArgumentList "-m", "http.server", "8080" -NoNewWindow -PassThru -WorkingDirectory $ScriptDir

Start-Sleep -Seconds 2

# Check if server started
if ($Process.HasExited) {
    Write-Host "Error: Failed to start server" -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}

# Open browser
$Url = "http://localhost:8080/index.html"
Write-Host "Opening: $Url" -ForegroundColor Green
Start-Process $Url

Write-Host ""
Write-Host "WhisperMeet is running!" -ForegroundColor Green
Write-Host "Press Enter to stop the server" -ForegroundColor Yellow

# Wait for user to press Enter
Read-Host ""

# Cleanup
Stop-Process -Id $Process.Id -Force -ErrorAction SilentlyContinue
Write-Host "Server stopped." -ForegroundColor Cyan
