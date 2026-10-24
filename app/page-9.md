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
    <a class="menu_txt" href="page-8.md" style="text-decoration: none;">👈 Previous Page</a>
    <a class="menu_txt" href="page-10.md" style="text-decoration: none;">👉 Next Page</a>
  </div>
  <a target="_self" title="CLICK HERE to ENTER NEXUS FREE!" href="https://cron.iblogger.com/NEXUS">
    <img src="../images/Joe-Tron-LLMA-2.png" alt="Mercwar Nexus Graphic" style="width:100%; max-width:1200px; height:auto; border-radius:8px; border: 1px solid #FFD700; box-shadow: 0 0 20px rgba(255, 215, 0, 0.25);" />
  </a>
</div>

---

## Module 7: Setting Up Your Workspace and Writing Code in Notepad++

With your dependencies compiled and your model downloaded, it is time to establish your project layout and write your entry-point code using a lightweight, lightning-fast text editor like **Notepad++**.

---

### Step 1: Create the Project Directory Structure

Open your MSYS2 UCRT64 terminal or Windows command line and create a clean workspace directory for your GGUF runtime project:

```bash
mkdir my-gguf-studio
cd my-gguf-studio
mkdir models include lib

```

### Step 2: Open and Configure Notepad++

1. Launch **Notepad++** from your Windows start menu.
2. Go to **Language > C** in the top menu to enable syntax highlighting for pure C code.
3. Ensure your file encoding is set correctly by checking **Encoding > UTF-8 (without BOM)**, which prevents compilation errors caused by hidden character encoding mismatches.

### Step 3: Write and Save `main.c`

Paste your core initialization code into a fresh Notepad++ tab:

```c
#include <stdio.h>
#include <stdlib.h>
#include "llama.h"

int main() {
    printf("Initializing GGUF Runtime...\n");
    llama_backend_init();
    
    struct llama_model_params model_params = llama_model_default_params();
    struct llama_model *model = llama_model_load_from_file("models/active_model.gguf", model_params);
    
    if (!model) {
        printf("Failed to load model.\n");
        return 1;
    }
    
    printf("Model loaded successfully!\n");
    llama_model_free(model);
    llama_backend_free();
    return 0;
}

```

Go to **File > Save As**, navigate to your `my-gguf-studio` folder, name the file `main.c`, and ensure the save type is set to **C source file (*.c)**.

### Step 4: Compiling from the Shell

Switch back to your MSYS2 UCRT64 terminal window, navigate to your project folder, and compile your code by linking it directly against your generated static library headers and binaries:

```bash
gcc main.c -o runtime.exe -I./include -L./lib -llama -lggml

```

---

For a visual demonstration of configuring a lightweight compilation workflow, you can watch this [guide on compiling and running C programs in Notepad++ with MinGW](https://www.youtube.com/watch?v=K63CNzEkMnA). This video offers a practical look at setting up text editor build pipelines for local C development.

Would you like to write a custom build script or Makefile next so you can automate this compilation step instead of typing out long GCC arguments manually?
<!-- Nexus Graphic -->

  
<div align="center">

  <!-- Navigation Grid / Action Row -->
  <div style="display: flex; gap: 10px; justify-content: center; flex-wrap: wrap; margin-bottom: 30px;">
    <a class="menu_txt" href="../README.md" style="text-decoration: none;">📡 Main Readme</a>
    <a class="menu_txt" href="../page-TOC.md" style="text-decoration: none;">📦 Main TOC</a>
    <a class="menu_txt" href="page-8.md" style="text-decoration: none;">👈 Previous Page</a>
    <a class="menu_txt" href="page-10.md" style="text-decoration: none;">👉 Next Page</a>
  </div>
  <a target="_self" title="CLICK HERE to ENTER NEXUS FREE!" href="https://cron.iblogger.com/NEXUS">
    <img src="../images/Joe-Tron-LLMA-2.png" alt="Mercwar Nexus Graphic" style="width:100%; max-width:1200px; height:auto; border-radius:8px; border: 1px solid #FFD700; box-shadow: 0 0 20px rgba(255, 215, 0, 0.25);" />
  </a>
</div>
