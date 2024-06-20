return {
	"stevearc/conform.nvim",
	dependencies = { "mason.nvim" },
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local conform = require("conform")

		conform.setup({
			formatters_by_ft = {
				javascript = { { "prettier", "prettierd" } },
				typescript = { { "prettier", "prettierd" } },
				svelte = { { "prettier", "prettierd" } },
				html = { { "prettier", "prettierd" } },
				css = { { "prettier", "prettierd" } },
				markdown = { { "prettier", "prettierd" } },
				json = { { "prettier", "prettierd" } },
				yaml = { { "prettier", "prettierd" } },
				toml = { { "prettier", "prettierd" } },
				lua = { "stylua" },
				rust = { "rustfmt" },
				c = { "clang-format" },
				cpp = { "clang-format" },
			},
			format_on_save = {
				lsp_fallback = true,
				async = false,
				timeout_ms = 500,
			},
		})

		vim.keymap.set({ "n", "v" }, "<leader>l", function()
			conform.format({
				lsp_fallback = true,
				async = false,
				timeout_ms = 500,
			})
		end, { desc = "Format file or range (in visual mode)" })
	end,
}
