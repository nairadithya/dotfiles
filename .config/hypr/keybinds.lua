local mainMod = "SUPER"

hl.bind(mainMod .. " + V", hl.dsp.exec_cmd([[ghostty --class=com.nairadithya.clipse -e bash -c 'exec clipse']]))
hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd(emacs))
hl.bind(mainMod .. " + SHIFT + O", hl.dsp.exec_cmd("~/.config/hypr/scripts/hyprshot --clipboard-only -m region --freeze"))
hl.bind(mainMod .. " + O", hl.dsp.exec_cmd("~/.config/hypr/scripts/hyprshot --clipboard-only -m window --freeze"))
hl.bind(mainMod .. " + SHIFT + RETURN", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + PERIOD", hl.dsp.exec_cmd([[emacsclient -c -F '((title . "emacs-agenda"))' -e '(org-agenda-list)']]))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + N", hl.dsp.exec_cmd(org_capture))
hl.bind(mainMod .. " + SHIFT + N", hl.dsp.exec_cmd("~/.config/hypr/scripts/toggle-notes"))
hl.bind(mainMod .. " + M", hl.dsp.exec_cmd(music))
hl.bind(mainMod .. " + C", hl.dsp.window.close())
hl.bind(mainMod .. " + G", hl.dsp.exec_cmd("fnottctl actions"))
hl.bind(mainMod .. " + Q", hl.dsp.exec_cmd("~/.config/fuzzel/scripts/power-menu"))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + SHIFT + space", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + escape", hl.dsp.exec_cmd("hyprlock"))
-- Ignore the ThinkPad Fn + 4 sleep key, including while locked.
hl.bind("XF86Sleep", hl.dsp.exec_cmd("true"), { locked = true })
hl.bind(mainMod .. " + SHIFT + R", hl.dsp.exec_cmd(cmenu))

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 10%-"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl set 10%+"), { locked = true, repeating = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl pause"), { locked = true })

hl.bind("CTRL + ALT + space", hl.dsp.exec_cmd("playerctl play-pause"))
hl.bind("CTRL + ALT + left", hl.dsp.exec_cmd("playerctl previous"))
hl.bind("CTRL + ALT + right", hl.dsp.exec_cmd("playerctl next"))
hl.bind("CTRL + ALT + up", hl.dsp.exec_cmd("wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+"), { repeating = true })
hl.bind("CTRL + ALT + down", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { repeating = true })

hl.bind(mainMod .." + H", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .." + L", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .." + J", hl.dsp.focus({ direction = "down" }))
hl.bind(mainMod .." + K", hl.dsp.focus({ direction = "up" }))

hl.bind(mainMod .. " + SHIFT + H", hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + SHIFT + J", hl.dsp.window.move({ direction = "down" }))
hl.bind(mainMod .. " + SHIFT + K", hl.dsp.window.move({ direction = "up" }))

-- Cycle between Slack and WhatsApp in their tabbed group on workspace 5.
hl.bind(mainMod .. " + ALT + H", hl.dsp.group.prev())
hl.bind(mainMod .. " + ALT + L", hl.dsp.group.next())

for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mainMod .. " + " .. key,             hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key,     hl.dsp.window.move({ workspace = i }))
end

hl.bind(mainMod .. " + S",         hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Vertical monitor workflow: K = upper/external, J = lower/laptop.
-- Keep workspace numbers task-based; move whole layouts when needed.
for _, target in ipairs({ { key = "K", monitor = "u" }, { key = "J", monitor = "d" } }) do
    hl.bind(mainMod .. " + CTRL + " .. target.key,
        hl.dsp.focus({ monitor = target.monitor }))
    hl.bind(mainMod .. " + CTRL + SHIFT + " .. target.key,
        hl.dsp.window.move({ monitor = target.monitor, follow = true }))
    hl.bind(mainMod .. " + ALT + SHIFT + " .. target.key,
        hl.dsp.workspace.move({ monitor = target.monitor }))
end

hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + Control_L", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
hl.bind(mainMod .. " + ALT_L", hl.dsp.window.resize(), { mouse = true })

-- Lid events should not blank the external monitor.
hl.bind("switch:on:Lid Switch", hl.dsp.exec_cmd([[sleep 0.5; hyprctl dispatch 'hl.dsp.dpms({ action = "disable", monitor = "eDP-1" })']]), { locked = true })
hl.bind("switch:off:Lid Switch", hl.dsp.exec_cmd([[sleep 0.5; hyprctl dispatch 'hl.dsp.dpms({ action = "enable", monitor = "eDP-1" })']]), { locked = true })

hl.bind("ALT + R", hl.dsp.submap("resize"))

hl.define_submap("resize", function()
    hl.bind("L", hl.dsp.exec_cmd("hyprctl dispatch resizeactive 10 0"), { repeating = true })
    hl.bind("H", hl.dsp.exec_cmd("hyprctl dispatch resizeactive -10 0"), { repeating = true })
    hl.bind("K", hl.dsp.exec_cmd("hyprctl dispatch resizeactive 0 -10"), { repeating = true })
    hl.bind("J", hl.dsp.exec_cmd("hyprctl dispatch resizeactive 0 10"), { repeating = true })
    hl.bind("escape", hl.dsp.submap("reset"))
end)

-- Hold Alt + backslash to dictate with Hex.
hl.bind("ALT + backslash", hl.dsp.global("hex:dictation"))
