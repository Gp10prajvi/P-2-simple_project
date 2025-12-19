@echo off
REM Build Docker image for the Java app
set IMAGE_NAME=<your-ecr-repo>:latest

docker build -t %IMAGE_NAME% .

echo Docker image built: %IMAGE_NAME%

