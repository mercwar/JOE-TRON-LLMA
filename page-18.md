# Module 15: The Complete Unified Runtime Codebase

To cap off this foundational tutorial series, it is time to assemble every piece we have built—the directory scanner, the memory-mapping loader adapter, the batch tokenization engine, and the token sampling dispatch loop—into a single, production-ready, unified C source file.

Below is the complete `main.c` script. You can save this directly into your workspace root and compile it to run a fully autonomous, local GGUF inference engine on Windows.

---

## The Master `main.c` Implementation

```c
#include <windows.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "llama.h"

// --- Configuration & UI Styling ---
void draw_ui_header() {
    system("cls");
    printf("==================================================\n");
    printf("      FIRE-GEM NATIVE WINDOWS GGUF RUNTIME        \n");
    printf("==================================================\n");
    printf(" Engine: libllama + GGML | Architecture: Pure C   \n");
    printf("--------------------------------------------------\n\n");
}

// --- Component 1: Directory Scanner ---
void scan_local_models(const char * path_pattern) {
    WIN32_FIND_DATAA find_data;
    HANDLE hFind = FindFirstFileA(path_pattern, &find_data);

    if (hFind == INVALID_HANDLE_VALUE) {
        printf("[Directory Scanner] Notice: No .gguf models detected in ./models/\n");
        return;
    }

    printf("[Directory Scanner] Available GGUF Assets:\n");
    int index = 0;
    do {
        if (!(find_data.dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY)) {
            printf("  [%d] %s\n", index++, find_data.cFileName);
        }
    } while (FindNextFileA(hFind, &find_data) != 0);

    FindClose(hFind);
    printf("--------------------------------------------------\n");
}

int main(int argc, char ** argv) {
    draw_ui_header();

    // 1. Scan local environment for model files
    scan_local_models("models\\*.gguf");

    // 2. Initialize global backend subsystems
    printf("[System] Initializing GGML backend hardware layers...\n");
    llama_backend_init();

    // 3. Configure Loader Adapter parameters
    struct llama_model_params model_params = llama_model_default_params();
    model_params.n_gpu_layers = 0; // Set to 99 for full GPU VRAM offloading if available

    const char * model_path = "models/active_model.gguf";
    printf("[Adapter] Memory-mapping GGUF container: %s\n", model_path);

    struct llama_model * model = llama_model_load_from_file(model_path, model_params);
    if (!model) {
        fprintf(stderr, "[Error] Failed to load model file. Verify path and architecture.\n");
        llama_backend_free();
        return 1;
    }
    printf("[Adapter Success] Model weights mapped into virtual space.\n");

    // 4. Allocate execution context and extract vocabulary
    struct llama_context_params ctx_params = llama_context_default_params();
    ctx_params.n_ctx = 2048;
    ctx_params.n_batch = 512;

    struct llama_context * ctx = llama_init_from_model(model, ctx_params);
    if (!ctx) {
        fprintf(stderr, "[Error] Failed to allocate execution context.\n");
        llama_model_free(model);
        llama_backend_free();
        return 1;
    }

    const struct llama_vocab * vocab = llama_model_get_vocab(model);
    printf("[System] Context allocated successfully. Engine online.\n\n");

    // 5. Define prompt input
    const char * prompt = "System: You are an advanced cybernetic systems assistant.\nUser: Hello, robot! State your operational status.\nAssistant:";
    printf("[Send Box] Prompt Ingested:\n%s\n\n", prompt);

    // 6. Tokenize prompt string
    int n_prompt = -llama_tokenize(vocab, prompt, strlen(prompt), NULL, 0, true, true);
    int32_t * prompt_tokens = (int32_t *)malloc(n_prompt * sizeof(int32_t));
    llama_tokenize(vocab, prompt, strlen(prompt), prompt_tokens, n_prompt, true, true);

    // 7. Pack tokens into a batch structure for parallel prefill
    struct llama_batch batch = llama_batch_init(n_prompt, 0, 1);
    for (int i = 0; i < n_prompt; i++) {
        llama_batch_add(batch, prompt_tokens[i], (llama_pos)i, { 0 }, false);
    }
    batch.logits[batch.n_tokens - 1] = true; // Request logits for final token

    // 8. Evaluate batch through transformer graph
    printf("[Engine] Executing parallel prefill decode pass...\n");
    if (llama_decode(ctx, batch) != 0) {
        fprintf(stderr, "[Error] llama_decode failed during batch evaluation.\n");
    }
    llama_batch_free(batch);
    free(prompt_tokens);

    // 9. Dispatch & Token Sampling Loop
    printf("\n[Dispatch] Streaming response tokens:\n> Robot: ");
    
    int max_tokens = 128;
    int tokens_generated = 0;
    llama_token curr_token;

    while (tokens_generated < max_tokens) {
        // Sample next token from output logits
        curr_token = llama_sampler_sample(NULL, ctx, -1);

        // Check for End-Of-Generation token
        if (llama_vocab_is_eog(vocab, curr_token)) {
            break;
        }

        // Convert token ID to string piece and render to UI display
        char buf[128];
        int n = llama_token_to_piece(vocab, curr_token, buf, sizeof(buf), 0, true);
        if (n > 0) {
            buf[n] = '\0';
            printf("%s", buf);
            fflush(stdout);
        }

        // Feed generated token back into single-token batch for next iteration
        struct llama_batch next_batch = llama_batch_init(1, 0, 1);
        llama_batch_add(next_batch, curr_token, n_prompt + tokens_generated, { 0 }, true);
        
        if (llama_decode(ctx, next_batch) != 0) {
            llama_batch_free(next_batch);
            break;
        }
        llama_batch_free(next_batch);
        tokens_generated++;
    }

    printf("\n\n--------------------------------------------------\n");
    printf("[System] Generation session closed cleanly.\n");

    // 10. Safe Cleanup Teardown
    llama_free(ctx);
    llama_model_free(model);
    llama_backend_free();

    printf("=== Program Terminated Successfully ===\n");
    return 0;
}

```

---

## Compiling Your Unified Runtime

Open your MSYS2 UCRT64 shell or developer terminal, ensure your `.gguf` asset is placed inside `./models/active_model.gguf`, and compile the entire application with a single command:

```bash
gcc main.c -o fire-gem-runtime.exe -I./include -L./lib -luser32 -lkernel32 -llama -lggml

```

Run `./fire-gem-runtime.exe` to watch your directory scan, adapter initialization, batch tokenization, and real-time streaming dispatch execute entirely in native machine code.