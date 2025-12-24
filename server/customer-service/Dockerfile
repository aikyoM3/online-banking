# Build stage
FROM eclipse-temurin:21-jdk-alpine AS build
WORKDIR /app

# Install Maven
RUN apk add --no-cache maven

# Copy parent pom and shared-events first
COPY pom.xml ./pom.xml
COPY shared-events/pom.xml ./shared-events/pom.xml
COPY shared-events/src ./shared-events/src

# Copy customer-service pom and source
COPY customer-service/pom.xml ./customer-service/pom.xml
COPY customer-service/src ./customer-service/src

# Build the project
RUN mvn clean package -DskipTests -f pom.xml -pl customer-service -am

# Runtime stage
FROM eclipse-temurin:21-jre-alpine
WORKDIR /app

COPY --from=build /app/customer-service/target/customer-service-0.0.1.jar app.jar

ENTRYPOINT ["java", "-jar", "app.jar"]
