# WhisperMeet Web - Auto Start Script
# Double-click this file to start the server and open the app

$ErrorActionPreference = "Stop"

# Get the directory where this script is located
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

# Find available port
$Port = 8080
while (Test-NetConnection -ComputerName localhost -Port $Port -WarningAction SilentlyContinue -ErrorAction SilentlyContinue) {
    $Port++
}

Write-Host "Starting WhisperMeet Web on port $Port..." -ForegroundColor Cyan
Write-Host ""

# Start HTTP server in background
$Job = Start-Job -ScriptBlock {
    param($dir, $port)
    Set-Location $dir
    python -m http.server $port
} -ArgumentList $ScriptDir, $Port

# Wait for server to start
Start-Sleep -Seconds 2

# Open browser
$Url = "http://localhost:$Port/index.html"
Write-Host "Opening: $Url" -ForegroundColor Green
Start-Process $Url

Write-Host ""
Write-Host "WhisperMeet is running!" -ForegroundColor Green
Write-Host "Press Ctrl+C in this window to stop the server" -ForegroundColor Yellow

# Keep script running
try {
    while ($Job.State -eq "Running") {
        Start-Sleep -Seconds 1
    }
} finally {
    Stop-Job $Job -ErrorAction SilentlyContinue
    Remove-Job $Job -ErrorAction SilentlyContinue
}
