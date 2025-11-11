# PowerShell initialization script for Superset

Write-Host "Starting Superset Initialization..." -ForegroundColor Green

# Create data directories
Write-Host "Creating data directories..." -ForegroundColor Yellow
New-Item -ItemType Directory -Force -Path ".\data\postgres" | Out-Null
New-Item -ItemType Directory -Force -Path ".\data\redis" | Out-Null
New-Item -ItemType Directory -Force -Path ".\data\superset" | Out-Null

# Create external network if it doesn't exist
Write-Host "Creating external network 'superset-demo'..." -ForegroundColor Yellow
docker network create superset-demo 2>$null
if ($LASTEXITCODE -ne 0) {
    Write-Host "Network already exists" -ForegroundColor Yellow
}

# Start the services
Write-Host "Starting Docker services..." -ForegroundColor Yellow
docker compose up -d

# Wait for services to be ready
Write-Host "Waiting for services to start..." -ForegroundColor Yellow
Start-Sleep -Seconds 15

# Initialize the database
Write-Host "Initializing Superset database..." -ForegroundColor Yellow
docker exec -it superset_app superset db upgrade

# Create admin user
Write-Host "Creating admin user..." -ForegroundColor Yellow
docker exec -it superset_app superset fab create-admin `
    --username admin `
    --firstname Superset `
    --lastname Admin `
    --email admin@superset.com `
    --password admin

# Initialize Superset
Write-Host "Initializing Superset..." -ForegroundColor Yellow
docker exec -it superset_app superset init

# Load example data (optional - comment out if not needed)
# Write-Host "Loading example data..." -ForegroundColor Yellow
# docker exec -it superset_app superset load-examples

Write-Host "`nSuperset initialization complete!" -ForegroundColor Green
Write-Host "Access Superset at: http://localhost" -ForegroundColor Green
Write-Host "Username: admin" -ForegroundColor Green
Write-Host "Password: admin" -ForegroundColor Green
