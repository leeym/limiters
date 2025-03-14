all: goimports lint test benchmark

docker-compose-up:
	docker compose up -d

test: docker-compose-up
	ETCD_ENDPOINTS="127.0.0.1:2379" REDIS_ADDR="127.0.0.1:6379" REDIS_NODES="127.0.0.1:11000,127.0.0.1:11001,127.0.0.1:11002,127.0.0.1:11003,127.0.0.1:11004,127.0.0.1:11005" ZOOKEEPER_ENDPOINTS="127.0.0.1" CONSUL_ADDR="127.0.0.1:8500" AWS_ADDR="127.0.0.1:8000" MEMCACHED_ADDR="127.0.0.1:11211" POSTGRES_URL="postgres://postgres@localhost:5432/?sslmode=disable" COSMOS_ADDR="127.0.0.1:8081" go test -race -v -failfast

benchmark: docker-compose-up
	ETCD_ENDPOINTS="127.0.0.1:2379" REDIS_ADDR="127.0.0.1:6379" REDIS_NODES="127.0.0.1:11000,127.0.0.1:11001,127.0.0.1:11002,127.0.0.1:11003,127.0.0.1:11004,127.0.0.1:11005" ZOOKEEPER_ENDPOINTS="127.0.0.1" CONSUL_ADDR="127.0.0.1:8500" AWS_ADDR="127.0.0.1:8000" MEMCACHED_ADDR="127.0.0.1:11211" POSTGRES_URL="postgres://postgres@localhost:5432/?sslmode=disable" COSMOS_ADDR="127.0.0.1:8081" go test -race -run=nonexistent -bench=.

lint:
	@which golangci-lint 2>&1 > /dev/null || curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/HEAD/install.sh | sh -s -- -b $(go env GOPATH)/bin v1.64.7
	golangci-lint run ./...

goimports:
	@which goimports 2>&1 > /dev/null || go install golang.org/x/tools/cmd/goimports@latest
	goimports -w .
