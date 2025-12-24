# Build stage
FROM eclipse-temurin:21-jdk-alpine AS build
WORKDIR /app

# Install Maven
RUN apk add --no-cache maven

# Copy parent pom and shared-events first
COPY pom.xml ./pom.xml
COPY shared-events/pom.xml ./shared-events/pom.xml
COPY shared-events/src ./shared-events/src

# Copy discovery-service pom and source
COPY discovery-service/pom.xml ./discovery-service/pom.xml
COPY discovery-service/src ./discovery-service/src

# Build the project
RUN mvn clean package -DskipTests -f pom.xml -pl discovery-service -am

# Runtime stage
FROM eclipse-temurin:21-jre-alpine
WORKDIR /app

COPY --from=build /app/discovery-service/target/discovery-service-0.0.1.jar app.jar

ENTRYPOINT ["java", "-jar", "app.jar"]
