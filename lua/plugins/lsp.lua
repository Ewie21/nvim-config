-- add tsserver and setup with typescript.nvim instead of lspconfig
return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "jose-elias-alvarez/typescript.nvim",
        init = function()
            require("lazyvim.util").lsp.on_attach(function(_, buffer)
          -- stylua: ignore
          vim.keymap.set( "n", "<leader>co", "TypescriptOrganizeImports", { buffer = buffer, desc = "Organize Imports" })
                vim.keymap.set("n", "<leader>cR", "TypescriptRenameFile", { desc = "Rename File", buffer = buffer })
            end)
        end,
    },
    ---@class PluginLspOpts
    opts = {
        ---@type lspconfig.options
        servers = {
            clangd = {},
            -- tsserver will be automatically installed with mason and loaded with lspconfig
            tsserver = {},
            rust_analyzer = {
                mason = false,
                cmd = { vim.fn.expand("~/.rustup/toolchains/stable-aarch64-apple-darwin/bin/rust-analyzer") },
                settings = {
                    ["rust-analyzer"] = {
                        imports = {
                            granularity = {
                                group = "module",
                            },
                            prefix = "self",
                        },
                        cargo = {
                            buildScripts = {
                                enable = true,
                            },
                        },
                        procMacro = {
                            enable = true,
                        },
                    },
                },
            },
            svelte = {},
        },
        -- you can do any additional lsp server setup here
        -- return true if you don't want this server to be setup with lspconfig
        ---@type table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
        setup = {
            clangd = function(_, opts)
                opts.capabilities.offsetEncoding = { "utf-16" }
            end,
            -- example to setup with typescript.nvim
            tsserver = function(_, opts)
                require("typescript").setup({ server = opts })
                return true
            end,
            -- Specify * to use this function as a fallback for any server
            -- ["*"] = function(server, opts) end,
        },
    },
}
