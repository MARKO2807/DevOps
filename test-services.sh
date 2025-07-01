

echo "🧪 Testing Kubernetes Services"
echo "==============================="

echo "🔍 Testing webserver health check..."
WEBSERVER_RESPONSE=$(curl -s http://localhost:8080/healthz 2>/dev/null || echo "FAILED")
if echo "$WEBSERVER_RESPONSE" | grep -q '"status":"OK"'; then
    echo "✅ Webserver health check passed!"
else
    echo "❌ Webserver health check failed. Make sure port-forward is running:"
    echo "   kubectl port-forward svc/webserver-service 8080:80"
    echo "   Response: $WEBSERVER_RESPONSE"
fi

echo "🔍 Testing webserver main page..."
WEBSERVER_HTML=$(curl -s http://localhost:8080/ 2>/dev/null || echo "FAILED")
if echo "$WEBSERVER_HTML" | grep -q "Hello, Kubernetes!"; then
    echo "✅ Webserver main page is working!"
else
    echo "❌ Webserver main page failed. Make sure port-forward is running:"
    echo "   kubectl port-forward svc/webserver-service 8080:80"
fi

echo "🔍 Testing SPA main page..."
SPA_RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:3000/ 2>/dev/null || echo "FAILED")
if [ "$SPA_RESPONSE" = "200" ]; then
    echo "✅ SPA is responding!"
else
    echo "❌ SPA failed to respond. Make sure port-forward is running:"
    echo "   kubectl port-forward svc/spa-service 3000:80"
    echo "   Response code: $SPA_RESPONSE"
fi

echo ""
echo "📊 Kubernetes Status:"
echo "===================="
echo "Pods:"
kubectl get pods | grep -E "(webserver|spa)"
echo ""
echo "Services:"
kubectl get services | grep -E "(webserver|spa)"

echo ""
echo "💡 If tests failed, make sure you have the port-forwards running:"
echo "   kubectl port-forward svc/webserver-service 8080:80 &"
echo "   kubectl port-forward svc/spa-service 3000:80 &" 