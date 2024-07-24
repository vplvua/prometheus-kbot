# Build stage
FROM quay.io/projectquay/golang:1.20 AS builder

WORKDIR /go/src/app
COPY go.mod go.sum ./
RUN go mod download
COPY . .
ARG TARGETOS
ARG TARGETARCH
RUN make TARGETOS=${TARGETOS} TARGETARCH=${TARGETARCH} build

# Final stage
FROM scratch
WORKDIR /
ARG TARGETOS
ARG TARGETARCH
COPY --from=builder /go/src/app/prometheus-kbot-${TARGETOS}-${TARGETARCH} /prometheus-kbot
COPY --from=alpine:latest /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/

LABEL maintainer="Vasyl Pashko vasyl.pashko@gmail.com"
LABEL source="https://github.com/vplvua/prometheus-kbot"
LABEL version="1.0"
LABEL description="Prometheus kbot application"

ENTRYPOINT [ "/prometheus-kbot" ]