#!/bin/bash

echo -e "\e[32mStarting Superset Initialization...\e[0m"

# Create data directories
echo -e "\e[33mCreating data directories...\e[0m"
mkdir -p ./data/postgres
mkdir -p ./data/redis
mkdir -p ./data/superset

# Create external network if it doesn't exist
echo -e "\e[33mCreating external network 'superset-demo'...\e[0m"
docker network create superset-demo >/dev/null 2>&1

if [ $? -ne 0 ]; then
    echo -e "\e[33mNetwork already exists\e[0m"
fi

# Start the services
echo -e "\e[33mStarting Docker services...\e[0m"
docker compose up -d

# Wait for services to be ready
echo -e "\e[33mWaiting for services to start...\e[0m"
sleep 15

# Initialize the database
echo -e "\e[33mInitializing Superset database...\e[0m"
docker exec -it superset_app superset db upgrade

# Create admin user
echo -e "\e[33mCreating admin user...\e[0m"
docker exec -it superset_app superset fab create-admin \
    --username admin \
    --firstname Superset \
    --lastname Admin \
    --email admin@superset.com \
    --password admin

# Initialize Superset
echo -e "\e[33mInitializing Superset...\e[0m"
docker exec -it superset_app superset init

# Load example data (optional)
# echo -e "\e[33mLoading example data...\e[0m"
# docker exec -it superset_app superset load-examples

echo -e "\n\e[32mSuperset initialization complete!\e[0m"
echo -e "\e[32mAccess Superset at: http://localhost\e[0m"
echo -e "\e[32mUsername: admin\e[0m"
echo -e "\e[32mPassword: admin\e[0m"
