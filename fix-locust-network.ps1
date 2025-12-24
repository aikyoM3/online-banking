# PowerShell script to connect Locust to the backend network
# Run this after starting the backend services

Write-Host "Finding backend network..." -ForegroundColor Cyan

# Find the network name
$networks = docker network ls | Select-String "onlinebanking"
if ($networks) {
    Write-Host "Found networks:" -ForegroundColor Green
    $networks | ForEach-Object { Write-Host "  $_" }
    
    # Try to connect to the first matching network
    $networkName = ($networks[0] -split '\s+')[1]
    Write-Host "`nConnecting Locust to network: $networkName" -ForegroundColor Yellow
    
    docker network connect $networkName bank-locust 2>&1 | Out-Null
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✓ Successfully connected Locust to $networkName" -ForegroundColor Green
        Write-Host "`nYou can now test the connection:" -ForegroundColor Cyan
        Write-Host "  docker exec bank-locust ping -c 2 gateway-service" -ForegroundColor White
    } else {
        Write-Host "✗ Failed to connect. Trying alternative method..." -ForegroundColor Red
        Write-Host "`nManual steps:" -ForegroundColor Yellow
        Write-Host "1. Find network: docker network ls | findstr onlinebanking" -ForegroundColor White
        Write-Host "2. Connect: docker network connect <network-name> bank-locust" -ForegroundColor White
    }
} else {
    Write-Host "✗ No onlinebanking network found!" -ForegroundColor Red
    Write-Host "`nMake sure backend services are running:" -ForegroundColor Yellow
    Write-Host "  cd server" -ForegroundColor White
    Write-Host "  docker-compose up -d" -ForegroundColor White
}

