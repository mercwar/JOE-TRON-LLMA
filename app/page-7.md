# Module 5.5: Complete Developer Setup Inventory & Asset Acquisition Blueprint

Before you write your very first `main.c` file to instantiate a local model studio runtime, your local development environment must be fully provisioned.

If you attempt to write code without gathering and compiling these components first, your compiler will fail immediately on missing headers (`llama.h`) and unresolved external symbols (`llama_backend_init`).

---

## Part 1: The Master Inventory Checklist

To successfully build and run a native Windows GGUF application from scratch, you need three distinct layers: **Toolchains**, **Engine Libraries**, and **Model Assets**.

| Item | Component Name | Purpose | Where / How to Get It |
| --- | --- | --- | --- |
| **1** | **Compiler Toolchain** | MSVC (Visual Studio Build Tools) or MinGW-w64 (MSYS2 UCRT64) | Visual Studio Installer or `pacman -S mingw-w64-ucrt64-toolchain` |
| **2** | **Build Orchestrator** | CMake (v3.14+) | Official CMake installer (`cmake.org`) or package manager |
| **3** | **Source Engine** | `llama.cpp` repository (containing `ggml` & `libllama`) | Cloned from GitHub (`git clone [https://github.com/ggml-org/llama.cpp.git](https://github.com/ggml-org/llama.cpp.git)`) |
| **4** | **Compiled Binaries** | Static/Dynamic libraries (`llama.lib`, `ggml.lib`) | Built locally via CMake and MSBuild/Make |
| **5** | **GGUF Target Asset** | A quantized single-file model (e.g., `Llama-3-8B-Instruct-Q4_K_M.gguf`) | Downloaded manually from Hugging Face Hub |

---

## Part 2: Step-by-Step Acquisition Workflow

Follow this end-to-end initialization sequence to get your machine ready before touching a single line of C source code.

### Step 1: Install the Build Dependencies

Open your terminal and verify that your build tools are accessible in your environment path:

```bash
git --version
cmake --version

```

### Step 2: Clone and Build the Engine Libraries

Clone the source code from GitHub, configure the build directory using CMake, and compile the engine targets to generate your linkable static library binaries:

```bash
# 1. Clone the core repository
git clone https://github.com/ggml-org/llama.cpp.git
cd llama.cpp

# 2. Configure project files with CMake (targeting local CPU vector instructions)
cmake -B build -DCMAKE_BUILD_TYPE=Release

# 3. Compile the target libraries and binaries
cmake --build build --config Release -j 8

```

### Step 3: Acquire Your GGUF Model File

Using Python and the Hugging Face hub toolset, fetch a lightweight model file directly into a clean `models/` directory inside your workspace:

```bash
# Install the HF hub CLI tool
pip install huggingface-hub

# Download a specific quantized model file to avoid pulling unnecessary multi-gigabyte shards
huggingface-cli download bartowski/Llama-3-8B-Instruct-GGUF \
  --include "Llama-3-8B-Instruct-Q4_K_M.gguf" \
  --local-dir ./models \
  --local-dir-use-symlinks False

```

### Step 4: Establish Your Workspace Directory Layout

Organize your project folder so your custom C code can cleanly reference the engine headers and compiled libraries without messy absolute paths:

```text
/my-llm-studio/
│
├── build/                   <-- CMake build output directory from llama.cpp
├── models/
│   └── Llama-3-8B-Instruct-Q4_K_M.gguf  <-- Your local GGUF file
│
├── include/                 <-- Header files copied from llama.cpp root
│   ├── llama.h
│   └── ggml.h
│
├── lib/                     <-- Compiled static library files (.lib)
│   ├── llama.lib
│   └── ggml.lib
│
└── main.c                   <-- Your custom entry-point source file

```

---

Once your folder structure matches this blueprint, your environment is fully primed. You now have the compiled library artifacts, the structural headers, and a local GGUF model waiting on disk—enabling you to safely write and compile the C inference loop we outlined previously.