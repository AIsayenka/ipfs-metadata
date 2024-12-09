FROM golang:1.21-alpine

WORKDIR /usr/src/app

COPY . .

# pre-copy/cache go.mod for pre-downloading dependencies and only redownloading them in subsequent builds if they change
COPY go.mod go.sum ./
RUN go mod download && go mod verify



CMD ["go", "run", "."]