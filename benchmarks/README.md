# Benchmarks

This directory contains the load testing and benchmarking infrastructure for FerroGateway.

It uses a Ferro Labs AI Gateway (Mock) server to simulate instant OpenAI-compatible backend responses. This ensures we are testing the pure gateway processing overhead, not internet latency.

## Prerequisites
- `go 1.24+`
- `k6` (used for latency distributions and detailed metrics)
- `wrk` (used for peak max RPS testing)

## Running the Automated Benchmark Suite

The easiest way to run the full k6 test suite is via the Makefile.
This will handle building dependencies, starting the mock server, booting the gateway, and stopping everything afterwards.

```bash
make bench-full
```

Results are dumped in `.json` format located in the `results/` folder.

## Running Tests Manually

1. **Boot Mock Provider:**
   ```bash
   go run benchmarks/mockprovider/main.go
   ```

2. **Start Gateway:**
   ```bash
   MOCK_PROVIDER_URL=http://localhost:9090 ./bin/ferrogw --config benchmarks/config.yaml
   ```

3. **Run K6 Test:**
   ```bash
   k6 run benchmarks/k6/chat_completions.js
   ```

4. **Run wrk (Max RPS Peak Test):**
   ```bash
   wrk -t12 -c500 -d60s -s benchmarks/wrk/chat_completions.lua http://localhost:8080/v1/chat/completions
   ```
