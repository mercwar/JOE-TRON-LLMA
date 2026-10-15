# Module 16: Extending Your C Engine Architecture

Now that your standalone GGUF runtime is compiled and running locally on Windows, you can expand its architectural capabilities. By moving beyond a simple linear text generation loop, you can turn your binary into an autonomous engine node.

---

## 1. Implementing a Proper Sampler Chain (`llama_sampler`)

In our initial proof-of-concept, token sampling relied on placeholder hooks. Modern versions of `libllama` use an explicit, modular sampler chain API to control randomness, apply penalties, and prevent repetition.

Instead of raw uniform picking, construct an explicit sampler chain pipeline right after initializing your model vocabulary:

```c
// Initialize a default sampler chain configuration
struct llama_sampler_chain_params sampler_params = llama_sampler_chain_default_params();
struct llama_sampler * smpl = llama_sampler_chain_init(sampler_params);

// Add specific sampling algorithms to the chain
llama_sampler_chain_add(smpl, llama_sampler_init_top_k(40));
llama_sampler_chain_add(smpl, llama_sampler_init_top_p(0.90f, 1));
llama_sampler_chain_add(smpl, llama_sampler_init_temp(0.7f));
llama_sampler_chain_add(smpl, llama_sampler_init_dist(1234)); // Seeded random distribution

```

When execution reaches the dispatch gate inside your token loop, sampling a token becomes a clean, single-function invocation against the chain:

```c
// Sample the next token directly from the context logits using your custom chain
llama_token curr_token = llama_sampler_sample(smpl, ctx, -1);

// Always remember to free the sampler chain during your shutdown teardown sequence
llama_sampler_free(smpl);

```

---

## 2. Transitioning to Long-Running Interactive Sessions

A production-ready chatbot or assistant runtime should not exit after a single prompt response. By wrapping your evaluation and dispatch code inside a persistent `while` loop, you create an interactive terminal session:

* **KV Cache Preservation:** Keeping the execution context (`ctx`) alive across loops allows the transformer to remember previous dialogue turns without re-evaluating the entire history from scratch.
* **Dynamic Input Buffering:** Using `fgets()` instead of hardcoded strings lets you accept continuous runtime commands directly from the user keyboard input box.

---

### Where should your development branch go next?

Would you like to implement **socket-based HTTP networking** using WinSock (`ws2_32.lib`) to serve your local C model over an OpenAI-compatible endpoint, or focus on **hardware-accelerated GPU layer offloading** via Vulkan?