# Building the C Model Loader Adapter & Interfacing with `libllama`

Now that your program can successfully discover local GGUF files in your directory, the next phase is building the **Loader Adapter**—the structural bridge that maps the selected model file into a fully realized execution state using `libllama` function calls.

---

## 1. How the Loader Adapter Works

In native C systems programming, an adapter layer handles configuration and safety checks before handing raw pointers over to the core execution engine. The loader workflow consists of four specific sequential boundaries:

1. **The Backend Setup Gate:** Initializing global thread structures and CPU instruction vector detection tables via `llama_backend_init()`.
2. **The Parameter Struct Structuring:** Declaring and modifying `llama_model_params` (such as hardware layer offloading) and `llama_context_params` (such as token context window sizing).
3. **The File-to-Memory Translation:** Invoking `llama_model_load_from_file()` to map the container.
4. **The Runtime Context Allocation:** Spawning `llama_init_from_model()` to instantiate the operational KV cache and tensor graph processing space.

---

## 2. Updated C Code: Complete Loader Adapter and Engine Bridge

Expand your `main.c` file to include the full adapter initialization routine. This version accepts a dynamic file target, validates the model struct, and establishes the active context interface:

```c
#include <windows.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Include the Fire-Gem engine headers
#include "llama.h"

// Adapter configuration structure for our runtime session
typedef struct {
    const char * model_path;
    int32_t context_window;
    int32_t gpu_layers;
} RuntimeConfig;

// Initialize and bind the GGUF model via libllama adapter functions
struct llama_context * initialize_llm_engine(RuntimeConfig * config, struct llama_model ** out_model) {
    printf("\n[Adapter] Initializing global LLM backend subsystem...\n");
    llama_backend_init();

    // 1. Set model parameters using library defaults
    struct llama_model_params model_params = llama_model_default_params();
    model_params.n_gpu_layers = config->gpu_layers; // Configure VRAM offloading

    printf("[Adapter] Loading GGUF container from: %s\n", config->model_path);
    *out_model = llama_model_load_from_file(config->model_path, model_params);
    
    if (!*out_model) {
        fprintf(stderr, "[Adapter Error] Failed to load or memory-map the GGUF file.\n");
        return NULL;
    }
    printf("[Adapter Success] Model weights successfully mapped into virtual space.\n");

    // 2. Set context execution parameters
    struct llama_context_params ctx_params = llama_context_default_params();
    ctx_params.n_ctx = config->context_window;
    ctx_params.n_batch = 512;

    printf("[Adapter] Allocating execution context (n_ctx = %d)...\n", config->context_window);
    struct llama_context * ctx = llama_init_from_model(*out_model, ctx_params);

    if (!ctx) {
        fprintf(stderr, "[Adapter Error] Failed to allocate llama execution context.\n");
        llama_model_free(*out_model);
        return NULL;
    }

    printf("[Adapter Success] Context initialized and ready for token evaluation.\n");
    return ctx;
}

int main(int argc, char ** argv) {
    printf("=== Fire-Gem Engine Loader Adapter ===\n");

    // Configure our runtime parameters
    RuntimeConfig config;
    config.model_path = "models/active_model.gguf";
    config.context_window = 2048;
    config.gpu_layers = 0; // Set to 99 to push layers to GPU, 0 for pure CPU execution

    struct llama_model * model = NULL;
    struct llama_context * ctx = initialize_llm_engine(&config, &model);

    if (!ctx || !model) {
        fprintf(stderr, "Initialization pipeline halted due to adapter errors.\n");
        return 1;
    }

    // --- Ready for Prompt Ingestion and Generation Loops ---
    printf("\n[System Status] Engine is fully engaged and bound to libllama.\n");

    // Clean teardown sequence
    printf("\n[Adapter] Freeing execution context and unloading model weights...\n");
    llama_free(ctx);
    llama_model_free(model);
    llama_backend_free();

    printf("=== Safe Shutdown Completed ===\n");
    return 0;
}

```

---

## 3. Compiling the Updated Adapter

Re-run your compilation command in your MSYS2 UCRT64 shell to link your adapter directly against the static libraries:

```bash
gcc main.c -o fire-gem-runtime.exe -I./include -L./lib -luser32 -lkernel32 -llama -lggml

```

Once compiled, executing `./fire-gem-runtime.exe` will instantiate the adapter, establish memory-mapping with your GGUF asset, allocate the context window, and safely tear down the pipeline—all in pure C without any external runtime dependencies.