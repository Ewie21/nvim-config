return {
  "nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	event = { "BufReadPre", "BufNewFile" },
    lazy = true,
  config = function()
    local treesitter = require("nvim-treesitter.configs")

    treesitter.setup({
	highlight = {
        enable = true,
      },
      -- enable indentation
      indent = { enable = true },
      ensure_installed = {
        "json",
        "javascript",
        "typescript",
        "tsx",
        "yaml",
        "html",
        "css",
        "markdown",
        "markdown_inline",
        "svelte",
        "bash",
        "lua",
        "vim",
	    "rust",
        "gitignore",
      },
    })

  end,
}
