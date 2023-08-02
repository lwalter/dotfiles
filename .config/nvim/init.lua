-- Automatically install Packer if it isn"t installed
local ensure_packer = function()
	local fn = vim.fn
	local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
	if fn.empty(fn.glob(install_path)) > 0 then
		fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
		vim.cmd("packadd packer.nvim")
		return true
	end
	return false
end

local packer_bootstrap = ensure_packer()

require("packer").startup(function(use)
	use({ "wbthomason/packer.nvim" })
	use({ "navarasu/onedark.nvim" })
	use({
		"nvim-telescope/telescope.nvim", -- Fuzzy find
		tag = "0.1.2",
		requires = { { "nvim-lua/plenary.nvim" } },
	})
	use({ "nvim-lualine/lualine.nvim" })
	-- https://www.nerdfonts.com/
	-- iterm2->Settings->Profiles->Text->Font
	-- Mononoki Nerd Font Mono
	use({ "nvim-tree/nvim-web-devicons" })
	use({ "nvim-tree/nvim-tree.lua" }) -- Filetree
	use({ "williamboman/mason.nvim" }) -- Installation of LSPs
	use({ "williamboman/mason-lspconfig.nvim" })
	use({ "neovim/nvim-lspconfig" }) -- LSP configuration
	use({ "hrsh7th/nvim-cmp" }) -- Autocompletion plugin
	use({ "hrsh7th/cmp-nvim-lsp" }) -- LSP source for nvim-cmp
	use({ "saadparwaiz1/cmp_luasnip" }) -- Snippets source for nvim-cmp
	use({ "L3MON4D3/LuaSnip" }) -- Snippets plugin for nvim-cmp
	use({ "Raimondi/delimitMate" })
	use({ "mhartington/formatter.nvim" }) -- Autoformatter
	-- Syntax highlighting
	use({
		"nvim-treesitter/nvim-treesitter",
		run = function()
			local ts_update = require("nvim-treesitter.install").update({ with_sync = true })
			ts_update()
		end,
	})
	-- Automatically set up your configuration after cloning packer.nvim
	-- Put this at the end after all plugins
	if packer_bootstrap then
		require("packer").sync()
	end
end)

vim.g.mapleader = ","
vim.keymap.set("i", "ii", "<Esc>")
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")
vim.keymap.set("n", "<Tab>", ":bnext<CR>")
vim.keymap.set("n", "<S-Tab>", ":bprevious<CR>")

-- Clear highlighting on enter
vim.keymap.set("n", "<CR>", ":noh<CR><CR>")

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Options
vim.opt.number = true
vim.opt.mouse = ""
vim.opt.encoding = "utf8"
vim.opt.fileencoding = "utf8"
vim.opt.syntax = "ON"
vim.opt.spelllang = "en_us"
vim.opt.termguicolors = true

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

-- Configure file tree
require("nvim-tree").setup()
vim.keymap.set("n", "<F6>", ":NvimTreeToggle<CR>")

-- Configure lualine
require("lualine").setup({
	options = {
		theme = "onedark",
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

-- Configure theming
require("onedark").setup({
	code_style = { comments = "none" },
})
require("onedark").load()

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
		"make",
		"css",
		"yaml",
		"toml",
	},
	highlight = {
		enable = true,
	},
})

-- LSP installation and set up
require("mason").setup({})
require("mason-lspconfig").setup({
	ensure_installed = { "pyright", "gopls", "bashls" },
})
local lspconfig = require("lspconfig")
lspconfig.bashls.setup({
	capabilities = capabilities,
})
lspconfig.pyright.setup({
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
lspconfig.gopls.setup({
	on_attach = function(client, bufnr)
		vim.api.nvim_create_autocmd("BufWritePre", {
			group = vim.api.nvim_create_augroup("FixGoImports", { clear = true }),
			pattern = "*.go",
			callback = function()
				-- ensure imports are sorted and grouped correctly
				vim.lsp.buf.format({ async = false, bufnr = bufnr, timeout_ms = 3000 })
				local params = vim.lsp.util.make_range_params()
				params.context = { only = { "source.organizeImports" } }
				local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params)
				for _, res in pairs(result or {}) do
					for _, r in pairs(res.result or {}) do
						if r.edit then
							vim.lsp.util.apply_workspace_edit(r.edit, "UTF-8")
						else
							vim.lsp.buf.execute_command(r.command)
						end
					end
				end
			end,
		})
	end,
	capabilities = capabilities,
	settings = {
		gopls = {
			gofumpt = true,
		},
	},
})

-- Setup Lsp keymaps
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(ev)
		-- Buffer local mappings.
		-- See `:help vim.lsp.*` for documentation on any of the below functions
		local opts = { buffer = ev.buf }
		vim.keymap.set("n", "<leader>gD", vim.lsp.buf.declaration, opts)
		vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, opts)
		vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts)
		vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
		vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
		vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, opts)
		vim.keymap.set("n", "<leader>f", function()
			vim.lsp.buf.format({ async = true, bufnr = opts.buffer, timeout_ms = 3000 })
		end, opts)
		--vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
		--vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
		--vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
		--vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, opts)
		--vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, opts)
		--vim.keymap.set("n", "<space>wl", function()
		--  print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
		--end, opts)
	end,
})

-- Autocompletion
-- Reduce the amount of time it takes for diagnostics pane to appear
vim.o.updatetime = 250
-- Open the diagnostic pane
vim.api.nvim_create_autocmd("CursorHold", {
	buffer = bufnr,
	callback = function()
		local opts = {
			focusable = false,
			close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
			border = "rounded",
			source = "always",
			prefix = " ",
			scope = "cursor",
		}
		vim.diagnostic.open_float(nil, opts)
	end,
})

-- Setup auto complete
-- Add additional capabilities supported by nvim-cmp
local capabilities = require("cmp_nvim_lsp").default_capabilities()
local cmp = require("cmp")
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
		lua = {
			require("formatter.filetypes.lua").stylua,
		},
		terraform = {
			require("formatter.filetypes.terraform").terraformfmt,
		},
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
		yaml = {
			require("formatter.filetypes.yaml").prettier,
		},
		markdown = {
			require("formatter.filetypes.markdown").prettier,
		},
	},
})

local format_grp = vim.api.nvim_create_augroup("FormatAutogroup", {})
vim.api.nvim_create_autocmd("BufWritePost", {
	callback = function()
		vim.cmd.FormatWrite()
	end,
	group = format_grp,
	pattern = "*",
})
