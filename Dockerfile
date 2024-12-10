FROM public.ecr.aws/docker/library/golang:1.21-alpine

WORKDIR /usr/src/app

COPY . .

# pre-copy/cache go.mod for pre-downloading dependencies and only redownloading them in subsequent builds if they change
COPY go.mod go.sum ./
RUN go mod tidy

run echo "DEBUGGING ENV VAR"
run echo "POSTGRES_HOST=$POSTGRES_HOST"
run echo "POSTGRES_USER=$POSTGRES_USER"
run echo "POSTGRES_PASSWORD=$POSTGRES_PASSWORD"
run echo "POSTGRES_DB=$POSTGRES_DB"
run echo "POSTGRES_PORT=$POSTGRES_PORT"



CMD ["go", "run", "."]
