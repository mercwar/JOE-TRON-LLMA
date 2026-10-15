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