#!/usr/bin/env bash
# Matugen + Pattern Wallpaper Generator Wrapper for Hyprland
# Generates abstract patterns from colorschemes and applies them with matugen

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WALLPAPER_GEN="${SCRIPT_DIR}/wallpaper-gen.py"
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/matugen"
CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/matugen-patterns"
WALLPAPER_DIR="${HOME}/.local/share/wallpapers/generated"

# Default values
PATTERN="triangles"
RESOLUTION="3840x2160"
MODE="dark"
SEED=""
ANTIALIAS="4"
COLOR_SCHEME="primary-neutral"
WALLPAPER_SETTER="hyprpaper"

usage() {
    cat << EOF
Usage: $(basename "$0") [OPTIONS]

Generate abstract pattern wallpaper from matugen colorscheme and apply it with hyprpaper.

OPTIONS:
    -p, --pattern PATTERN       Pattern type (triangles, circles, gradient, stripes, grid, waves)
                                Default: triangles
    -r, --resolution RES        Resolution in WIDTHxHEIGHT format
                                Default: 3840x2160
    -m, --mode MODE            Color mode (dark, light, amoled)
                                Default: dark
    -s, --seed SEED            Random seed for reproducible patterns
    -c, --color COLOR          Source color (hex) to generate scheme from
                                If not provided, fetches color from colorscheme_maker.ts
    -a, --antialias FACTOR     Anti-aliasing factor (1-6, default: 4, higher=smoother)
    -w, --wallpaper-setter      Wallpaper setter (hyprpaper, swww, none)
                                Default: hyprpaper
    --color-scheme SCHEME      Color scheme to extract (all, primary, neutral, primary-neutral)
                                Default: primary-neutral
    --skip-matugen             Skip running matugen (use cached colors only)
    --skip-set-wallpaper       Generate wallpaper but don't set it
    --show-colors              Display extracted colors
    -h, --help                 Show this help message

EXAMPLES:
    # Generate from a source color
    $(basename "$0") -c "#4285f4" -p triangles
    
    # Auto-fetch color from colorscheme_maker.ts
    $(basename "$0") -p circles
    
    # Use only primary colors
    $(basename "$0") -c "#4285f4" -p circles --color-scheme primary
    
    # Use only neutral/surface colors
    $(basename "$0") -c "#88c0d0" -p gradient --color-scheme neutral
    
    # Use cached matugen colors with waves pattern
    $(basename "$0") --skip-matugen -p waves
    
    # Custom resolution with reproducible seed
    $(basename "$0") -c "#ff6b6b" -p circles -r 2560x1440 -s 42
    
    # Light mode with gradient
    $(basename "$0") -c "#88c0d0" -m light -p gradient

SETUP:
    1. Ensure matugen is installed and configured
    2. Make sure hyprpaper or swww is running
    3. Place this script and wallpaper-gen.py in the same directory
    4. Run: chmod +x $(basename "$0")
EOF
    exit 0
}

log() {
    echo "[$(date +'%H:%M:%S')] $*" >&2
}

error() {
    echo "[ERROR] $*" >&2
    exit 1
}

