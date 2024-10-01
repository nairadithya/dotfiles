local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
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
	{ "catppuccin/nvim", name = "catppuccin", priority = 1000 },
	{ "folke/which-key.nvim", event = "VeryLazy",opts = {} },
	{ "stevearc/oil.nvim", 	opts = {}, dependencies = { { "echasnovski/mini.icons", opts = {} } } },
	{ "lewis6991/gitsigns.nvim", opts = {},},
	{ "nvim-lualine/lualine.nvim"},
	{ "nvim-telescope/telescope.nvim", tag = "0.1.8", dependencies = { "nvim-lua/plenary.nvim" } },
{ "hrsh7th/nvim-cmp", dependencies = { "hrsh7th/cmp-nvim-lsp", "hrsh7th/cmp-buffer", "hrsh7th/cmp-path", "hrsh7th/cmp-cmdline", "saadparwaiz1/cmp_luasnip", "L3MON4D3/LuaSnip" }, },
	{"nevim/nvim-lspconfig", dependencies = { { "williamboman/mason.nvim", config = true },  "williamboman/mason-lspconfig.nvim", "WhoIsSethDaniel/mason-tool-installer.nvim",	{ "j-hui/fidget.nvim", opts = {} },"hrsh7th/cmp-nvim-lsp", }, }
})
