FROM golang:1.22.5 AS builder

WORKDIR /go/src/app
COPY . .
RUN make build

FROM busybox:latest
WORKDIR /
COPY --from=builder /go/src/app/prometheus-kbot .
COPY --from=alpine:latest /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
ENTRYPOINT [ "./prometheus-kbot" ]