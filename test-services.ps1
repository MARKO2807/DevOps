# PowerShell Test Script for Kubernetes Services

Write-Host "🧪 Testing Kubernetes Services" -ForegroundColor Green
Write-Host "===============================" -ForegroundColor Green

# Test webserver health check
Write-Host "🔍 Testing webserver health check..." -ForegroundColor Yellow
try {
    $webserverResponse = Invoke-RestMethod -Uri "http://localhost:8080/healthz" -TimeoutSec 5 -ErrorAction Stop
    if ($webserverResponse.status -eq "OK") {
        Write-Host "✅ Webserver health check passed!" -ForegroundColor Green
    } else {
        Write-Host "❌ Webserver health check failed - unexpected response" -ForegroundColor Red
        Write-Host "   Response: $($webserverResponse | ConvertTo-Json)" -ForegroundColor Gray
    }
} catch {
    Write-Host "❌ Webserver health check failed. Make sure port-forward is running:" -ForegroundColor Red
    Write-Host "   kubectl port-forward svc/webserver-service 8080:80" -ForegroundColor Gray
    Write-Host "   Error: $($_.Exception.Message)" -ForegroundColor Gray
}

# Test webserver main page
Write-Host "🔍 Testing webserver main page..." -ForegroundColor Yellow
try {
    $webserverHtml = Invoke-WebRequest -Uri "http://localhost:8080/" -TimeoutSec 5 -ErrorAction Stop
    if ($webserverHtml.Content -match "Hello, Kubernetes!") {
        Write-Host "✅ Webserver main page is working!" -ForegroundColor Green
    } else {
        Write-Host "❌ Webserver main page failed - content not found" -ForegroundColor Red
    }
} catch {
    Write-Host "❌ Webserver main page failed. Make sure port-forward is running:" -ForegroundColor Red
    Write-Host "   kubectl port-forward svc/webserver-service 8080:80" -ForegroundColor Gray
    Write-Host "   Error: $($_.Exception.Message)" -ForegroundColor Gray
}

# Test SPA
Write-Host "🔍 Testing SPA main page..." -ForegroundColor Yellow
try {
    $spaResponse = Invoke-WebRequest -Uri "http://localhost:3000/" -TimeoutSec 5 -ErrorAction Stop
    if ($spaResponse.StatusCode -eq 200) {
        Write-Host "✅ SPA is responding!" -ForegroundColor Green
    } else {
        Write-Host "❌ SPA failed - unexpected status code: $($spaResponse.StatusCode)" -ForegroundColor Red
    }
} catch {
    Write-Host "❌ SPA failed to respond. Make sure port-forward is running:" -ForegroundColor Red
    Write-Host "   kubectl port-forward svc/spa-service 3000:80" -ForegroundColor Gray
    Write-Host "   Error: $($_.Exception.Message)" -ForegroundColor Gray
}

Write-Host ""
Write-Host "📊 Kubernetes Status:" -ForegroundColor Cyan
Write-Host "====================" -ForegroundColor Cyan
Write-Host "Pods:" -ForegroundColor White
kubectl get pods | Select-String -Pattern "(webserver|spa)"
Write-Host ""
Write-Host "Services:" -ForegroundColor White
kubectl get services | Select-String -Pattern "(webserver|spa)"

Write-Host ""
Write-Host "💡 If tests failed, make sure you have the port-forwards running:" -ForegroundColor Yellow
Write-Host "   kubectl port-forward svc/webserver-service 8080:80" -ForegroundColor Gray
Write-Host "   kubectl port-forward svc/spa-service 3000:80" -ForegroundColor Gray
Write-Host ""
Write-Host "🌐 Open in browser:" -ForegroundColor Yellow
Write-Host "   Web Server: http://localhost:8080" -ForegroundColor Gray
Write-Host "   SPA: http://localhost:3000" -ForegroundColor Gray 