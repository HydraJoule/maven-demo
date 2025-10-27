# Use official Java image (lightweight Alpine version)
FROM eclipse-temurin:21-jdk-alpine

# Set working directory inside container
WORKDIR /app

# Copy built JAR file from target directory to container
COPY target/*.jar app.jar

# Expose the port your app runs on (8080 typical for Spring Boot)
EXPOSE 8080

# Command to run the JAR
ENTRYPOINT ["java", "-jar", "app.jar"]
