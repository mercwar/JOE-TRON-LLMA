# Fire-Gem GGUF Runtime 🚀

### Sovereign, Zero-Dependency Local AI Inference in Pure C

Welcome to the official repository for **Fire-Gem**—a high-performance, native Windows GGUF runtime engine built from the bare metal up in pure C (`C89/C99/UCRT64`) and Win32 APIs.

Say goodbye to heavy Python virtual environments, bloated pip dependencies, and cloud telemetry daemons. Fire-Gem maps multi-gigabyte transformer models directly into virtual memory and executes blazing-fast local AI inference straight on your hardware.

---

## 🌟 Why Fire-Gem?

* **Absolute Independence:** Zero runtime dependencies beyond a single compiled binary and your `.gguf` weight file.
* **Direct Memory-Mapping (`mmap`):** Bypasses heavy RAM heap copying by leveraging native Windows virtual memory page mapping.
* **First-Principles Architecture:** Built using low-level Win32 APIs, native directory scanning, custom token batching, and direct tensor graph evaluation via `libllama` and `GGML`.
* **Hardware-Near Optimization:** Taps directly into processor vector instructions (`AVX2`/`AVX-512`) for maximum token throughput.

---

## 📂 Documentation & Table of Contents (`app/page-1.md` to `app/page-20.md`)

Our comprehensive 20-page engineering guide and architectural documentation is structured across dedicated modular pages inside the `app/` directory:

### Part I: Introduction & Environment Provisioning

* **[Page 1: Master README & Architecture Overview](https://www.google.com/search?q=app/page-1.md)** — Introduction to sovereign local intelligence and execution models.
* **[Page 2: Ecosystem Philosophy & Sovereignty](https://www.google.com/search?q=app/page-2.md)** — Why pure C and native Win32 APIs beat heavyweight abstractions.
* **[Page 3: Environment Setup & Toolchain Provisioning](https://www.google.com/search?q=app/page-3.md)** — Configuring MSYS2 UCRT64, GCC/Clang, Git, and GNU make.
* **[Page 4: Acquiring Model Assets & GGUF Sourcing](https://www.google.com/search?q=app/page-4.md)** — Downloading and managing single-file quantized weights from Hugging Face.
* **[Page 5: Workspace Directory Layout](https://www.google.com/search?q=app/page-5.md)** — Structuring `/models`, `/include`, and `/lib` directories.

### Part II: Core C Runtimes & Loader Adapters

* **[Page 6: Integrating MercWar Ecosystem Assets](https://www.google.com/search?q=app/page-6.md)** — Importing headers and static libraries from `mercwar/GGML-LLAMA-MSVC-INSTALLER`.
* **[Page 7: Core C Entry Point (`main.c` Initialization)](https://www.google.com/search?q=app/page-7.md)** — Writing foundational program startup and hardware initialization gates.
* **[Page 8: Win32 Directory Scanning](https://www.google.com/search?q=app/page-8.md)** — Discovering GGUF assets dynamically using `FindFirstFileA()`.
* **[Page 9: The Model Loader Adapter](https://www.google.com/search?q=app/page-9.md)** — Memory-mapping weights into virtual space via `llama_model_load_from_file()`.
* **[Page 10: Prompt Ingestion & String Tokenization](https://www.google.com/search?q=app/page-10.md)** — Converting raw text strings into integer token arrays with `llama_tokenize()`.

### Part III: Batching, Prefill, and Dispatch

* **[Page 11: Batch Allocation & Token Structuring](https://www.google.com/search?q=app/page-11.md)** — Packaging token sequences into parallel execution blocks.
* **[Page 12: Transformer Graph Prefill Decoding](https://www.google.com/search?q=app/page-12.md)** — Executing parallel forward passes with `llama_decode()`.
* **[Page 13: The Dispatch Gate & Token Sampling Loops](https://www.google.com/search?q=app/page-13.md)** — Transforming raw logits into readable text streams.
* **[Page 14: Modular Sampler Chains (`llama_sampler`)](https://www.google.com/search?q=app/page-14.md)** — Controlling generation randomness with top-K, top-P, and temperature filters.
* **[Page 15: The Unified Master `main.c` Implementation](https://www.google.com/search?q=app/page-15.md)** — The complete, production-ready source code listing.

### Part IV: Advanced Architectures & Next Steps

* **[Page 16: Hardware Offloading & Structured Grammars](https://www.google.com/search?q=app/page-16.md)** — Scaling via Vulkan/CUDA and enforcing JSON schemas using GBNF grammars.
* **[Page 17: KV Caching & WinSock REST Servers](https://www.google.com/search?q=app/page-17.md)** — Building multi-threaded TCP listeners (`ws2_32.lib`) and optimizing state persistence.

### Part V: Reference, Index, and Legal Framework

* **[Page 18: Technical Appendix & Build Cheat Sheet](https://www.google.com/search?q=app/page-18.md)** — Quick compiler references and linker flags.
* **[Page 19: Comprehensive Terminology Glossary & Index](https://www.google.com/search?q=app/page-19.md)** — Low-level tensor definitions and cross-reference matrices.
* **[Page 20: Credits, Licensing & Mercwar Legal Framework](https://www.google.com/search?q=app/page-20.md)** — MIT licensing, upstream `llama.cpp` attributions, and autonomous ecosystem ingestion rules.

---

## ⚡ Quick Start & Compilation

1. Ensure your `.gguf` model file is placed in `./models/active_model.gguf`.
2. Open your **MSYS2 UCRT64** shell and compile the unified runtime directly:

```bash
gcc main.c -o fire-gem-runtime.exe -I./include -L./lib -luser32 -lkernel32 -llama -lggml

```

3. Launch your sovereign local AI engine:

```bash
./fire-gem-runtime.exe

```

---

## 🛡️ License & Attributions

Distributed under the **MIT License**. Powered upstream by `llama.cpp` and `GGML` (created by Georgi Gerganov and the open-source community). Developed under the sovereign specifications of the Mercwar Ecosystem.