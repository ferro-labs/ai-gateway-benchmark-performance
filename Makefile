# Ferro Labs AI Gateway Benchmark Suite
# Orchestrates performance tests against the AI Gateway

GITHUB_REPO = github.com/ferro-labs/ai-gateway/cmd/ferrogw
BINARY_NAME = ferrogw
MOCK_PROVIDER = mockprovider

.PHONY: all build clean bench-setup bench-http bench-teardown bench-full

all: build

build:
	@echo "Fetching latest AI Gateway from GitHub..."
	@mkdir -p bin
	GOBIN=$(shell pwd)/bin go install $(GITHUB_REPO)@latest
	@echo "Building Mock Provider..."
	go build -o bin/$(MOCK_PROVIDER) ./benchmarks/mockprovider/main.go

bench-setup: build
	@echo "Setting up HTTP benchmark environment..."
	@mkdir -p benchmarks/results
	./bin/$(MOCK_PROVIDER) & echo $$! > bin/mockprovider.pid
	sleep 1
	GATEWAY_CONFIG=benchmarks/config.yaml OPENAI_API_KEY=sk-mock MOCK_PROVIDER_URL=http://localhost:9090 ./bin/$(BINARY_NAME) & echo $$! > bin/ferrogw.pid
	sleep 2

bench-http:
	@echo "Running k6 HTTP benchmarks..."
	k6 run \
	  --out json=benchmarks/results/$(shell date +%Y%m%d_%H%M%S).json \
	  benchmarks/k6/chat_completions.js

bench-teardown:
	@echo "Tearing down HTTP benchmark environment..."
	@if [ -f bin/ferrogw.pid ]; then kill -9 $$(cat bin/ferrogw.pid) 2>/dev/null || true; rm bin/ferrogw.pid; fi
	@if [ -f bin/mockprovider.pid ]; then kill -9 $$(cat bin/mockprovider.pid) 2>/dev/null || true; rm bin/mockprovider.pid; fi

bench-full: bench-setup bench-http bench-teardown

clean:
	@echo "Cleaning build artifacts..."
	rm -rf bin benchmarks/results/*.json
