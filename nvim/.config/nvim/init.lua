vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.mapleader = ","

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    "navarasu/onedark.nvim",
    "folke/tokyonight.nvim",
    "folke/lazydev.nvim",
    "nvim-lualine/lualine.nvim",
    "nvim-tree/nvim-web-devicons",
    {
        'nvim-telescope/telescope.nvim',
        tag = 'v0.2.1',
        dependencies = { 'nvim-lua/plenary.nvim' }
    },
    {
        'nvim-treesitter/nvim-treesitter',
        lazy = false,
        dependencies = {
            { 'nvim-treesitter/nvim-treesitter-textobjects', branch = 'main' },
        },
        build = ':TSUpdate',
    },
    "nvim-tree/nvim-tree.lua",                          -- Filetree
    "williamboman/mason.nvim",                          -- Installation of LSPs
    "williamboman/mason-lspconfig.nvim",
    "neovim/nvim-lspconfig",                            -- LSP configuration
    "hrsh7th/nvim-cmp",                                 -- Autocompletion plugin
    "hrsh7th/cmp-nvim-lsp",                             -- LSP source for nvim-cmp
    "saadparwaiz1/cmp_luasnip",                         -- Snippets source for nvim-cmp
    "L3MON4D3/LuaSnip",                                 -- Snippets plugin for nvim-cmp
    { "folke/trouble.nvim",    opts = {},            cmd = "Trouble" },
    { "windwp/nvim-autopairs", event = "InsertEnter" }, -- Pair parens
    "mhartington/formatter.nvim",                       -- Autoformatter
    "github/copilot.vim",
    "sphamba/smear-cursor.nvim",
})

vim.keymap.set("i", "ii", "<Esc>")
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")
vim.keymap.set("n", "<Tab>", ":bnext<CR>")
vim.keymap.set("n", "<S-Tab>", ":bprevious<CR>")

-- Copilot
vim.api.nvim_set_keymap("i", "<C-J>", 'copilot#Accept(" < CR > ")', { silent = true, expr = true })
vim.g.copilot_no_tab_map = true

-- Clear highlighting on enter
vim.keymap.set("n", "<CR>", ":noh<CR><CR>")

-- Options
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = ""
vim.opt.encoding = "utf8"
vim.opt.fileencoding = "utf8"
vim.opt.syntax = "ON"
vim.opt.spelllang = "en_us"
vim.opt.termguicolors = true
vim.opt.laststatus = 3 -- Use global status line
vim.o.updatetime = 250 -- Reduce the amount of time it takes for diagnostics pane to appear

-- Whitespace
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.tabstop = 4

-- Setup keymaps for fuzzy find
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<C-p>", builtin.git_files, {})
vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
vim.keymap.set("n", "<leader>fw", builtin.grep_string, {})
vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})
vim.keymap.set("n", "<leader>fd", builtin.diagnostics, {})

-- Configure file tree
require("nvim-tree").setup()
vim.keymap.set("n", "<F6>", ":NvimTreeToggle<CR>")


-- Configure theming
--require("onedark").setup({
--	code_style = { comments = "none" },
--})
--require("onedark").load()
--local disable_all = {
--    italic = false,
--    bold = false,
--    standout = false,
--    underline = false,
--    undercurl = false,
--    underdouble = false,
--    underdotted = false,
--    underdashed = false,
--    strikethrough = false,
--}
--require("tokyonight").setup({
--    style = "dark",
--    styles = {
--        keywords = disable_all,
--        variables = disable_all,
--        comments = disable_all,
--    },
--})

vim.cmd [[colorscheme tokyonight-moon]]
require("nvim-web-devicons").setup({ default = true })

require("smear_cursor").setup({
    smear_between_buffers = true,
    smear_between_neighbor_lines = true,
    scroll_buffer_space = true,
    smear_insert_mode = true,
})

