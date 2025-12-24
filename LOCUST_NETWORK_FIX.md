# Locust Network Connection Fix

## Problem
Locust container cannot connect to gateway-service (Status 0 errors).

## Solution

### Option 1: Connect Locust to the Backend Network (Recommended)

After starting the backend services, connect Locust to the network:

```bash
# Find the actual network name
docker network ls | findstr onlinebanking

# Connect Locust container to the network
docker network connect <network-name> bank-locust

# Example:
docker network connect server_onlinebanking-network bank-locust
# OR
docker network connect onlinebanking-network bank-locust
```

### Option 2: Use Host Gateway (Fallback)

If network connection doesn't work, update the host in Locust UI:
- Open http://localhost:8089
- Change host from `http://gateway-service:8080` to `http://host.docker.internal:8080`
- Start the test

### Option 3: Run Locust on Host Network (Linux/Mac)

Update `docker-compose.locust.yml`:
```yaml
services:
  locust:
    network_mode: "host"
    command: locust -f locustfile.py --host http://localhost:8080
```

## Verify Connection

Test from Locust container:
```bash
docker exec bank-locust ping -c 2 gateway-service
docker exec bank-locust curl -v http://gateway-service:8080/api/v1/login
```

## Test Credentials

These credentials are pre-loaded in the database:
- user1@example.com / password123
- user2@example.com / password123
- user3@example.com / password123
- admin@example.com / password123

