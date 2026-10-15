<div align="center">

  <!-- Gateway Banner -->
  <a target="_self" title="CLICK HERE to ENTER the GATEWAY FREE!" href="https://mercwar.github.io/Constellation/index.html">
    <img src="https://raw.githubusercontent.com/mercwar/Robo-Knight-Gallery/refs/heads/main/Version%207/image_d2a07390.png" alt="Mercwar Constellation Gateway" style="width:100%; max-width:1200px; height:auto; border-radius:8px; border: 1px solid #00F2FF; box-shadow: 0 0 15px rgba(0, 242, 255, 0.3);" />
  </a>

  <br><br>

  <!-- Header Section -->
  <div class="rku-pro-about" style="max-width: 850px; margin: 0 auto; text-align: left; background: rgba(0, 0, 0, 0.6); padding: 25px; border-radius: 10px; border-left: 4px solid #66ccff; box-shadow: 0 0 20px rgba(0, 150, 255, 0.2);">
    <h1 style="color: #66ccff; text-transform: uppercase; letter-spacing: 3px; text-shadow: 0 0 10px #66ccff; margin: 0 0 5px 0; font-size: 38px;">🎉 JOE-TRON-LLMA</h1>
    <p class="rku-pro-tagline" style="color: #fffe22; font-size: 16px; margin: 0; letter-spacing: 1px;">Official low-level tutorial platform for creating sovereign LLM runtimes.</p>
  </div>

  <br>

  <!-- Nexus Graphic -->
  <a target="_self" title="CLICK HERE to ENTER NEXUS FREE!" href="https://cron.iblogger.com/NEXUS">
    <img src="../images/Joe-Tron-LLMA.png" alt="Mercwar Nexus Graphic" style="width:100%; max-width:850px; height:auto; border-radius:8px; border: 1px solid #FFD700; box-shadow: 0 0 20px rgba(255, 215, 0, 0.25);" />
  </a>

  <br><br>

  <!-- Subtitle Block -->
  <h3 style="color: #cceeff; letter-spacing: 1px; font-weight: normal; margin-bottom: 20px;">🏅 Sovereign Tutorial & Runtime Engine for Building Low-Level LLM Applications</h3>

  <!-- Badges -->
  <p style="margin-bottom: 25px;">
    <a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/badge/License-MIT-yellow.svg" alt="License: MIT" /></a>
    <a href="https://en.wikipedia.org/wiki/C_(programming_language)"><img src="https://img.shields.io/badge/Core-Pure%20C%20%2F%20Assembly-orange.svg" alt="Pure C / Assembly" /></a>
    <a href="app/page-0.md"><img src="https://img.shields.io/badge/Ecosystem-Fire--Gem-cyan.svg" alt="Fire-Gem Ecosystem" /></a>
  </p>

  <!-- Navigation Grid / Action Row -->
  <div style="display: flex; gap: 10px; justify-content: center; flex-wrap: wrap; margin-bottom: 30px;">
    <a class="menu_txt" href="../README.md" style="text-decoration: none;">📡 Main Readme</a>
    <a class="menu_txt" href="../page-TOC.md" style="text-decoration: none;">📦 Main TOC</a>
    <a class="menu_txt" href="page-11.md" style="text-decoration: none;">👈 Previous Page</a>
    <a class="menu_txt" href="page-13.md" style="text-decoration: none;">👉 Next Page</a>
  </div>

# Building Your First Fire-Gem C Runtime: Directory Scanning and GGUF Model Loading

Using the core architecture provided by the **`mercwar/GGML-LLAMA-MSVC-INSTALLER`** export, your first custom C program bridges two critical systems: **Win32 filesystem management** (to dynamically discover GGUF files in your local directory) and **`libllama` memory-mapping** (to load those weights into execution space).

---

## 1. The Operational Concept

Instead of hardcoding paths or guessing what model files are available, a professional runtime shell performs an active directory scan on startup:

1. It queries the local `./models/` folder using native Win32 search handles (`FindFirstFileA`).
2. It parses and prints all available `.gguf` binaries to the console.
3. It selects and loads the target model into memory via memory-mapping (`mmap`) using the Fire-Gem engine headers.

---

## 2. Complete Source Code (`main.c`)

Create your `main.c` file in your workspace root. This code scans your local model repository and initializes the GGUF runtime stack using pure C and Win32 APIs:

```c
#include <windows.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Include headers from the Fire-Gem engine export tree
#include "llama.h"

// Function to scan and display the contents of the local models directory
void print_models_directory(const char * path_pattern) {
    WIN32_FIND_DATAA find_data;
    HANDLE hFind = FindFirstFileA(path_pattern, &find_data);

    if (hFind == INVALID_HANDLE_VALUE) {
        printf("[Directory Scanner] Error: No GGUF models found in target path.\n");
        return;
    }

    printf("\n==========================================\n");
    printf("       LOCAL GGUF MODEL DIRECTORY         \n");
    printf("==========================================\n");

    int index = 0;
    do {
        if (!(find_data.dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY)) {
            printf(" [%d] File: %s\n", index++, find_data.cFileName);
        }
    } while (FindNextFileA(hFind, &find_data) != 0);

    FindClose(hFind);
    printf("==========================================\n\n");
}

int main(int argc, char ** argv) {
    printf("=== Fire-Gem Runtime Environment Initialized ===\n");

    // 1. Scan and list local GGUF models via Win32 API
    print_models_directory("models\\*.gguf");

    // 2. Initialize the underlying GGML tensor backend
    llama_backend_init();

    // 3. Configure load parameters
    struct llama_model_params model_params = llama_model_default_params();
    model_params.n_gpu_layers = 0; // Set to >0 if offloading layers to GPU VRAM

    // 4. Target a specific model for initialization test
    const char * target_model = "models/active_model.gguf";
    printf("Attempting to load model container: %s\n", target_model);

    struct llama_model * model = llama_model_load_from_file(target_model, model_params);
    
    if (!model) {
        fprintf(stderr, "[Error] Failed to memory-map GGUF file. Verify path and architecture.\n");
        llama_backend_free();
        return 1;
    }

    printf("[Success] GGUF model successfully loaded via mmap!\n");

    // 5. Clean teardown of execution state
    llama_model_free(model);
    llama_backend_free();

    printf("=== Execution Terminated Cleanly ===\n");
    return 0;
}

```

---

## 3. Compiling and Linking Against the Mercwar Engine

From your MSYS2 UCRT64 shell or Visual Studio command prompt, compile your code by linking directly against the pre-compiled `llama.lib` and `ggml.lib` binaries provided by the ecosystem layout:

```bash
gcc main.c -o fire-gem-runtime.exe -I./include -L./lib -luser32 -lkernel32 -llama -lggml

```

* **`-I./include`**: Points the compiler to your `llama.h` and `ggml.h` header files.
* **`-L./lib`**: Points the linker to your pre-built static library archives.
* **`-luser32 -lkernel32`**: Links standard Win32 system libraries required for handle manipulation and file system enumeration.

Running your compiled `fire-gem-runtime.exe` will output your directory inventory directly to the console and establish a clean, memory-mapped connection to your local AI model without any external Python overhead.
