FROM public.ecr.aws/docker/library/golang:1.21-alpine

WORKDIR /usr/src/app

COPY . .

# pre-copy/cache go.mod for pre-downloading dependencies and only redownloading them in subsequent builds if they change
COPY go.mod go.sum ./
RUN go mod tidy

echo "DEBUGGING ENV VAR"
echo "POSTGRES_HOST=$POSTGRES_HOST"
echo "POSTGRES_USER=$POSTGRES_USER"
echo "POSTGRES_PASSWORD=$POSTGRES_PASSWORD"
echo "POSTGRES_DB=$POSTGRES_DB"
echo "POSTGRES_PORT=$POSTGRES_PORT"



CMD ["go", "run", "."]
