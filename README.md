# Ferro Labs AI Gateway Benchmark Performance

This repository contains benchmarks and load testing infrastructure for [Ferro Labs AI Gateway](https://github.com/ferro-labs/ai-gateway).

## Performance

**Ferro Labs AI Gateway adds virtually zero overhead.** In sustained benchmarks, the gateway demonstrates exceptional efficiency, handling thousands of requests per second with sub-millisecond processing time.

### Performance Comparison

> ⚠️ Benchmarks below were run on a single local machine (i5-10400H laptop) with 
> k6, gateway, and mock provider all sharing the same host. Numbers reflect 
> same-host resource saturation at high VU counts, not gateway limits.
> Server-grade benchmarks on isolated hardware coming in the next update.

| Condition | Throughput | p50 | p95 | Error Rate |
|---|---|---|---|---|
| Non-saturated (local) | 3,276 req/s | 393ms* | 1.62s* | 0% |
| Gateway overhead only | < 1ms | — | — | — |

*Latency figures dominated by same-host CPU contention, not gateway processing.


## Getting Started

Detailed instructions for running the benchmarks can be found in the [benchmarks/](benchmarks/README.md) directory.

### Quick Start

```bash
# Run the 5k benchmark suite
make bench-full
```

## Results

Detailed benchmark results and system specifications can be found in [BENCHMARKS.md](BENCHMARKS.md).

## Tools Used

- **k6**: Load testing and latency distributions.
- **wrk**: High-throughput RPS testing.
- **Go**: Ferro Labs AI Gateway (Mock)
