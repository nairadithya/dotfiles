-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]
return require('packer').startup(function(use)
-- Packer can manage itself
use 'wbthomason/packer.nvim'
-- Telescope
use{'nvim-telescope/telescope.nvim', 
tag = '0.1.6',
requires = { {'nvim-lua/plenary.nvim'} }
}
-- Gruvbox Configuration
use { "ellisonleao/gruvbox.nvim" }
-- Catpuccin Setup
use { "catppuccin/nvim", as = "catppuccin" }
-- Tree Sitter
use { "nvim-treesitter/nvim-treesitter",
run = ':TSUpdate',
}
-- LSP Zero
use {
  'VonHeikemen/lsp-zero.nvim',
  branch = 'v3.x',
  requires = {
    {'neovim/nvim-lspconfig'},
    {'hrsh7th/nvim-cmp'},
    {'hrsh7th/cmp-nvim-lsp'},
    {'L3MON4D3/LuaSnip'},
  }
}
-- Oil.nvim
use { 'stevearc/oil.nvim'}
use 'nvim-tree/nvim-web-devicons'
-- Mason
use {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    }
-- Vimtex
use {'lervag/vimtex'}
use { 
	'nvim-lualine/lualine.nvim',
	requires = { 'nvim-tree/nvim-web-devicons', opt = true },
}
end)
