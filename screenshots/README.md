# Screenshots Directory


## Required Screenshots

### Web Server
1. **webserver-homepage.png** - Web server homepage showing "Hello, Kubernetes!" message
2. **webserver-healthz.png** - Health check endpoint JSON response

### Single Page Application  
3. **spa-initial-load.png** - SPA showing initial bar chart with 10 random products
4. **spa-after-refresh.png** - SPA showing different products after refresh button click

### Kubernetes Dashboard
5. **kubernetes-pods.png** - `kubectl get pods` output showing running deployments
6. **kubernetes-services.png** - `kubectl get services` output showing services

## How to Take Screenshots

1. **Start the services:**
   ```bash
   # Run setup script
   ./setup.sh  # or .\setup.ps1 on Windows
   
   # Port forward services (in separate terminals)
   kubectl port-forward svc/webserver-service 8080:80
   kubectl port-forward svc/spa-service 3000:80
   ```

2. **Take screenshots:**
   - **Web Server**: Open http://localhost:8080 in browser
   - **Health Check**: Open http://localhost:8080/healthz in browser or use curl
   - **SPA**: Open http://localhost:3000 in browser, take screenshot, click refresh, take another
   - **Kubernetes**: Run `kubectl get pods` and `kubectl get services` in terminal

3. **Save screenshots** in this directory with the exact filenames listed above.

## Screenshot Guidelines

- Use high resolution (at least 1920x1080)
- Capture browser window including URL bar
- For terminal screenshots, use readable font size
- Crop to relevant content, avoid excessive white space
- Save as PNG format for better quality 