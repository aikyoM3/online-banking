# Build stage
FROM eclipse-temurin:21-jdk-alpine AS build
WORKDIR /app

# Install Maven
RUN apk add --no-cache maven

# Copy parent pom and shared-events first
COPY pom.xml ./pom.xml
COPY shared-events/pom.xml ./shared-events/pom.xml
COPY shared-events/src ./shared-events/src

# Copy notification-service pom and source
COPY notification-service/pom.xml ./notification-service/pom.xml
COPY notification-service/src ./notification-service/src

# Build the project
RUN mvn clean package -DskipTests -f pom.xml -pl notification-service -am

# Runtime stage
FROM eclipse-temurin:21-jre-alpine
WORKDIR /app

COPY --from=build /app/notification-service/target/notification-service-0.0.1.jar app.jar

ENTRYPOINT ["java", "-jar", "app.jar"]
