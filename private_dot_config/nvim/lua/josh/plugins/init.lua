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

local _, lazy = pcall(require, "lazy")

lazy.setup({
	{
		-- Color scheme
		"jacoborus/tender.vim",
		lazy = false,
		priority = 1000,
		config = function()
			vim.cmd([[colorscheme tender]])
		end,
	},
	{
		-- LSP support with lsp-zero
		"VonHeikemen/lsp-zero.nvim",
		branch = "v2.x",
		dependencies = {
			{ "neovim/nvim-lspconfig" }, -- Required
			{ -- Optional
				"williamboman/mason.nvim",
				build = function()
					pcall(vim.cmd, "MasonUpdate")
				end,
			},
			{ "williamboman/mason-lspconfig.nvim" }, -- Optional

			-- Autocompletion
			{ "hrsh7th/nvim-cmp" }, -- Required
			{ "hrsh7th/cmp-nvim-lsp" }, -- Required
			{ "hrsh7th/cmp-buffer" },
			{ "hrsh7th/cmp-path" },
			{ "L3MON4D3/LuaSnip" }, -- Required
			{ "rafamadriz/friendly-snippets" },
		},
	},
	{
		"jose-elias-alvarez/null-ls.nvim",
		config = function()
			local _, null_ls = pcall(require, "null-ls")

			local formatting = null_ls.builtins.formatting
			local diagnostics = null_ls.builtins.diagnostics

			local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

			null_ls.setup({
				sources = {
					formatting.prettier,
					formatting.stylua,
					diagnostics.eslint_d.with({
						condition = function(utils)
							return utils.root_has_file(".eslintrc.js")
						end,
					}),
				},
				on_attach = function(current_client, bufnr)
					if current_client.supports_method("textDocument/formatting") then
						vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
						vim.api.nvim_create_autocmd("BufWritePre", {
							group = augroup,
							buffer = bufnr,
							callback = function()
								vim.lsp.buf.format({
									filter = function(client)
										return client.name == "null-ls"
									end,
									bufnr = bufnr,
								})
							end,
						})
					end
				end,
			})
		end,
	},
	{ "nvim-telescope/telescope.nvim", branch = "0.1.x", dependencies = { { "nvim-lua/plenary.nvim" } } },
	"jayp0521/mason-null-ls.nvim",
	"tpope/vim-sleuth",
	{
		"Equilibris/nx.nvim",
		depedencies = { { "nvim-telescope/telescope.nvim" } },
		config = function()
			require("nx").setup({
				nx_cmd = "pnpm exec nx",
			})
		end,
	},
})

-- Start LSP server
local lsp = require("lsp-zero").preset({})

lsp.on_attach(function(client, bufnr)
	lsp.default_keymaps({ buffer = bufnr })
end)

-- (Optional) Configure lua language server for neovim
require("lspconfig").lua_ls.setup(lsp.nvim_lua_ls())

lsp.setup()
