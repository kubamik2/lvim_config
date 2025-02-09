-- plugins
lvim.plugins = {
    {
        "mbbill/undotree",
        lazy = false,
    },
    {
        "sainnhe/edge",
        lazy = false,
    },
    {
        'mrcjkb/rustaceanvim',
        version = '^5', -- Recommended
        lazy = false, -- This plugin is already lazy
        ft = { "rust" },
        opts = {
            server = {
                default_settings = {
                    ["rust_analyzer"] = {
                        cargo = {
                            allFeatures = true,
                            loadOutDirsFromCheck = true,
                            buildScripts = {
                                enable = true
                            },
                            diagnostics = {
                                warningsAsHint = {"dead_code", "unused_variables"}
                            },
                            checkOnSave = true,
                            procMacro = {
                                enable = true,
                                ignored = {
                                    ["async-trait"] = {"async-trait"},
                                    ["napi-derive"] = {"napi"},
                                    ["async-recursion"] = {"async_recursion"},
                                },
                            },
                        },
                    },
                },
            },
        },
        config = function(_, opts)
            -- vim.g.rustaceanvim = vim.tbl_deep_extend("keep", vim.g.rustaceanvim or {}, opts or {})
            vim.g.rustaceanvim = {
                server = {
                    on_attach = require("lvim.lsp").common_on_attach
                }
            }
            if vim.fn.executable("rust-analyzer") == 0 then
                LazyVim.error(
                    "**rust-analyzer** not found in PATH, please install it.",
                    { title = "rustaceanvim" }
                )
            end
        end,
    },
}

-- keybinds
lvim.keys.normal_mode["<leader>u"] = vim.cmd.UndotreeToggle -- undotree toggle
lvim.keys.normal_mode["<C-s>"] = ":w<CR>" -- save file
lvim.keys.normal_mode["<F2>"] = vim.lsp.buf.rename -- variable rename

-- options
vim.opt.scrolloff = 8 -- always surround cursor with at least 8 vertical lines
vim.opt.relativenumber = true
vim.opt.wrap = false
lvim.lsp.automatic_servers_installation = false
vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "rust_analyzer" }) -- skip rust_analyzer config to not interfere with rustaceanvim
vim.opt.tabstop = 4 -- tab size
vim.opt.shiftwidth = 4

-- change some diagnostics
vim.diagnostic.config({
    underline = {
        severity = { max = vim.diagnostic.severity.HINT }
    },
    virtual_tex = {
        severity = { min = vim.diagnostic.severity.WARN }
    }
})

-- enable inlay hints on lsp attach
vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspConfig", {}),
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client.server_capabilities.inlayHintProvider then
            vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
        end
    end
})

-- colorscheme
lvim.colorscheme = "edge"
vim.g.edge_style = "aura"

-- allow duplicate autocomplete suggestions
lvim.builtin.cmp.formatting.duplicates["nvim_lsp"] = 1
