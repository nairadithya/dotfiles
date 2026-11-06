-- Keep Slack and the WhatsApp Web app together on workspace 5.
for _, class in ipairs({
    "^[Ss]lack$",
    "^zen\\.webapp-.*$", -- Zen Taskbar Tab / Web App
}) do
    hl.window_rule({
        name = "workspace-5-" .. class,
        match = { initial_class = class },
        workspace = "5",
        group = "set always",
    })
end

-- Cider lives on workspace 3.
hl.window_rule({
    name = "workspace-3-cider",
    match = { initial_class = "^[Cc]ider$" },
    workspace = "3",
})

-- Only the dedicated notes frame belongs to this special workspace.
-- PGTK frames share the Emacs app ID, so match its fixed initial title too.
hl.window_rule({
    name = "notes-special-workspace",
    match = { initial_class = "^emacs$", initial_title = "^emacs-notes$" },
    workspace = "special:notes silent",
})

hl.window_rule({
    name = "emacs-file-picker",
    match = {
        initial_class = "^emacs$",
        initial_title = "^filechooser-(frame|miniframe)$",
    },
    float = true,
    center = true,
})

hl.config({
    general = {
	gaps_in = 2,
	gaps_out = 4,
	border_size = 1,
	col = {
	    active_border = accent,
	    inactive_border = bgMutedPlus,
	},
	layout = dwindle,
	allow_tearing = false,
    },
    decoration = {
	rounding = 0,
	rounding_power = 1,
	shadow = {
	    enabled = false,
	    color = "rgba(0, 0, 0, 0.4)",
	}
    },
    animations = {
	enabled = true,
    },
    dwindle = {
	preserve_split = true,
    },
    group = {
        col = {
            border_active = accent,
            border_inactive = bgMutedPlus,
            border_locked_active = "rgb(c44d05)",
            border_locked_inactive = bgMuted,
        },
        groupbar = {
            col = {
                active = accent,
                inactive = bgMuted,
                locked_active = "rgb(c44d05)",
                locked_inactive = bgMuted,
            },
        },
    },
    misc = {
	force_default_wallpaper = 0,
    }
})
