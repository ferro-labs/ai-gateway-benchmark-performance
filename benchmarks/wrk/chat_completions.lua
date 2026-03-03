wrk.method = "POST"
wrk.headers["Content-Type"] = "application/json"
wrk.headers["Authorization"] = "Bearer sk-ferro-benchmarkkey"
wrk.body = '{"model":"gpt-4o","messages":[{"role":"user","content":"Hello"}]}'