-- Configure lualine
require("lualine").setup({
    options = {
        theme = "tokyonight",
    },
    sections = {
        lualine_a = { "mode" },
        lualine_b = { "diagnostics" },
        lualine_c = { { "filename", path = 1 } },
        lualine_x = { "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
    },
})

-- Syntax highlighting
local treesitter = require("nvim-treesitter.configs")
treesitter.setup({
    ensure_installed = {
        "lua",
        "vim",
        "python",
        "go",
        "css",
        "dockerfile",
        "bash",
        "typescript",
        "elixir",
        "json",
        "rust",
        "markdown",
        "terraform",
        "hcl",
        "make",
        "css",
        --"yaml",
        "toml",
        --"ocaml",
    },
    sync_install = false,
    auto_install = false,
    ignore_install = {},
    modules = {},
    highlight = {
        enable = true,
    },
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = "<c-space>",
            node_incremental = "<c-l>",
            scope_incremental = false,
            node_decremental = "<c-h>",
        },
    },
})

require("nvim-treesitter-textobjects").setup({
    select = {
        lookahead = true,
    },
    move = {
        set_jumps = true,
    },
})

local to_select = require("nvim-treesitter-textobjects.select")
vim.keymap.set({ "x", "o" }, "aa", function() to_select.select_textobject("@parameter.outer", "textobjects") end)
vim.keymap.set({ "x", "o" }, "ia", function() to_select.select_textobject("@parameter.inner", "textobjects") end)
vim.keymap.set({ "x", "o" }, "af", function() to_select.select_textobject("@function.outer", "textobjects") end)
vim.keymap.set({ "x", "o" }, "if", function() to_select.select_textobject("@function.inner", "textobjects") end)
vim.keymap.set({ "x", "o" }, "ac", function() to_select.select_textobject("@class.outer", "textobjects") end)
vim.keymap.set({ "x", "o" }, "ic", function() to_select.select_textobject("@class.inner", "textobjects") end)

local to_move = require("nvim-treesitter-textobjects.move")
vim.keymap.set({ "n", "x", "o" }, "]m", function() to_move.goto_next_start("@function.outer", "textobjects") end)
vim.keymap.set({ "n", "x", "o" }, "]]", function() to_move.goto_next_start("@class.outer", "textobjects") end)
vim.keymap.set({ "n", "x", "o" }, "]M", function() to_move.goto_next_end("@function.outer", "textobjects") end)
vim.keymap.set({ "n", "x", "o" }, "][", function() to_move.goto_next_end("@class.outer", "textobjects") end)
vim.keymap.set({ "n", "x", "o" }, "[m", function() to_move.goto_previous_start("@function.outer", "textobjects") end)
vim.keymap.set({ "n", "x", "o" }, "[[", function() to_move.goto_previous_start("@class.outer", "textobjects") end)
vim.keymap.set({ "n", "x", "o" }, "[M", function() to_move.goto_previous_end("@function.outer", "textobjects") end)
vim.keymap.set({ "n", "x", "o" }, "[]", function() to_move.goto_previous_end("@class.outer", "textobjects") end)

local to_swap = require("nvim-treesitter-textobjects.swap")
vim.keymap.set("n", "<leader>a", function() to_swap.swap_next("@parameter.inner") end)
vim.keymap.set("n", "<leader>A", function() to_swap.swap_previous("@parameter.inner") end)

-- Create on_attach function for auto formatting when attached to an LSP
local format_grp = vim.api.nvim_create_augroup("FormatAutogroup", { clear = true })
local on_attach = function(_, bufnr)
    -- Always attempt to format on save from LSP
    vim.api.nvim_create_autocmd("BufWritePre", {
        callback = function()
            local filetype = vim.filetype.match({ buf = bufnr })
            if filetype == "go" then
                local params = vim.lsp.util.make_range_params(0, "utf-8") --[[@as any]]
                params.context = { only = { "source.organizeImports" } }
                local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params)
                for cid, res in pairs(result or {}) do
                    for _, r in pairs(res.result or {}) do
                        if r.edit then
                            local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
                            vim.lsp.util.apply_workspace_edit(r.edit, enc)
                        end
                    end
                end
            end
            vim.lsp.buf.format({ async = false, bufnr = bufnr, timeout_ms = 3000 })
        end,
        group = format_grp,
        buffer = bufnr,
    })
end

-- LSP installation and set upper
require("lazydev").setup({
    ft = "lua"
})
require("mason").setup()
require("mason-lspconfig").setup({
    ensure_installed = {
        "pyright",
        "gopls",
        "bashls",
        --"ocamllsp",
        "terraformls",
        "lua_ls",
    },
})

