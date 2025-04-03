#!/usr/bin/lua
local options = {
    [" Lock"] = "hyprlock",
    [" Shut down"] = "systemctl poweroff",
    [" Reboot"] = "systemctl reboot",
    ["󰍃 Log out"] = "hyprctl dispatch exit 1",
    ["󰒲 Suspend"] = "systemctl suspend",
    [" Hibernate"] = "systemctl hibernate",
}

local options_string = ""
local length = 0
for key, _ in pairs(options) do
    options_string = options_string .. key .. "\n"
    length = length + 1
end
options_string = options_string:sub(1, -2)

local f = assert(
    io.popen(
        "echo -e '"
            .. options_string
            .. "' | wofi --dmenu --insensitive --width 300 --prompt 'Power menu' --style ~/.config/wofi/style.css --lines 9 "
        ------------------ to change the location of the dropdown, use --location 1 (top left) or --location 3 (top right) (see --location in wofi --help)
            .. length,
        "r"
    )
)
local s = assert(f:read("*a"))
s = string.gsub(s, "^%s+", "")
s = string.gsub(s, "%s+$", "")
s = string.gsub(s, "[\n]+", " ")
f:close()

os.execute(options[s])
