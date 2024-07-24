APP=$(shell basename $(shell git remote get-url origin) .git)
REGISTRY=gcr.io/prometheus-429509
VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)
TARGETOS?=linux
TARGETARCH?=amd64

format:
	gofmt -s -w ./

get:
	go get

build: format get
	CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -v -ldflags "-X github.com/vplvua/prometheus-kbot/cmd.appVersion=${VERSION}" -o prometheus-kbot-${TARGETOS}-${TARGETARCH}

docker_build:
	docker buildx build --platform ${TARGETOS}/${TARGETARCH} -t ${REGISTRY}/${APP}-${TARGETOS}-${TARGETARCH}:${VERSION} . --push

image: 
	${MAKE} build TARGETOS=${TARGETOS} TARGETARCH=${TARGETARCH}
	${MAKE} docker_build TARGETOS=${TARGETOS} TARGETARCH=${TARGETARCH}

lint:
	golangci-lint run

test:
	go test -v

clean:
	rm -rf prometheus-kbot*
	docker rmi ${REGISTRY}/${APP}-linux-amd64:${VERSION} || true
	docker rmi ${REGISTRY}/${APP}-linux-arm64:${VERSION} || true
	docker rmi ${REGISTRY}/${APP}-darwin-amd64:${VERSION} || true
	docker rmi ${REGISTRY}/${APP}-darwin-arm64:${VERSION} || true
	docker rmi ${REGISTRY}/${APP}-windows-amd64:${VERSION} || true

linux: linux-amd64 linux-arm64

macos: darwin-amd64 darwin-arm64

linux-amd64: 
	${MAKE} build TARGETOS=linux TARGETARCH=amd64

linux-arm64:
	${MAKE} build TARGETOS=linux TARGETARCH=arm64

darwin-amd64:
	${MAKE} build TARGETOS=darwin TARGETARCH=amd64

darwin-arm64:
	${MAKE} build TARGETOS=darwin TARGETARCH=arm64

windows:
	${MAKE} build TARGETOS=windows TARGETARCH=amd64

push:
	docker push ${REGISTRY}/${APP}-linux-amd64:${VERSION}
	docker push ${REGISTRY}/${APP}-linux-arm64:${VERSION}
	docker push ${REGISTRY}/${APP}-darwin-amd64:${VERSION}
	docker push ${REGISTRY}/${APP}-darwin-arm64:${VERSION}
	docker push ${REGISTRY}/${APP}-windows-amd64:${VERSION}

delete_images:
	gcloud container images delete ${REGISTRY}/${APP}-linux-amd64:${VERSION} --quiet