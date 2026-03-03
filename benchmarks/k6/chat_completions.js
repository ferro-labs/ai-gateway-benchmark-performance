import http from 'k6/http';
import { check, sleep } from 'k6';
import { Rate, Trend } from 'k6/metrics';

const errorRate = new Rate('errors');
const gatewayLatency = new Trend('gateway_latency', true);

const payload = JSON.stringify({
    model: 'gpt-4o',
    messages: [{ role: 'user', content: 'Hello' }],
    stream: false,
});

const params = {
    headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer sk-ferro-benchmarkkey',
    },
};

export const options = {
    scenarios: {
        // Scenario 1: steady state baseline
        baseline: {
            executor: 'constant-vus',
            vus: 50,
            duration: '30s',
            tags: { scenario: 'baseline' },
        },
        // Scenario 2: ramp to peak 5k
        peak_5k: {
            executor: 'ramping-vus',
            startVUs: 0,
            stages: [
                { duration: '30s', target: 1000 },
                { duration: '60s', target: 3000 },
                { duration: '60s', target: 5000 },
                { duration: '30s', target: 0 },
            ],
            tags: { scenario: 'peak_5k' },
        },
    },
    thresholds: {
        http_req_failed: ['rate<0.01'],                  // <1.0% error rate under 5k
        http_req_duration: ['p(95)<100', 'p(99)<250'],     // p95 < 100ms, p99 < 250ms
    },
};

export default function () {
    const res = http.post(
        'http://localhost:8080/v1/chat/completions',
        payload,
        params
    );

    const success = check(res, {
        'status 200': (r) => r.status === 200,
        'has choices': (r) => r.json('choices') !== undefined,
        'latency < 50ms': (r) => r.timings.duration < 50,
    });

    errorRate.add(!success);
    gatewayLatency.add(res.timings.duration);
}
