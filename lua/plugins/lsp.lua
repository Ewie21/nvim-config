-- add tsserver and setup with typescript.nvim instead of lspconfig
return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "jose-elias-alvarez/typescript.nvim",
        init = function()
            require("lazyvim.util").lsp.on_attach(function(_, buffer)
                -- stylua: ignore
                vim.keymap.set("n", "<leader>co", "TypescriptOrganizeImports",
                    { buffer = buffer, desc = "Organize Imports" })
                vim.keymap.set("n", "<leader>cR", "TypescriptRenameFile", { desc = "Rename File", buffer = buffer })
            end)
        end,
    },
    ---@class PluginLspOpts
    opts = {
        ---@type lspconfig.options
        servers = {
            clangd = {
                mason = true,
                cmd
            },
            -- tsserver will be automatically installed with mason and loaded with lspconfig
            tsserver = {
                keys = {
                    {
                        "<leader>co",
                        function()
                            vim.lsp.buf.code_action({
                                apply = true,
                                context = {
                                    only = { "source.organizeImports.ts" },
                                    diagnostics = {},
                                },
                            })
                        end,
                        desc = "Organize Imports",
                    },
                    {
                        "<leader>cR",
                        function()
                            vim.lsp.buf.code_action({
                                apply = true,
                                context = {
                                    only = { "source.removeUnused.ts" },
                                    diagnostics = {},
                                },
                            })
                        end,
                        desc = "Remove Unused Imports",
                    },
                },
                ---@diagnostic disable-next-line: missing-fields
                settings = {
                    completions = {
                        completeFunctionCalls = true,
                    },
                },
            },
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
            tailwindcss = {
                -- exclude a filetype from the default_config
                filetypes_exclude = { "markdown" },
                -- add additional filetypes to the default_config
                filetypes_include = {},
                -- to fully override the default_config, change the below
                -- filetypes = {}
            },
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
            tailwindcss = function(_, opts)
                local tw = require("lspconfig.server_configurations.tailwindcss")
                opts.filetypes = opts.filetypes or {}

                -- Add default filetypes
                vim.list_extend(opts.filetypes, tw.default_config.filetypes)

                -- Remove excluded filetypes
                --- @param ft string
                opts.filetypes = vim.tbl_filter(function(ft)
                    return not vim.tbl_contains(opts.filetypes_exclude or {}, ft)
                end, opts.filetypes)

                -- Add additional filetypes
                vim.list_extend(opts.filetypes, opts.filetypes_include or {})
            end,
        },
    },
}
