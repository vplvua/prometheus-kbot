APP=$(shell basename $(shell git remote get-url origin) .git)
REGISTRY=vasylpashko
VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)
TARGETOS=linux #linux darwin windows
TARGETARCH=arm64 #amd64 arm arm64 386

format:
	gofmt -s -w ./

build: format get
	CGO_ENABLAD=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -v -ldflags "-X github.com/vplvua/prometheus-kbot/cmd.appVersion=${VERSION}" -o prometheus-kbot 

lint:
	golangci-lint run

test:
	go test -v

clean:
	rm -rf prometheus-kbot

get:
	go get

image:
	docker buildx build . -t ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}

push:
	docker push ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}