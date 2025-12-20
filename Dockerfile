# Runtime Dockerfile that takes the pre-built jar from the host target/ directory
FROM eclipse-temurin:17-jre-alpine
WORKDIR /app

# Copy the already-built jar from the build context's target directory into the image
# (when building: docker build -t myapp:latest . )
COPY target/*.jar app.jar

# Create a non-root user and switch to it
RUN addgroup -S appgroup && adduser -S appuser -G appgroup || true
USER appuser

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "/app/app.jar"]
