# Apache Superset Docker Setup

This setup includes Apache Superset 3.1.0, PostgreSQL 15, and Redis 7 using Docker Compose.

## Components

- **Apache Superset 3.1.0**: Business intelligence web application
- **PostgreSQL 15**: Metadata database
- **Redis 7**: Cache and Celery broker
- **External Network**: `superset-demo`

## Prerequisites

- Docker and Docker Compose installed
- Port 80 available on your host machine

## Quick Start

### For Windows (PowerShell)

```powershell
.\init_superset.ps1
```

### For Linux/Mac

```bash
chmod +x init_superset.sh
./init_superset.sh
```

## Manual Setup

If you prefer to set up manually:

1. Create the external network:
   ```bash
   docker network create superset-demo
   ```

2. Create data directories:
   ```bash
   mkdir -p ./data/postgres ./data/redis ./data/superset
   ```

3. Start the services:
   ```bash
   docker compose up -d
   ```

4. Initialize the database:
   ```bash
   docker exec -it superset_app superset db upgrade
   ```

5. Create an admin user:
   ```bash
   docker exec -it superset_app superset fab create-admin \
       --username admin \
       --firstname Superset \
       --lastname Admin \
       --email admin@superset.com \
       --password admin
   ```

6. Initialize Superset:
   ```bash
   docker exec -it superset_app superset init
   ```

## Access

- **URL**: http://localhost
- **Default Username**: admin
- **Default Password**: admin

**⚠️ Important**: Change the default password and update the `SUPERSET_SECRET_KEY` in production!

## Configuration

### superset_config.py

The main configuration file contains:
- Database connection settings
- Redis configuration for caching and Celery
- Security settings
- Feature flags

### Environment Variables

You can override settings using environment variables:
- `SUPERSET_SECRET_KEY`: Secret key for session encryption (required for production)
- `MAPBOX_API_KEY`: API key for Mapbox visualizations (optional)

## Data Persistence

All data is stored in the `./data/` directory:
- `./data/postgres`: PostgreSQL database files
- `./data/redis`: Redis persistence files
- `./data/superset`: Superset home directory

## Useful Commands

### Stop services
```bash
docker compose down
```

### View logs
```bash
docker compose logs -f superset
```

### Restart services
```bash
docker compose restart
```

### Remove all data (WARNING: This deletes all data!)
```bash
docker compose down -v
rm -rf ./data
```

## Troubleshooting

### Services not starting
Check if the external network exists:
```bash
docker network ls | grep superset-demo
```

### Cannot access on port 80
Make sure no other service is using port 80. You can change the port mapping in `docker-compose.yml`:
```yaml
ports:
  - "8080:8088"  # Change 80 to 8080 or any other available port
```

### Database connection issues
Check if PostgreSQL is running:
```bash
docker exec -it superset_postgres pg_isready
```

## Security Notes

1. Change the default admin password immediately after first login
2. Update `SUPERSET_SECRET_KEY` in production (generate with: `openssl rand -base64 42`)
3. Use strong passwords for PostgreSQL
4. Consider using environment files (.env) for sensitive data
5. Enable SSL/TLS for production deployments

## License

Apache Superset is licensed under the Apache License 2.0