check_dependencies() {
    local missing=()
    
    command -v uv >/dev/null || missing+=("uv (install from https://docs.astral.sh/uv/)")
    command -v matugen >/dev/null || missing+=("matugen")
    command -v jq >/dev/null || missing+=("jq")
    
    # Only check for bun if we need to fetch a color
    if [[ -z "$SOURCE_COLOR" && "$SKIP_MATUGEN" != "true" ]]; then
        command -v bun >/dev/null || missing+=("bun (needed to fetch color)")
        if [[ ! -f "${SCRIPT_DIR}/colorscheme_maker.ts" ]]; then
            log "Warning: colorscheme_maker.ts not found at ${SCRIPT_DIR}/colorscheme-maker.ts"
        fi
    fi
    
    if [[ "$WALLPAPER_SETTER" == "hyprpaper" && "$SKIP_SET_WALLPAPER" != "true" ]]; then
        if [[ -z "$HYPRLAND_INSTANCE_SIGNATURE" ]]; then
            log "Warning: Not running in Hyprland session, will skip setting wallpaper"
            SKIP_SET_WALLPAPER=true
        elif ! pgrep -x hyprpaper >/dev/null; then
            log "Warning: hyprpaper is not running"
        fi
    elif [[ "$WALLPAPER_SETTER" == "swww" && "$SKIP_SET_WALLPAPER" != "true" ]]; then
        command -v swww >/dev/null || missing+=("swww")
    fi
    
    if [[ ${#missing[@]} -gt 0 ]]; then
        error "Missing dependencies: ${missing[*]}"
    fi
    
    if [[ ! -f "$WALLPAPER_GEN" ]]; then
        error "wallpaper-gen.py not found at $WALLPAPER_GEN"
    fi
}

parse_args() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            -p|--pattern)
                PATTERN="$2"
                shift 2
                ;;
            -r|--resolution)
                RESOLUTION="$2"
                shift 2
                ;;
            -m|--mode)
                MODE="$2"
                shift 2
                ;;
            -s|--seed)
                SEED="$2"
                shift 2
                ;;
            -c|--color)
                SOURCE_COLOR="$2"
                shift 2
                ;;
            -a|--antialias)
                ANTIALIAS="$2"
                shift 2
                ;;
            -w|--wallpaper-setter)
                WALLPAPER_SETTER="$2"
                shift 2
                ;;
            --color-scheme)
                COLOR_SCHEME="$2"
                shift 2
                ;;
            --skip-matugen)
                SKIP_MATUGEN=true
                shift
                ;;
            --skip-set-wallpaper)
                SKIP_SET_WALLPAPER=true
                shift
                ;;
            --show-colors)
                SHOW_COLORS=true
                shift
                ;;
            -h|--help)
                usage
                ;;
            *)
                error "Unknown option: $1"
                ;;
        esac
    done
}

run_matugen() {
    if [[ "$SKIP_MATUGEN" == "true" ]]; then
        log "Skipping matugen (using cached colors)"
        return
    fi
    
    if [[ -z "$SOURCE_COLOR" ]]; then
        error "No source color provided and fetch_color was not called. This should not happen."
    fi
    
    log "Running matugen with color $SOURCE_COLOR (mode: $MODE)"
    matugen color hex "$SOURCE_COLOR" -m "$MODE" --json hex > /dev/null
}

