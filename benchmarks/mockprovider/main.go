package main

import (
	"encoding/json"
	"log"
	"net/http"
	"time"
)

// Minimal OpenAI-compatible response — returned instantly, no delay
var fixedResponse = map[string]any{
	"id":      "chatcmpl-mock",
	"object":  "chat.completion",
	"created": time.Now().Unix(),
	"model":   "gpt-4o",
	"choices": []map[string]any{
		{
			"index": 0,
			"message": map[string]string{
				"role":    "assistant",
				"content": "Hello from mock provider.",
			},
			"finish_reason": "stop",
		},
	},
	"usage": map[string]int{
		"prompt_tokens":     10,
		"completion_tokens": 6,
		"total_tokens":      16,
	},
}

func main() {
	handler := func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		json.NewEncoder(w).Encode(fixedResponse)
	}

	modelsHandler := func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		json.NewEncoder(w).Encode(map[string]any{
			"object": "list",
			"data":   []map[string]string{{"id": "gpt-4o", "object": "model"}},
		})
	}

	http.HandleFunc("/v1/chat/completions", handler)
	http.HandleFunc("/chat/completions", handler)
	http.HandleFunc("/v1/models", modelsHandler)
	http.HandleFunc("/models", modelsHandler)

	log.Println("Mock provider listening on :9090")
	log.Fatal(http.ListenAndServe(":9090", nil))
}
