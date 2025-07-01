
param(
    [string]$ClusterName = "my-cluster"
)

Write-Host "🚀 Setting up Kubernetes Web Server & SPA Project" -ForegroundColor Green
Write-Host "==================================================" -ForegroundColor Green

Write-Host "📋 Checking prerequisites..." -ForegroundColor Yellow

try {
    docker --version | Out-Null
    Write-Host "✅ Docker found" -ForegroundColor Green
} catch {
    Write-Host "❌ Docker is required but not installed. Aborting." -ForegroundColor Red
    exit 1
}

try {
    kind version | Out-Null
    Write-Host "✅ kind found" -ForegroundColor Green
} catch {
    Write-Host "❌ kind is required but not installed. Aborting." -ForegroundColor Red
    exit 1
}


try {
    kubectl version --client | Out-Null
    Write-Host "✅ kubectl found" -ForegroundColor Green
} catch {
    Write-Host "❌ kubectl is required but not installed. Aborting." -ForegroundColor Red
    exit 1
}

Write-Host "✅ All prerequisites found!" -ForegroundColor Green

Write-Host "🔧 Creating kind cluster..." -ForegroundColor Yellow
$existingClusters = kind get clusters 2>$null
if ($existingClusters -contains $ClusterName) {
    Write-Host "⚠️  Cluster '$ClusterName' already exists. Skipping creation." -ForegroundColor Yellow
} else {
    kind create cluster --name $ClusterName
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Cluster created successfully!" -ForegroundColor Green
    } else {
        Write-Host "❌ Failed to create cluster" -ForegroundColor Red
        exit 1
    }
}

Write-Host "🏗️  Building webserver image..." -ForegroundColor Yellow
docker build -t webserver:latest ./webserver
if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Webserver image built successfully!" -ForegroundColor Green
} else {
    Write-Host "❌ Failed to build webserver image" -ForegroundColor Red
    exit 1
}

Write-Host "📦 Loading webserver image to kind..." -ForegroundColor Yellow
kind load docker-image webserver:latest --name $ClusterName

Write-Host "🏗️  Building SPA image..." -ForegroundColor Yellow
docker build -t spa:latest ./spa
if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ SPA image built successfully!" -ForegroundColor Green
} else {
    Write-Host "❌ Failed to build SPA image" -ForegroundColor Red
    exit 1
}

Write-Host "📦 Loading SPA image to kind..." -ForegroundColor Yellow
kind load docker-image spa:latest --name $ClusterName

Write-Host "🚀 Deploying to Kubernetes..." -ForegroundColor Yellow
kubectl apply -f ./k8s/

Write-Host "⏳ Waiting for deployments to be ready..." -ForegroundColor Yellow
kubectl wait --for=condition=available --timeout=300s deployment/webserver-deployment
kubectl wait --for=condition=available --timeout=300s deployment/spa-deployment

Write-Host "✅ All deployments are ready!" -ForegroundColor Green

Write-Host "📊 Deployment Status:" -ForegroundColor Cyan
Write-Host "====================" -ForegroundColor Cyan
kubectl get pods
Write-Host ""
kubectl get services

Write-Host ""
Write-Host "🎉 Setup complete!" -ForegroundColor Green
Write-Host "📱 To access your services, run these commands in separate terminals:" -ForegroundColor Yellow
Write-Host ""
Write-Host "   Web Server (http://localhost:8080):" -ForegroundColor White
Write-Host "   kubectl port-forward svc/webserver-service 8080:80" -ForegroundColor Gray
Write-Host ""
Write-Host "   SPA (http://localhost:3000):" -ForegroundColor White
Write-Host "   kubectl port-forward svc/spa-service 3000:80" -ForegroundColor Gray
Write-Host ""
Write-Host "🔍 To test the webserver health check:" -ForegroundColor Yellow
Write-Host "   curl http://localhost:8080/healthz" -ForegroundColor Gray
Write-Host "   or" -ForegroundColor Gray
Write-Host "   Invoke-RestMethod http://localhost:8080/healthz" -ForegroundColor Gray
Write-Host ""
Write-Host "🧹 To clean up later:" -ForegroundColor Yellow
Write-Host "   kubectl delete -f ./k8s/" -ForegroundColor Gray
Write-Host "   kind delete cluster --name $ClusterName" -ForegroundColor Gray