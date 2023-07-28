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
	use({ "junegunn/fzf", run = ":call fzf#install()" })
	use({ "junegunn/fzf.vim" })
	use({ "nvim-lualine/lualine.nvim" })
	-- https://www.nerdfonts.com/
	-- iterm2->Settings->Profiles->Text->Font
	-- Mononoki Nerd Font Mono
	use({ "nvim-tree/nvim-web-devicons" })
	use({ "nvim-tree/nvim-tree.lua" })
	use({ "neovim/nvim-lspconfig" })
	use({ "hrsh7th/nvim-cmp" }) -- Autocompletion plugin
	use({ "hrsh7th/cmp-nvim-lsp" }) -- LSP source for nvim-cmp
	use({ "saadparwaiz1/cmp_luasnip" }) -- Snippets source for nvim-cmp
	use({ "L3MON4D3/LuaSnip" }) -- Snippets plugin for nvim-cmp
	use({ "jose-elias-alvarez/null-ls.nvim" }) -- Snippets plugin for formatting?
	use({ "nvim-lua/plenary.nvim" }) -- Required for null-ls
	use({ "Raimondi/delimitMate" })
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

function map(mode, shortcut, command)
	vim.api.nvim_set_keymap(mode, shortcut, command, { noremap = true, silent = true })
end

function nmap(shortcut, command)
	map("n", shortcut, command)
end

function imap(shortcut, command)
	map("i", shortcut, command)
end

vim.g.mapleader = ","
imap("ii", "<Esc>")
nmap("<C-h>", "<C-w>h")
nmap("<C-j>", "<C-w>j")
nmap("<C-k>", "<C-w>k")
nmap("<C-l>", "<C-w>l")
nmap("<Tab>", ":bnext<CR>")
nmap("<S-Tab>", ":bprevious<CR>")
nmap("<C-p>", ":GFiles<CR>")
nmap("<F6>", ":NvimTreeToggle<CR>")
nmap("<CR>", ":noh<CR><CR>") -- Clear highlighting on enter

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

-- [[ Whitespace ]]
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.tabstop = 4

require("nvim-tree").setup()
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
require("onedark").setup({
	code_style = { comments = "none" },
})
require("onedark").load()

-- LSP, autocompletion
local lspconfig = require("lspconfig")
-- Add additional capabilities supported by nvim-cmp
local capabilities = require("cmp_nvim_lsp").default_capabilities()

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
--lspconfig.terraformls.setup({})
--lspconfig.tflint.setup({})
-- many of these are installed via npm
-- nvm use 18.15.0
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
	capabilities = capabilities,
	settings = {},
})
-- https://github.com/hashicorp/terraform-ls/releases
--lspconfig.terraformls.setup({
--	capabilities = capabilities,
--	settings = {},
--})
---- curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash
--lspconfig.tflint.setup({
--	capabilities = capabilities,
--	settings = {},
--})

-- Setup Lsp keymaps
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(ev)
		-- Buffer local mappings.
		-- See `:help vim.lsp.*` for documentation on any of the below functions
		local opts = { buffer = ev.buf }
		vim.keymap.set("n", "<leader>gD", vim.lsp.buf.declaration, opts)
		vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, opts)
		--vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
		--vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
		--vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
		--vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, opts)
		--vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, opts)
		--vim.keymap.set("n", "<space>wl", function()
		--  print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
		--end, opts)
		vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts)
		vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
		vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
		vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, opts)
		vim.keymap.set("n", "<leader>f", function()
			vim.lsp.buf.format({ async = true, bufnr = opts.buffer, timeout_ms = 3000 })
		end, opts)
	end,
})

-- Setup auto complete
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

-- Remove null-ls eventually
-- Runs formatters on save
local null_ls = require("null-ls")
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
null_ls.setup({
	debug = true,
	on_attach = function(client, bufnr)
		if client.supports_method("textDocument/formatting") then
			vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = augroup,
				buffer = bufnr,
				callback = function()
					vim.lsp.buf.format({ bufnr = bufnr, timeout_ms = 3000 })
				end,
			})
		end
	end,
	sources = {
		debug = true,
		null_ls.builtins.formatting.prettier.with({
			filetypes = { "json", "yaml", "markdown" },
		}),
		null_ls.builtins.formatting.goimports,
		null_ls.builtins.formatting.gofumpt,
		null_ls.builtins.formatting.isort.with({
			command = "isort",
			extra_args = { "-p", "black" },
		}),
		null_ls.builtins.formatting.black.with({
			command = "black",
			extra_args = { "--line-length", "80" },
		}),
		null_ls.builtins.diagnostics.flake8,
		null_ls.builtins.formatting.stylua,
		null_ls.builtins.formatting.terraform_fmt,
	},
})
------ end null-ls

-- Syntax highlighting
local treesitter = require("nvim-treesitter.configs")
treesitter.setup({
	highlight = {
		enable = true,
	},
})
