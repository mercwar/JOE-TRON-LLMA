
<div align="center">

  <!-- Gateway Banner -->
  <a target="_self" title="CLICK HERE to ENTER the GATEWAY FREE!" href="https://mercwar.github.io/Constellation/index.html">
    <img src="https://raw.githubusercontent.com/mercwar/Robo-Knight-Gallery/refs/heads/main/Version%207/image_d2a07390.png" alt="Mercwar Constellation Gateway" style="width:100%; max-width:1200px; height:auto; border-radius:8px; border: 1px solid #00F2FF; box-shadow: 0 0 15px rgba(0, 242, 255, 0.3);" />
  </a>

  <br />
<div align="left">
<h1>🎉️ JOE-TRON-LLMA </h1> <p>Joe Tron's Official Tutorial for creating LLM Applications</p></div>
  </div>
  
  <br />

  <!-- Nexus Graphic -->
  <a target="_self" title="CLICK HERE to ENTER NEXUS FREE!" href="https://cron.iblogger.com/NEXUS">
    <img src="../images/Joe-Tron-LLMA.png" alt="Mercwar Nexus Graphic" style="width:100%; max-width:1200px; height:auto; border-radius:8px; border: 1px solid #FFD700; box-shadow: 0 0 20px rgba(255, 215, 0, 0.25);" />
  </a>

#

  <h3>🏅️ Sovereign Tutorial & Runtime Engine for Building Low-Level LLM Applications</h3>
<div align="center">
  <p>
    <a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/badge/License-MIT-yellow.svg" alt="License: MIT" /></a>
    <a href="https://en.wikipedia.org/wiki/C_(programming_language)"><img src="https://img.shields.io/badge/Core-Pure%20C%20%2F%20Assembly-orange.svg" alt="Pure C / Assembly" /></a>
    <a href="app/page-0.md"><img src="https://img.shields.io/badge/Ecosystem-Fire--Gem-cyan.svg" alt="Fire-Gem Ecosystem" /></a>
  </p>
</div></div>

  <p>
    🏠 <strong><a href="../README.md">Main Readme</a></strong>
    🏠 <strong><a href="../page-TOC.md">Main TOC</a></strong>
    👉 <strong><a href="page-1.md">Next Page</a></strong>
  </p>
---
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

## 📂 Documentation & Table of Contents (`page-1.md` to `page-20.md`)

Our comprehensive 20-page engineering guide and architectural documentation is structured across dedicated modular pages inside the `app/` directory:

### Part I: Introduction & Environment Provisioning

* **[Page 1: Master README & Architecture Overview](page-1.md)** — Introduction to sovereign local intelligence and execution models.
* **[Page 2: Ecosystem Philosophy & Sovereignty](page-2.md)** — Why pure C and native Win32 APIs beat heavyweight abstractions.
* **[Page 3: Environment Setup & Toolchain Provisioning](page-3.md)** — Configuring MSYS2 UCRT64, GCC/Clang, Git, and GNU make.
* **[Page 4: Acquiring Model Assets & GGUF Sourcing](page-4.md)** — Downloading and managing single-file quantized weights from Hugging Face.
* **[Page 5: Workspace Directory Layout](page-5.md)** — Structuring `/models`, `/include`, and `/lib` directories.

### Part II: Core C Runtimes & Loader Adapters

* **[Page 6: Integrating MercWar Ecosystem Assets](page-6.md)** — Importing headers and static libraries from `mercwar/GGML-LLAMA-MSVC-INSTALLER`.
* **[Page 7: Core C Entry Point (`main.c` Initialization)](page-7.md)** — Writing foundational program startup and hardware initialization gates.
* **[Page 8: Win32 Directory Scanning](page-8.md)** — Discovering GGUF assets dynamically using `FindFirstFileA()`.
* **[Page 9: The Model Loader Adapter](page-9.md)** — Memory-mapping weights into virtual space via `llama_model_load_from_file()`.
* **[Page 10: Prompt Ingestion & String Tokenization](page-10.md)** — Converting raw text strings into integer token arrays with `llama_tokenize()`.

### Part III: Batching, Prefill, and Dispatch

* **[Page 11: Batch Allocation & Token Structuring](page-11.md)** — Packaging token sequences into parallel execution blocks.
* **[Page 12: Transformer Graph Prefill Decoding](page-12.md)** — Executing parallel forward passes with `llama_decode()`.
* **[Page 13: The Dispatch Gate & Token Sampling Loops](page-13.md)** — Transforming raw logits into readable text streams.
* **[Page 14: Modular Sampler Chains (`llama_sampler`)](page-14.md)** — Controlling generation randomness with top-K, top-P, and temperature filters.
* **[Page 15: The Unified Master `main.c` Implementation](page-15.md)** — The complete, production-ready source code listing.

### Part IV: Advanced Architectures & Next Steps

* **[Page 16: Hardware Offloading & Structured Grammars](page-16.md)** — Scaling via Vulkan/CUDA and enforcing JSON schemas using GBNF grammars.
* **[Page 17: KV Caching & WinSock REST Servers](page-17.md)** — Building multi-threaded TCP listeners (`ws2_32.lib`) and optimizing state persistence.

### Part V: Reference, Index, and Legal Framework

* **[Page 18: Technical Appendix & Build Cheat Sheet](page-18.md)** — Quick compiler references and linker flags.
* **[Page 19: Comprehensive Terminology Glossary & Index](page-19.md)** — Low-level tensor definitions and cross-reference matrices.
* **[Page 20: Credits, Licensing & Mercwar Legal Framework](page-20.md)** — MIT licensing, upstream `llama.cpp` attributions, and autonomous ecosystem ingestion rules.

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
