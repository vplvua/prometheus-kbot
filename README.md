# prometheus-kbot
This is Telegram bot application.
Bot available here `https://t.me/prometheuskbor_bot`

- Go programming language
- Docker
- Google Cloud SDK (for pushing to Google Container Registry)
- golangci-lint (for linting)

## Setup app
You need to set `TELE_TOKEN` and pass Telegram API access token

Run this command:  
`read -s TELE_TOKEN`  
`export TELE_TOKEN`  

## Start app
run command `./prometheus-kbot go`

## Available Telegram commands
You can use `hello` and `version` commands when interacting with a bot

In Telegram send message like this:  
`/start hello`  
`/start version`  

## Make commands
### This project contains a Makefile for building and managing the Prometheus KBot application.

**Makefile Variables**

`APP`: The name of the application, derived from the Git remote URL.

`REGISTRY`: The Google Container Registry URL. Make sure to replace prometheus-429509 with your actual Google Cloud project ID.

`VERSION`: The version tag, combining the latest Git tag and short commit hash.

`TARGETOS`: The target operating system (default: linux).

`TARGETARCH`: The target architecture (default: amd64).

**Available Commands**

*Development*

`make format`: Format the Go code.

`make get`: Get Go dependencies.

`make lint`: Run the golangci-lint tool.

`make test`: Run Go tests.

*Building*

`make build`: Build the application for the specified OS and architecture.

`make docker_build`: Build and push a Docker image for the specified OS and architecture.

`make image`: Build and create a Docker image for Linux/amd64, pushes the built image to the container registry gcr.io/prometheus-429509. Ensure you have the necessary permissions to push to the specified container registry.

*Cross-platform Building*

`make linux`: Build for both Linux amd64 and arm64.

`make macos`: Build for both macOS (Darwin) amd64 and arm64.

`make windows`: Build for Windows amd64.

*Individual platform builds*

`make linux-amd64`

`make linux-arm64`

`make darwin-amd64`

`make darwin-arm64`

`make windows`

*Docker Operations*

`make push`: Push Docker images for all supported platforms to the registry.

`make delete_images`: Delete the Linux amd64 image from Google Container Registry.

*Cleanup*

`make clean`: Remove built binaries and Docker images.

**Usage**

Set up your Google Cloud project and configure Docker to use Google Container Registry.
Use the provided make commands to build, test, and deploy your application.

Example:
```
make build
make docker_build
make push
```