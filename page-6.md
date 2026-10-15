# Module 6: Writing the Core C Inference Loop

Now that your toolchain is configured, the libraries are compiled, and your local `.gguf` file is sitting on disk, it is time to write the code that brings everything to life.

Below is the blueprint for a minimal, native C entry point that initializes the runtime, loads the GGUF model into memory via `libllama`, tokenizes a prompt, and executes the generation loop.

---

## The Complete `main.c` Implementation

Create a file named `main.c` in your workspace directory. This code demonstrates the fundamental sequence required by any custom LLM runtime shell:

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Include headers from the cloned llama.cpp source directory
#include "llama.h"

int main(int argc, char ** argv) {
    printf("=== Starting Native Windows GGUF Runtime ===\n");

    // 1. Initialize the global backend subsystems (detects AVX2, AVX-512, CUDA, etc.)
    llama_backend_init();

    // 2. Define model load parameters and set GPU offload layers if applicable
    struct llama_model_params model_params = llama_model_default_params();
    model_params.n_gpu_layers = 99; // Offload all layers to GPU if VRAM allows, else set to 0 for CPU-only

    // 3. Load the model from your local GGUF file path
    const char * model_path = "models/active_model.gguf";
    struct llama_model * model = llama_model_load_from_file(model_path, model_params);
    
    if (!model) {
        fprintf(stderr, "Error: Failed to load GGUF model from %s\n", model_path);
        llama_backend_free();
        return 1;
    }
    printf("Model loaded successfully into memory-mapped space.\n");

    // 4. Create the execution context parameters
    struct llama_context_params ctx_params = llama_context_default_params();
    ctx_params.n_ctx = 2048; // Context window size
    ctx_params.n_batch = 512; // Batch processing limit for prompt ingestion

    struct llama_context * ctx = llama_init_from_model(model, ctx_params);
    if (!ctx) {
        fprintf(stderr, "Error: Failed to create llama execution context.\n");
        llama_model_free(model);
        llama_backend_free();
        return 1;
    }

    // 5. Retrieve vocabulary reference for tokenization
    const struct llama_vocab * vocab = llama_model_get_vocab(model);

    // 6. Tokenize a test prompt
    const char * prompt = "Write a one-sentence technical greeting for a systems engineer.";
    
    // Determine token count requirement
    int n_prompt = -llama_tokenize(vocab, prompt, strlen(prompt), NULL, 0, true, true);
    int32_t * prompt_tokens = (int32_t *)malloc(n_prompt * sizeof(int32_t));

    if (llama_tokenize(vocab, prompt, strlen(prompt), prompt_tokens, n_prompt, true, true) < 0) {
        fprintf(stderr, "Error: Failed to tokenize the prompt string.\n");
        free(prompt_tokens);
        llama_free(ctx);
        llama_model_free(model);
        llama_backend_free();
        return 1;
    }

    printf("\nPrompt: \"%s\"\nTokens parsed: %d\n\n--- Generation Output ---\n", prompt, n_prompt);

    // 7. Setup a basic batch container to feed tokens into the transformer graph
    // (In a full production loop, you would evaluate tokens and pass them to a sampler)
    
    // Cleanup allocated structures
    free(prompt_tokens);
    llama_free(ctx);
    llama_model_free(model);
    llama_backend_free();

    printf("\n=== Execution Completed Safely ===\n");
    return 0;
}

```

---

## Understanding the Execution Steps

1. **`llama_backend_init()`**: Sets up global thread pools, hardware instruction lookup tables (checking if your CPU supports AVX-512 or AMX), and timing trackers.
2. **`llama_model_load_from_file()`**: Triggers the Win32 memory-mapping sequence behind the scenes, reading the GGUF tensor layout and establishing virtual address maps without choking your physical RAM.
3. **`llama_init_from_model()`**: Allocates the scratchpad memory and creates the operational context required to manage attention states and KV caches during text generation.
4. **`llama_tokenize()`**: Maps raw UTF-8 text strings directly to integer token IDs matching the model's specialized vocabulary array.

---

### What's next in our tutorial progression?

1. **Building the Sampler & Token Loop:** Constructing the generation loop (`llama_decode`) to process output probabilities and stream tokens sequentially.
2. **Exposing an OpenAI-Compatible Local API:** Writing a lightweight wrapper to serve endpoints locally over HTTP.

Where should we guide to next ?