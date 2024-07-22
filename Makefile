VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)
TARGETOS=linux

format:
	gofmt -s -w ./

build: format get
	CGO_ENABLAD=0 GOOS=${TARGETOS} GOARCH=${shell dpkg --print-architecture} go build -v -ldflags "-X github.com/vplvua/prometheus-kbot/cmd.appVersion=${VERSION}" -o prometheus-kbot 

lint:
	golangci-lint run

test:
	go test -v

clean:
	rm -rf prometheus-kbot

get:
	go get