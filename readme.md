# Online Banking System

This project implements an online banking platform that allows customers and administrators to manage bank accounts and perform day-to-day banking operations. Customers can view account information, track transactions and expenses, transfer funds, and communicate with administrators. Administrators can manage customer data and monitor system activity.

The backend is built with **Spring Boot (Java)** and uses **MySQL** for data storage. The client side is implemented with **React** and modern UI frameworks such as **TailwindCSS/Bootstrap**. The system is containerized with **Docker** and designed as a responsive web application to support both desktop and mobile users.

---

## How to Run

From the `server` directory, run:

```bash
docker-compose up --build

```

### This will:

- Build all service JARs

- Start all MySQL databases

- Start RabbitMQ

- Start Eureka Discovery Service

- Start the API Gateway

- Start all microservices (Authentication, Customer, Account, Notification)

## Services will be available at:

### Gateway → http://localhost:8080

### Eureka Dashboard → http://localhost:8761

### RabbitMQ UI → http://localhost:15672

(guest / guest)

Service startup is dependency-aware. Each service waits until databases, RabbitMQ, and Eureka are healthy before launching.

## Database Configuration

The project uses a single MySQL database named `projectdb` with the following credentials:

- **Database**: projectdb
- **Username**: testuser
- **Password**: testpass
- **Port**: 3306

### Test Users

The database is automatically initialized with dummy test data including:

**Test Users (Password: `password123`):**

- user1@example.com / password123
- user2@example.com / password123
- user3@example.com / password123
- admin@example.com / password123

**Test Accounts:**

- Account 1000001 (user-001, Savings, $10,000)
- Account 1000002 (user-001, Checking, $5,000)
- Account 1000003 (user-002, Savings, $15,000)
- Account 1000004 (user-002, Checking, $7,500)
- Account 1000005 (user-003, Savings, $20,000)

**Test Transactions:**

- Sample transaction history is included for testing

The database initialization script (`server/init-db.sql`) runs automatically when the MySQL container starts for the first time.

## Load Testing with Locust

This project includes Dockerized HTTP load testing using Locust, targeting the API Gateway.

### Quick Start

- Build the Locust image:

docker build -f Dockerfile.locust -t bank-locust .

- Run Locust:

docker run -p 8089:8089 bank-locust

- Or via Docker Compose:

docker compose -f docker-compose.locust.yml up

### Open the Locust UI:

http://localhost:8089

Configure:

- Users — number of concurrent virtual users

- Spawn rate — users started per second

- Host — defaults to http://host.docker.internal:8080

### Locust UI Metrics

- Median, 95th and 99th percentile latency

- Requests per second (RPS)

- Failure rate

- Response-time distribution

- Real-time charts

# Default Test Scenarios

GET /api/v1/account/{accountNo} — account details

GET /api/v1/account/user/{userId} — list user accounts

GET /api/v1/user/{id} — customer profile

GET /api/v1/beneficiary/{id} — beneficiary details

Optional authentication via /api/v1/login (disabled by default)

```

```
