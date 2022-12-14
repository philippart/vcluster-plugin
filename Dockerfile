# Build the manager binary
FROM golang:1.19 as builder

# Add labels
LABEL org.opencontainers.image.source=https://github.com/philippart/vcluster-plugin
LABEL org.opencontainers.image.description="vcluster plugin for custom resources"
LABEL org.opencontainers.image.licenses=Apache-2.0

# Make sure we use go modules
WORKDIR vcluster

# Copy the Go Modules manifests
COPY . .

# Install dependencies
RUN go mod vendor

# Build cmd
RUN CGO_ENABLED=0 GO111MODULE=on go build -mod vendor -o /plugin main.go

# we use alpine for easier debugging
FROM alpine

# Set root path as working directory
WORKDIR /

COPY --from=builder /plugin .

ENTRYPOINT ["/plugin"]
