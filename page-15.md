# Module 11: Prompt Batching, Tokenization Arrays, and Evaluation Logic

When building a high-performance local inference engine in pure C, sending a user's prompt text to the model requires a precise pipeline. Instead of feeding tokens into the transformer one by one (which would crawl at glacial speeds), developers use **batching** to package entire prompt sequences into single memory blocks, tokenize them cleanly against the GGUF vocabulary, and evaluate them through `libllama`.

---

## 1. The Core Concepts: Tokenization, Batching, and Decoding

To make your C executable parse and respond to input prompts dynamically, three low-level components work together:

1. **Tokenization (`llama_tokenize`)**:
Raw strings (like `"Hello, robot!"`) cannot be processed directly by neural networks. Tokenization splits strings into a sequence of integer IDs mapping directly to the model's vocabulary matrix.
2. **Batch Allocation (`struct llama_batch`)**:
Instead of running separate forward passes for each token, `llama.cpp` uses a batch container (`llama_batch_init`) to hold multiple tokens simultaneously. This allows the GPU or CPU vector instructions to compute the prompt's structural context in one massive parallel prefill pass.
3. **Graph Evaluation (`llama_decode`)**:
`llama_decode()` passes the populated batch through the transformer layers. It updates the internal Key-Value (KV) cache so the model "remembers" the incoming text and generates logically coherent replies.

---

## 2. Complete C Implementation: Prompt Batching and Token Ingestion

Update your C source file to include the complete prompt tokenization and batch-packing sequence:

```c
#include <windows.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "llama.h"

int main(int argc, char ** argv) {
    printf("=== Fire-Gem Batch Tokenizer & Evaluator ===\n");

    // 1. Initialize backend subsystems
    llama_backend_init();

    // 2. Load the GGUF model via mmap
    struct llama_model_params model_params = llama_model_default_params();
    model_params.n_gpu_layers = 0; // Set to 99 for full GPU offload if supported

    const char * model_path = "models/active_model.gguf";
    struct llama_model * model = llama_model_load_from_file(model_path, model_params);
    if (!model) {
        fprintf(stderr, "[Error] Failed to load model from %s\n", model_path);
        llama_backend_free();
        return 1;
    }

    // 3. Create context and extract model vocabulary
    struct llama_context_params ctx_params = llama_context_default_params();
    ctx_params.n_ctx = 2048;
    ctx_params.n_batch = 512;

    struct llama_context * ctx = llama_init_from_model(model, ctx_params);
    if (!ctx) {
        fprintf(stderr, "[Error] Failed to create execution context.\n");
        llama_model_free(model);
        llama_backend_free();
        return 1;
    }

    const struct llama_vocab * vocab = llama_model_get_vocab(model);

    // 4. Define our target input prompt string
    const char * prompt = "System: You are an advanced cybernetic assistant.\nUser: Hello, robot! Report status.\nAssistant:";
    printf("\n[Prompt Input]:\n%s\n\n", prompt);

    // 5. Tokenize the prompt string
    // First pass: evaluate required token count (negative return value signals size)
    int n_prompt = -llama_tokenize(vocab, prompt, strlen(prompt), NULL, 0, true, true);
    int32_t * prompt_tokens = (int32_t * )malloc(n_prompt * sizeof(int32_t));

    // Second pass: fill the token array
    if (llama_tokenize(vocab, prompt, strlen(prompt), prompt_tokens, n_prompt, true, true) < 0) {
        fprintf(stderr, "[Error] Tokenization failed.\n");
        free(prompt_tokens);
        llama_free(ctx);
        llama_model_free(model);
        llama_backend_free();
        return 1;
    }
    printf("[Tokenizer] Successfully parsed prompt into %d tokens.\n", n_prompt);

    // 6. Initialize batch structure and pack tokens
    // Parameters: n_tokens_alloc, embd (0 for token IDs), n_seq_max
    struct llama_batch batch = llama_batch_init(n_prompt, 0, 1);

    for (int i = 0; i < n_prompt; i++) {
        llama_batch_add(batch, prompt_tokens[i], (llama_pos)i, { 0 }, false);
    }
    
    // Explicitly flag the final token in the batch to output logits for generation sampling
    batch.logits[batch.n_tokens - 1] = true;

    // 7. Evaluate the batched prompt through the transformer graph
    printf("[Engine] Executing parallel batch decode (prefill pass)...\n");
    if (llama_decode(ctx, batch) != 0) {
        fprintf(stderr, "[Error] llama_decode failed during batch evaluation.\n");
    } else {
        printf("[Engine Success] Prompt batch evaluated successfully. Ready to stream tokens.\n");
    }

    // Cleanup resources
    llama_batch_free(batch);
    free(prompt_tokens);
    llama_free(ctx);
    llama_model_free(model);
    llama_backend_free();

    printf("\n=== Batch Pipeline Executed Cleanly ===\n");
    return 0;
}

```

---

## 3. Why Batching Matters for Performance

* **Maximized Throughput:** Feeding tokens in a single batch array instead of one-by-one allows the CPU vector instruction sets (AVX2/AVX-512) or GPU kernels to run matrix multiplications in parallel.
* **Stable Graph Execution:** Packing prompts efficiently prevents memory fragmentation in the `ggml` scratch buffers, maintaining high speed during the initial prompt ingestion ("prefill") phase.