require("nvim-autopairs").setup({
    disable_filetype = { "TelescopePrompt", "vim" },
    fast_wrap = {
        map = "<C-e>",
    },
})

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
vim.lsp.config("lua_ls", {
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
        Lua = {
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
        },
    },
})
vim.lsp.enable("lua_ls")

vim.lsp.config("terraformls", {
    capabilities = capabilities,
})
vim.lsp.enable("terraformls")

vim.lsp.config("bashls", {
    on_attach = on_attach,
    capabilities = capabilities,
})
vim.lsp.enable("bashls")

--vim.lsp.config("ocamllsp", {
--    capabilities = capabilities,
--})
--vim.lsp.enable("ocamllsp")

vim.lsp.config("pyright", {
    capabilities = capabilities,
    settings = {
        pyright = {
            autoImportCompletion = true,
        },
        python = {
            -- Use the SaaS container for python deps
            venvPath = "~/_dev/docker-thirdparty/built-dockerfiles/oz-python/.venv",
            pythonPath = "~/_dev/docker-thirdparty/built-dockerfiles/oz-python/.venv/bin/python",
            diagnosticMode = "openFilesOnly",
        },
    },
})
vim.lsp.enable("pyright")

vim.lsp.config("gopls", {
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
        gopls = {
            gofumpt = true,
        },
    },
})
vim.lsp.enable("gopls")


-- Setup Lsp keymaps
-- Only set key maps after attaching to an LSP server
vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
    callback = function(ev)
        -- Buffer local mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local opts = { buffer = ev.buf }
        vim.keymap.set("n", "<leader>gD", vim.lsp.buf.declaration, opts)
        vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts)
        vim.keymap.set("n", "<leader>d", function() vim.diagnostic.jump({ count = 1, float = true }) end, opts)
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
        vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, opts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "<leader>f", function()
            vim.lsp.buf.format({ async = true, bufnr = opts.buffer, timeout_ms = 3000 })
        end, opts)
        vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, opts)
        --vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
        --vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
        --vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, opts)
        --vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, opts)
        --vim.keymap.set("n", "<space>wl", function()
        --  print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        --end, opts)
    end,
})

-- Setup diagnostics
vim.diagnostic.config({
    underline = true,
    virtual_text = false,
})
vim.keymap.set("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>")
vim.keymap.set("n", "<leader>xw", "<cmd>Trouble diagnostics toggle<cr>")
vim.keymap.set("n", "<leader>xd", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>")
vim.keymap.set("n", "<leader>xq", "<cmd>Trouble qflist toggle<cr>")
vim.keymap.set("n", "<leader>xl", "<cmd>Trouble loclist toggle<cr>")
vim.keymap.set("n", "gR", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>")

-- Autocompletion
-- Setup auto complete
local cmp = require("cmp")
local cmp_autopairs = require('nvim-autopairs.completion.cmp')
cmp.event:on(
    'confirm_done',
    cmp_autopairs.on_confirm_done()
)
local luasnip = require("luasnip")
cmp.setup({
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ["<C-d>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<CR>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
        }),
        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { "i", "s" }),
    }),
    sources = {
        { name = "nvim_lsp" },
        { name = "luasnip" },
    },
})

-- Format on save
local util = require("formatter.util")
-- Provides the Format, FormatWrite, FormatLock, and FormatWriteLock commands
require("formatter").setup({
    -- Enable or disable logging
    logging = true,
    -- Set the log level
    log_level = vim.log.levels.WARN,
    -- All formatter configurations are opt-in
    filetype = {
        python = {
            function()
                return {
                    exe = "isort",
                    args = {
                        "-q",
                        "--profile black",
                        "-",
                    },
                    stdin = true,
                }
            end,
            function()
                return {
                    exe = "black",
                    args = {
                        "-q",
                        "--line-length 80",
                        "--stdin-filename",
                        util.escape_path(util.get_current_buffer_file_path()),
                        "--",
                        "-",
                    },
                    stdin = true,
                }
            end,
        },
        json = {
            require("formatter.filetypes.json").prettier,
        },
        --yaml = {
        --	require("formatter.filetypes.yaml").prettier,
        --},
        markdown = {
            require("formatter.filetypes.markdown").prettier,
        },
    },
})

vim.api.nvim_create_autocmd("BufWritePost", {
    callback = function()
        vim.cmd.FormatWrite()
    end,
    group = format_grp,
    pattern = "*",
})
