# Use JDK 21 base image
FROM eclipse-temurin:21-jdk-alpine

WORKDIR /app
COPY target/*.jar app.jar

# Default port (you can change if needed)
EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]
