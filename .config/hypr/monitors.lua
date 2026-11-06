-- External monitor above the laptop, centered in logical (scaled) pixels.
-- Laptop: 3840x2160 at 2x scale => 1920x1080 logical pixels.
-- Workspaces are deliberately not pinned to either output.
hl.monitor({
    output = "HDMI-A-1",
    mode = "2560x1440@144",
    position = "0x0",
    scale = 1.0,
    bitdepth = 10,
    cm = "hdr",
    sdr_max_luminance = 300,
})

hl.monitor({
    output = "eDP-1",
    mode = "3840x2160@60.0",
    position = "320x1440",
    scale = 2.0,
    bitdepth = 8,
    cm = "srgb",
})
