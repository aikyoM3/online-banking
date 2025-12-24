#!/bin/bash
# Bash script to connect Locust to the backend network
# Run this after starting the backend services

echo "Finding backend network..."

# Find the network name
NETWORK=$(docker network ls | grep onlinebanking | head -1 | awk '{print $1}')

if [ -z "$NETWORK" ]; then
    echo "✗ No onlinebanking network found!"
    echo ""
    echo "Make sure backend services are running:"
    echo "  cd server"
    echo "  docker-compose up -d"
    exit 1
fi

NETWORK_NAME=$(docker network ls | grep onlinebanking | head -1 | awk '{print $2}')
echo "Found network: $NETWORK_NAME"
echo "Connecting Locust to network..."

docker network connect $NETWORK_NAME bank-locust

if [ $? -eq 0 ]; then
    echo "✓ Successfully connected Locust to $NETWORK_NAME"
    echo ""
    echo "You can now test the connection:"
    echo "  docker exec bank-locust ping -c 2 gateway-service"
else
    echo "✗ Failed to connect"
    exit 1
fi

