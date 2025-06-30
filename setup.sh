#!/bin/bash

set -e

CLUSTER_NAME="my-cluster"

echo "🚀 Setting up Kubernetes Web Server & SPA Project"
echo "=================================================="

# Check prerequisites
echo "📋 Checking prerequisites..."
command -v docker >/dev/null 2>&1 || { echo "❌ Docker is required but not installed. Aborting." >&2; exit 1; }
command -v kind >/dev/null 2>&1 || { echo "❌ kind is required but not installed. Aborting." >&2; exit 1; }
command -v kubectl >/dev/null 2>&1 || { echo "❌ kubectl is required but not installed. Aborting." >&2; exit 1; }

echo "✅ All prerequisites found!"

# Create kind cluster
echo "🔧 Creating kind cluster..."
if kind get clusters | grep -q "^${CLUSTER_NAME}$"; then
    echo "⚠️  Cluster '${CLUSTER_NAME}' already exists. Skipping creation."
else
    kind create cluster --name ${CLUSTER_NAME}
    echo "✅ Cluster created successfully!"
fi

# Build and load webserver image
echo "🏗️  Building webserver image..."
docker build -t webserver:latest ./webserver
echo "📦 Loading webserver image to kind..."
kind load docker-image webserver:latest --name ${CLUSTER_NAME}

# Build and load SPA image
echo "🏗️  Building SPA image..."
docker build -t spa:latest ./spa
echo "📦 Loading SPA image to kind..."
kind load docker-image spa:latest --name ${CLUSTER_NAME}

# Deploy to Kubernetes
echo "🚀 Deploying to Kubernetes..."
kubectl apply -f ./k8s/

# Wait for deployments to be ready
echo "⏳ Waiting for deployments to be ready..."
kubectl wait --for=condition=available --timeout=300s deployment/webserver-deployment
kubectl wait --for=condition=available --timeout=300s deployment/spa-deployment

echo "✅ All deployments are ready!"

# Show status
echo "📊 Deployment Status:"
echo "===================="
kubectl get pods
echo ""
kubectl get services

echo ""
echo "🎉 Setup complete!"
echo "📱 To access your services, run these commands in separate terminals:"
echo ""
echo "   Web Server (http://localhost:8080):"
echo "   kubectl port-forward svc/webserver-service 8080:80"
echo ""
echo "   SPA (http://localhost:3000):"
echo "   kubectl port-forward svc/spa-service 3000:80"
echo ""
echo "🔍 To test the webserver health check:"
echo "   curl http://localhost:8080/healthz"
echo ""
echo "🧹 To clean up later:"
echo "   kubectl delete -f ./k8s/"
echo "   kind delete cluster --name ${CLUSTER_NAME}" 