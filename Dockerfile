# ---------- Build Stage ----------
FROM golang:1.22 AS builder

# Set working directory
WORKDIR /usr/src/app

# Copy go.mod and go.sum to cache dependencies
COPY go.mod go.sum ./
RUN go mod download

# Copy the source code
COPY . .

# Build the Go app
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o product-catalog .

# ---------- Run Stage ----------
FROM alpine:3.19


# Set working directory
WORKDIR /usr/src/app

COPY ./products ./products

# Copy binary from builder stage
COPY --from=builder /usr/src/app/product-catalog .

# Expose service port
EXPOSE 8080

# Run the binary
CMD ["./product-catalog"]

