$env.config.buffer_editor = "nvim"
$env.config.show_banner = false
$env.TRANSIENT_PROMPT_COMMAND = "❯ "

$env.PATH = $env.PATH | split row (char esep) | append "/home/adithya/bin/"
$env.PATH = $env.PATH | split row (char esep) | append "/home/adithya/.local/bin/"

use ~/.cache/starship/init.nu

