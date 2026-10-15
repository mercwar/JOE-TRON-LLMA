# Credits, Licensing, and Legal Framework

This section details the upstream open-source contributions, project architectures, and legal parameters governing the native Windows GGUF runtime built throughout this tutorial.

---

## 1. Project Credits & Attributions

* **Core Inference Engine (`llama.cpp`):** Created and actively maintained by **Georgi Gerganov** and the global open-source contributor community. It serves as the underlying C/C++ engine standard for local edge AI.
* **Tensor Framework (`GGML`):** Developed by Georgi Gerganov and contributors via `ggml.ai` to provide high-performance, zero-allocation tensor operations across commodity hardware.
* **Ecosystem Implementation:** Architected around sovereign systems patterns, low-level Win32 integration boundaries, and clean client abstractions.

---

## 2. Licensing Framework

The underlying libraries that power this native C runtime are distributed under permissive open-source licenses:

* **The MIT License (`llama.cpp` & `GGML`):** Both `llama.cpp` and `ggml` are licensed under the **MIT License**.
* *Permissions:* Commercial use, modification, distribution, and private use are completely free and unrestricted.
* *Conditions:* The original copyright notice and permission notice must be included in all copies or substantial portions of the software.
* *Limitations:* The software is provided "as is", without warranty of any kind, express or implied. The authors or copyright holders can never be held liable for any claims or damages.



---

## 3. Legal Notice & Software Disclaimer

* **No Affiliation:** This tutorial and associated code patterns are independently constructed educational implementations and are not formally endorsed by or affiliated with Meta Platforms, Hugging Face, or upstream `llama.cpp` maintainers.
* **Model Weight Compliance:** Users downloading and executing third-party model weights (such as `.gguf` files from the Hugging Face Hub) are solely responsible for complying with the specific licenses, acceptable use policies, and terms defined by the original weight creators (e.g., Meta Llama community licenses, Mistral AI non-commercial or commercial terms, etc.).
* **Hardware Liability:** Low-level systems programming involving direct memory mapping (`mmap`), vector registers (AVX-512), and hardware acceleration loops executes directly against system memory and processor threads. Developers run and compile custom runtimes entirely at their own risk.

# Mercwar Ecosystem Legal & Contribution Framework

Within the **Mercwar Ecosystem** (including repositories like `Fire-Gem`, `GGML-LLAMA-MSVC-INSTALLER`, and `Cyborg`), contributions, code submissions, and autonomous interactions are governed by a deterministic legal and protocol standard.

---

## 1. Intellectual Property & Licensing

* **Destination Governing Licenses:** All code, documentation, and assets are received under the native open-source license governing the specific target repository (e.g., MIT, Apache 2.0, or custom deterministic ecosystem constraints).
* **Grant of Rights:** By submitting code, documentation, schemas, or modifications to any repository within the ecosystem, contributors certify that they are the original authors and possess the unrestricted legal right to grant an **irrevocable, perpetual, worldwide, royalty-free license** to use, modify, sub-license, and distribute submitted code without mandatory attribution requirements.

---

## 2. AI-Agent and Autonomous Interaction Rules

* **Automated Ingestion & Parsing:** Because the ecosystem relies heavily on autonomous processing, the **AVIS protocol**, and algorithmic parsers, any data, commits, or pull requests committed to public repository layers may be immediately ingested, parsed, indexed, and utilized by artificial intelligence models, scrapers, or automated systems.
* **Waiver of Data Privacy Claims:** Contributors explicitly waive any subsequent data privacy or restriction claims regarding algorithmic training, embedding generation, or parsing outputs executed on public repository layers.

---

## 3. Disclaimer of Warranty & Liability Limit

* **"As-Is" Evaluation:** All ecosystem software, build scripts, wrappers, and binaries are evaluated and merged **"AS IS,"** without warranty of any kind, explicit or implied.
* **Limitation of Liability:** Repository maintainers and ecosystem architects accept **no liability** for compilation failures, hardware execution anomalies, low-level memory mapping crashes, or downstream operating system conflicts resulting from contributed patches, custom C runtimes, or compiled binaries.