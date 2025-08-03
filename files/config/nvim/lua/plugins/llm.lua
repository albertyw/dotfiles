return {
    "huggingface/llm.nvim",
    opts = {
        backend = "ollama",
        model = "gemma3",
        url = "http://localhost:11434",
        fim = {
            enabled = true,
            prefix = "<|fim_prefix|>",
            middle = "<|fim_middle|>",
            suffix = "<|fim_suffix|>",
        }
    }
}
