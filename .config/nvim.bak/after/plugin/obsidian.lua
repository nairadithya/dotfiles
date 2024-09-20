require("obsidian").setup({
	workspaces = {
		{
			name = "The Garden",
			path = "~/Sync/The Garden",
			overrides = { 
				disable_frontmatter = true,
			},
		},
	},
	new_notes_location = "000 Inbox",
	completion = {
		-- Set to false to disable completion.
		nvim_cmp = true,
		-- Trigger completion at 2 chars.
		min_chars = 2,
	},
	templates = {
		folder = "Templates",
		date_format = "%Y-%m-%d",
		time_format = "%H:%M",
		substitutions = {},
	},
	mappings = {
		-- Overrides the 'gf' mapping to work on markdown/wiki links within your vault.
		["gf"] = {
			action = function()
				return require("obsidian").util.gf_passthrough()
			end,
			opts = { noremap = false, expr = true, buffer = true },
		},
		-- Toggle check-boxes.
		["<leader>ch"] = {
			action = function()
				return require("obsidian").util.toggle_checkbox()
			end,
			opts = { buffer = true },
		},
		-- Smart action depending on context, either follow link or toggle checkbox.
		["<cr>"] = {
			action = function()
				return require("obsidian").util.smart_action()
			end,
			opts = { buffer = true, expr = true },
		}
	},
	follow_url_func = function(url)
		vim.fn.jobstart({"xdg-open", url})  -- linux
	end,
	-- Keybindings
	vim.keymap.set('n', '<leader>os',"<CMD>:ObsidianSearch<CR>", {}),
	vim.keymap.set('n', '<leader>on',"<CMD>:ObsidianNew<CR>", {}),
	vim.keymap.set('n', '<leader>ot',"<CMD>:ObsidianTemplate<CR>", {})
})
