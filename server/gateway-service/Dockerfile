# Build stage
FROM eclipse-temurin:21-jdk-alpine AS build
WORKDIR /app

# Install Maven
RUN apk add --no-cache maven

# Copy parent pom and shared-events first
COPY pom.xml ./pom.xml
COPY shared-events/pom.xml ./shared-events/pom.xml
COPY shared-events/src ./shared-events/src

# Copy gateway-service pom and source
COPY gateway-service/pom.xml ./gateway-service/pom.xml
COPY gateway-service/src ./gateway-service/src

# Build the project
RUN mvn clean package -DskipTests -f pom.xml -pl gateway-service -am

# Runtime stage
FROM eclipse-temurin:21-jre-alpine
WORKDIR /app

COPY --from=build /app/gateway-service/target/gateway-service-0.0.1.jar app.jar

ENTRYPOINT ["java", "-jar", "app.jar"]
