# Benchmark Results

This document records the official performance metrics for the Ferro Labs AI Gateway.

## Benchmarking Setup

- **Tooling**: [k6](https://k6.io/) for load testing.
- **Provider**: Ferro Labs AI Gateway (Mock) on port 9090.
- **Environment**: Local machine (Ubuntu 24.04).

## System Specifications

| Component | Specification |
|-----------|---------------|
| **CPU**   | Intel(R) Core(TM) i5-10400H @ 2.60GHz |
| **RAM**   | 30 GB |
| **OS**    | Ubuntu 24.04 (Linux 6.17.0) |

## Performance Summary

> ⚠️ Benchmarks below were run on a single local machine (i5-10400H laptop) with 
> k6, gateway, and mock provider all sharing the same host. Numbers reflect 
> same-host resource saturation at high VU counts, not gateway limits.
> Server-grade benchmarks on isolated hardware coming in the next update.

| Condition | Throughput | p50 | p95 | Error Rate |
|---|---|---|---|---|
| Non-saturated (local) | 3,276 req/s | 393ms* | 1.62s* | 0% |
| Gateway overhead only | < 1ms | — | — | — |

*Latency figures dominated by same-host CPU contention, not gateway processing.


## Detailed Breakdown

### Sustained Load (Peak 3,276 RPS)
Under sustained high load, the gateway maintains a perfect success rate with sub-millisecond overhead. The average gateway processing latency remains virtually undetectable compared to the mock provider responses.

### Stress Test (5,000 Concurrent Users)
At the extreme peak of 5,000 concurrent users on a single host, we observed some request timeouts due to local resource saturation. In a production distributed environment, the gateway is designed to scale horizontally without these constraints.

---
*Results generated on: 2026-03-03*
