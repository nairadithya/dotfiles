$env.config.buffer_editor = "nvim"
$env.config.show_banner = false
$env.TRANSIENT_PROMPT_COMMAND = "❯ "

$env.PATH = $env.PATH | split row (char esep) | append "/home/adithya/bin/"
$env.PATH = $env.PATH | split row (char esep) | append "/home/adithya/.cargo/bin/"
$env.PATH = $env.PATH | split row (char esep) | append "/home/adithya/.local/bin/"
$env.PATH = $env.PATH | split row (char esep) | append "/home/adithya/.bun/bin/"
$env.PATH = $env.PATH | split row (char esep) | append "/home/adithya/.deno/bin/"
$env.PATH = $env.PATH | split row (char esep) | append "/home/adithya/.local/share/coursier/bin"
$env.PATH = $env.PATH | split row (char esep) | append "/home/adithya/.duckdb/cli/latest"

# Hadoop Stuff
$env.HADOOP_HOME = "/home/adithya/Apps/hadoop"
$env.HADOOP_CONF_DIR = "/home/adithya/Apps/hadoop/etc/hadoop"
$env.HADOOP_MAPRED_HOME = "/home/adithya/Apps/hadoop"
$env.HADOOP_COMMON_HOME = "/home/adithya/Apps/hadoop"
$env.HADOOP_HDFS_HOME = "/home/adithya/Apps/hadoop"
$env.YARN_HOME = "/home/adithya/Apps/hadoop"
$env.PATH = $env.PATH | split row (char esep) | append "/home/adithya/Apps/hadoop/bin"


let carapace_completer = {|spans|
    carapace $spans.0 nushell ...$spans | from json
}

$env.config.completions.external = {
    enable: true
    max_results: 100
    completer: $carapace_completer
}
use ~/.cache/starship/init.nu

alias jupyter = uv run --with jupyter jupyter lab
alias doom = ~/.config/emacs/bin/doom 
