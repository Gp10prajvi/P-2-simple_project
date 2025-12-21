# Multi-stage Dockerfile: build the jar inside the image so the host doesn't need to provide it
# Stage 1: build using Maven
FROM maven:3.9.4-eclipse-temurin-17 AS build
WORKDIR /workspace

# Copy maven descriptor first for better cache when dependencies don't change
COPY pom.xml ./
COPY src ./src

# Build the project (skip tests by default for faster image builds)
RUN mvn -B -DskipTests package

# Stage 2: runtime image
FROM eclipse-temurin:17-jre-alpine
WORKDIR /app

# Copy the built jar from the build stage into the runtime image
COPY --from=build /workspace/target/*.jar /app/app.jar

# Create a non-root user and switch to it
RUN addgroup -S appgroup && adduser -S appuser -G appgroup || true
USER appuser

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "/app/app.jar"]

# Notes:
# - Build with: docker build -t myapp:latest .  (run from the project root where pom.xml and src/ exist)
# - If you prefer to use an already-built jar on the host, you can replace this file with a runtime-only Dockerfile
#   that uses: COPY target/*.jar /app/app.jar  — but you must run `mvn package` first and run `docker build` from the project root.