extract_colors() {
    log "Extracting colors from matugen output..."
    
    # Try to get colors from matugen's JSON output
    local json_output
    if [[ -n "$SOURCE_COLOR" ]]; then
        json_output=$(matugen color hex "$SOURCE_COLOR" -m "$MODE" --json hex 2>/dev/null || echo "")
    else
        # Try to find cached colors
        local cache_file
        cache_file=$(find "$HOME/.cache/matugen" -name "*.json" -type f 2>/dev/null | head -1)
        if [[ -f "$cache_file" ]]; then
            json_output=$(cat "$cache_file")
            log "Using cached colors from $cache_file"
        fi
    fi
    
    if [[ -z "$json_output" ]]; then
        error "Failed to get colors from matugen"
    fi
    
    # Debug: save JSON output to temp file
    local debug_file="${CACHE_DIR}/debug_matugen_output.json"
    mkdir -p "$CACHE_DIR"
    echo "$json_output" > "$debug_file"
    log "Debug: Saved matugen output to $debug_file"
    
    # Build color array from Material You palette
    local colors=()
    
    # Try multiple extraction methods
    if command -v jq >/dev/null; then
        log "Attempting color extraction with jq..."
        
        # Method 1: Extract colors based on color scheme preference
        local jq_colors
        case "$COLOR_SCHEME" in
            primary)
                jq_colors=$(echo "$json_output" | jq -r "
                    [
                        .colors.primary.${MODE},
                        .colors.on_primary.${MODE},
                        .colors.primary_container.${MODE},
                        .colors.on_primary_container.${MODE},
                        .colors.primary_fixed.${MODE},
                        .colors.primary_fixed_dim.${MODE}
                    ] | map(select(. != null and . != \"\")) | unique | .[]
                " 2>/dev/null || echo "")
                ;;
            neutral)
                jq_colors=$(echo "$json_output" | jq -r "
                    [
                        .colors.surface.${MODE},
                        .colors.surface_dim.${MODE},
                        .colors.surface_bright.${MODE},
                        .colors.surface_container.${MODE},
                        .colors.surface_container_low.${MODE},
                        .colors.surface_container_high.${MODE},
                        .colors.surface_container_highest.${MODE},
                        .colors.on_surface.${MODE},
                        .colors.on_surface_variant.${MODE},
                        .colors.outline.${MODE},
                        .colors.outline_variant.${MODE}
                    ] | map(select(. != null and . != \"\")) | unique | .[]
                " 2>/dev/null || echo "")
                ;;
            primary-neutral)
                jq_colors=$(echo "$json_output" | jq -r "
                    [
                        .colors.primary.${MODE},
                        .colors.on_primary.${MODE},
                        .colors.primary_container.${MODE},
                        .colors.surface.${MODE},
                        .colors.surface_dim.${MODE},
                        .colors.surface_bright.${MODE},
                        .colors.surface_container.${MODE},
                        .colors.on_surface.${MODE},
                        .colors.on_surface_variant.${MODE},
                        .colors.outline.${MODE}
                    ] | map(select(. != null and . != \"\")) | unique | .[]
                " 2>/dev/null || echo "")
                ;;
            all|*)
                jq_colors=$(echo "$json_output" | jq -r "
                    [
                        .colors.primary.${MODE},
                        .colors.secondary.${MODE},
                        .colors.tertiary.${MODE},
                        .colors.error.${MODE},
                        .colors.surface.${MODE},
                        .colors.on_surface.${MODE},
                        .colors.primary_container.${MODE},
                        .colors.secondary_container.${MODE},
                        .colors.tertiary_container.${MODE},
                        .colors.surface_variant.${MODE},
                        .colors.on_primary.${MODE},
                        .colors.on_secondary.${MODE}
                    ] | map(select(. != null and . != \"\")) | unique | .[]
                " 2>/dev/null || echo "")
                ;;
        esac
        
        if [[ -n "$jq_colors" ]]; then
            mapfile -t colors <<< "$jq_colors"
            log "Method 1 (${COLOR_SCHEME} scheme): Found ${#colors[@]} colors"
        fi
        
        # Method 2: Try extracting all hex colors from the entire JSON
        if [[ ${#colors[@]} -eq 0 ]]; then
            log "Method 1 failed, trying fallback extraction..."
            jq_colors=$(echo "$json_output" | jq -r '.. | select(type == "string" and test("^#[0-9a-fA-F]{6,8}$")) | select(length > 0)' 2>/dev/null | sort -u | head -12)
            
            if [[ -n "$jq_colors" ]]; then
                mapfile -t colors <<< "$jq_colors"
                log "Method 2 (all hex): Found ${#colors[@]} colors"
            fi
        fi
    fi
    
    # Fallback: grep for hex colors
    if [[ ${#colors[@]} -eq 0 ]]; then
        log "jq extraction failed, using grep fallback..."
        mapfile -t colors < <(echo "$json_output" | grep -oE '#[0-9a-fA-F]{6,8}' | sort -u | head -12)
        log "Grep fallback: Found ${#colors[@]} colors"
    fi
    
    # Filter out invalid entries
    local valid_colors=()
    for color in "${colors[@]}"; do
        if [[ "$color" =~ ^#[0-9a-fA-F]{6,8}$ ]]; then
            valid_colors+=("$color")
        fi
    done
    colors=("${valid_colors[@]}")
    
    if [[ ${#colors[@]} -eq 0 ]]; then
        error "No valid colors extracted from matugen output. Check $debug_file for the raw JSON."
    fi
    
    if [[ "$SHOW_COLORS" == "true" ]]; then
        log "Extracted ${#colors[@]} colors:"
        printf '  %s\n' "${colors[@]}"
    fi
    
    # Create colors JSON for wallpaper generator
    COLOR_JSON=$(printf '%s\n' "${colors[@]}" | jq -R -s -c 'split("\n") | map(select(length > 0))')
    
    log "Extracted ${#colors[@]} colors from matugen palette"
}

generate_wallpaper() {
    local timestamp=$(date +%Y%m%d_%H%M%S)
    local wallpaper_name="matugen_${PATTERN}_${timestamp}.png"
    local wallpaper_path="${WALLPAPER_DIR}/${wallpaper_name}"
    
    mkdir -p "$WALLPAPER_DIR" "$CACHE_DIR"
    
    log "Generating $PATTERN pattern wallpaper ($RESOLUTION)..."
    
    local seed_arg=""
    if [[ -n "$SEED" ]]; then
        seed_arg="--seed $SEED"
    fi
    
    local show_colors_arg=""
    if [[ "$SHOW_COLORS" == "true" ]]; then
        show_colors_arg="--show-colors"
    fi
    
    # Run the generator and capture only the output path
    wallpaper_path=$("$WALLPAPER_GEN" \
        -c "$COLOR_JSON" \
        -p "$PATTERN" \
        -r "$RESOLUTION" \
        -o "$wallpaper_path" \
        -s none \
        --antialias "$ANTIALIAS" \
        $seed_arg \
        $show_colors_arg 2>&1 | tail -1)
    
    if [[ ! -f "$wallpaper_path" ]]; then
        error "Failed to generate wallpaper at $wallpaper_path"
    fi
    
    log "Wallpaper saved to: $wallpaper_path"
    
    # Save metadata
    cat > "${CACHE_DIR}/last_generated.json" << EOF
{
    "wallpaper": "$wallpaper_path",
    "pattern": "$PATTERN",
    "resolution": "$RESOLUTION",
    "mode": "$MODE",
    "colors": $COLOR_JSON,
    "timestamp": "$timestamp"
}
EOF
    
    echo "$wallpaper_path"
}

set_wallpaper() {
    local wallpaper_path="$1"
    
    if [[ "$SKIP_SET_WALLPAPER" == "true" ]]; then
        log "Skipping wallpaper setting (--skip-set-wallpaper or not in Hyprland)"
        log "To set manually, run:"
        if [[ "$WALLPAPER_SETTER" == "hyprpaper" ]]; then
            log "  hyprctl hyprpaper preload '$wallpaper_path'"
            log "  hyprctl hyprpaper wallpaper ',$wallpaper_path'"
        else
            log "  swww img '$wallpaper_path'"
        fi
        return 0
    fi
    
    log "Setting wallpaper with $WALLPAPER_SETTER..."
    
    case "$WALLPAPER_SETTER" in
        hyprpaper)
            # Check if hyprpaper is running
            if ! pgrep -x hyprpaper >/dev/null; then
                log "Starting hyprpaper..."
                hyprpaper &
                sleep 1
            fi
            
            # Preload and set wallpaper
            hyprctl hyprpaper preload "$wallpaper_path" || error "Failed to preload wallpaper"
            hyprctl hyprpaper wallpaper ",$wallpaper_path" || error "Failed to set wallpaper"
            log "Wallpaper set successfully"
            ;;
        swww)
            swww img "$wallpaper_path" --transition-type center || error "Failed to set wallpaper with swww"
            log "Wallpaper set successfully"
            ;;
        none)
            log "Wallpaper setter is 'none', skipping"
            ;;
        *)
            error "Unknown wallpaper setter: $WALLPAPER_SETTER"
            ;;
    esac
}

fetch_color(){
    SOURCE_COLOR=$(bun run ~/.config/wallpaper/colorscheme_maker.ts)
}

main() {
    parse_args "$@"
    check_dependencies
    fetch_color
    
    run_matugen
    extract_colors
    
    local wallpaper_path
    wallpaper_path=$(generate_wallpaper)
    
    set_wallpaper "$wallpaper_path"
    
    log "Done! Your desktop is now themed with matugen colors"
    
    if [[ "$SHOW_COLORS" != "true" ]]; then
        log "Run with --show-colors to see the color palette"
    fi
}

main "$@"
