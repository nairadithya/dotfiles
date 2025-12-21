#!/usr/bin/env -S uv run
# /// script
# requires-python = ">=3.10"
# dependencies = [
#     "pillow>=10.0.0",
# ]
# ///
"""
Colorscheme Pattern Wallpaper Generator for Hyprland
Generates abstract geometric patterns from color palettes
"""

import argparse
import colorsys
import json
import random
import subprocess
import sys
from pathlib import Path

from PIL import Image, ImageDraw


class PatternGenerator:
    def __init__(self, colors, width=1920, height=1080, antialias=4):
        self.colors = colors
        self.width = width
        self.height = height
        self.antialias = antialias  # Supersampling factor for anti-aliasing

    def hex_to_rgb(self, hex_color):
        """Convert hex color to RGB tuple"""
        hex_color = hex_color.lstrip("#")
        return tuple(int(hex_color[i : i + 2], 16) for i in (0, 2, 4))

    def generate_gradient(self):
        """Generate a smooth gradient background"""
        img = Image.new("RGB", (self.width, self.height))
        draw = ImageDraw.Draw(img)

        # Pick two colors for gradient
        c1 = self.hex_to_rgb(self.colors[0])
        c2 = self.hex_to_rgb(self.colors[-1])

        for y in range(self.height):
            ratio = y / self.height
            r = int(c1[0] * (1 - ratio) + c2[0] * ratio)
            g = int(c1[1] * (1 - ratio) + c2[1] * ratio)
            b = int(c1[2] * (1 - ratio) + c2[2] * ratio)
            draw.line([(0, y), (self.width, y)], fill=(r, g, b))

        return img

    def generate_triangles(self):
        """Generate low-poly triangle pattern with anti-aliasing"""
        # Create larger image for supersampling
        aa_width = self.width * self.antialias
        aa_height = self.height * self.antialias
        img = Image.new("RGB", (aa_width, aa_height), self.hex_to_rgb(self.colors[0]))
        draw = ImageDraw.Draw(img)

        # Generate random points
        points = []
        grid_size = 100 * self.antialias
        for x in range(0, aa_width + grid_size, grid_size):
            for y in range(0, aa_height + grid_size, grid_size):
                px = x + random.randint(-grid_size // 2, grid_size // 2)
                py = y + random.randint(-grid_size // 2, grid_size // 2)
                points.append((px, py))

        # Draw triangles
        for i in range(0, len(points) - 2, 3):
            color = random.choice(self.colors)
            triangle = [points[i], points[i + 1], points[i + 2]]
            draw.polygon(triangle, fill=self.hex_to_rgb(color), outline=None)

        # Downsample with high-quality filter
        return img.resize((self.width, self.height), Image.Resampling.LANCZOS)

    def generate_circles(self):
        """Generate overlapping circles pattern with anti-aliasing"""
        # Create larger image for supersampling
        aa_width = self.width * self.antialias
        aa_height = self.height * self.antialias
        img = Image.new("RGB", (aa_width, aa_height), self.hex_to_rgb(self.colors[0]))
        draw = ImageDraw.Draw(img)

        num_circles = 50
        for _ in range(num_circles):
            x = random.randint(-200 * self.antialias, aa_width + 200 * self.antialias)
            y = random.randint(-200 * self.antialias, aa_height + 200 * self.antialias)
            r = random.randint(50 * self.antialias, 300 * self.antialias)
            color = random.choice(self.colors[1:])

            rgb = self.hex_to_rgb(color)
            draw.ellipse([x - r, y - r, x + r, y + r], fill=rgb, outline=None)

        # Downsample with high-quality filter
        return img.resize((self.width, self.height), Image.Resampling.LANCZOS)

    def generate_stripes(self):
        """Generate diagonal stripes pattern with anti-aliasing"""
        aa_width = self.width * self.antialias
        aa_height = self.height * self.antialias
        img = Image.new("RGB", (aa_width, aa_height))
        draw = ImageDraw.Draw(img)

        stripe_width = 80 * self.antialias

        # Create rotated stripes
        for i in range(-aa_height, aa_width + aa_height, stripe_width):
            color = self.colors[i // stripe_width % len(self.colors)]
            points = [
                (i, 0),
                (i + aa_height, aa_height),
                (i + aa_height + stripe_width, aa_height),
                (i + stripe_width, 0),
            ]
            draw.polygon(points, fill=self.hex_to_rgb(color))

        return img.resize((self.width, self.height), Image.Resampling.LANCZOS)

    def generate_grid(self):
        """Generate geometric grid pattern with anti-aliasing"""
        aa_width = self.width * self.antialias
        aa_height = self.height * self.antialias
        img = Image.new("RGB", (aa_width, aa_height), self.hex_to_rgb(self.colors[0]))
        draw = ImageDraw.Draw(img)

        cell_size = 100 * self.antialias
        for x in range(0, aa_width, cell_size):
            for y in range(0, aa_height, cell_size):
                if random.random() > 0.3:
                    color = random.choice(self.colors[1:])
                    shape = random.choice(["rect", "circle", "triangle"])

                    if shape == "rect":
                        draw.rectangle(
                            [x, y, x + cell_size, y + cell_size],
                            fill=self.hex_to_rgb(color),
                        )
                    elif shape == "circle":
                        draw.ellipse(
                            [x, y, x + cell_size, y + cell_size],
                            fill=self.hex_to_rgb(color),
                        )
                    else:
                        points = [
                            (x + cell_size // 2, y),
                            (x, y + cell_size),
                            (x + cell_size, y + cell_size),
                        ]
                        draw.polygon(points, fill=self.hex_to_rgb(color))

        return img.resize((self.width, self.height), Image.Resampling.LANCZOS)

    def generate_waves(self):
        """Generate wave pattern"""
        img = Image.new(
            "RGB", (self.width, self.height), self.hex_to_rgb(self.colors[0])
        )
        draw = ImageDraw.Draw(img)

        import math

        num_waves = len(self.colors)

        for i, color in enumerate(self.colors):
            points = []
            amplitude = 100
            frequency = 0.01
            offset = i * (self.height / num_waves)

            for x in range(self.width + 10):
                y = int(offset + amplitude * math.sin(frequency * x + i))
                points.append((x, y))

            # Draw filled wave
            points.extend([(self.width, self.height), (0, self.height)])
            draw.polygon(points, fill=self.hex_to_rgb(color))

        return img


def load_colors(colorscheme_input):
    """Load colors from various input formats"""
    colors = []

    # Try parsing as JSON
    try:
        data = json.loads(colorscheme_input)
        if isinstance(data, dict):
            colors = [
                v
                for k, v in sorted(data.items())
                if isinstance(v, str) and v.startswith("#")
            ]
        elif isinstance(data, list):
            colors = [c for c in data if isinstance(c, str) and c.startswith("#")]
    except json.JSONDecodeError:
        # Try parsing as space or newline separated hex colors
        colors = [
            c.strip()
            for c in colorscheme_input.replace("\n", " ").split()
            if c.strip().startswith("#")
        ]

    if not colors:
        raise ValueError("No valid hex colors found in input")

    return colors


def set_wallpaper(image_path, setter="hyprpaper"):
    """Set wallpaper using specified setter"""
    if setter == "hyprpaper":
        # Preload and set wallpaper via hyprctl
        subprocess.run(["hyprctl", "hyprpaper", "preload", str(image_path)])
        subprocess.run(["hyprctl", "hyprpaper", "wallpaper", f",{image_path}"])
    elif setter == "swww":
        subprocess.run(["swww", "img", str(image_path)])
    else:
        print(f"Unknown wallpaper setter: {setter}")


def main():
    parser = argparse.ArgumentParser(
        description="Generate abstract wallpapers from colorschemes",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  # From JSON
  %(prog)s -c '["#1a1b26", "#f7768e", "#9ece6a", "#e0af68"]' -p triangles
  
  # From space-separated colors
  %(prog)s -c "#1a1b26 #f7768e #9ece6a" -p circles
  
  # With custom resolution
  %(prog)s -c colors.json -p gradient -r 2560x1440
  
  # Auto-set with swww
  %(prog)s -c colors.txt -p waves -s swww
        """,
    )

    parser.add_argument(
        "-c",
        "--colors",
        required=True,
        help="Color scheme (JSON, space-separated hex, or file path)",
    )
    parser.add_argument(
        "-p",
        "--pattern",
        choices=["gradient", "triangles", "circles", "stripes", "grid", "waves"],
        default="triangles",
        help="Pattern type (default: triangles)",
    )
    parser.add_argument(
        "-o",
        "--output",
        default="~/.config/hypr/wallpaper.png",
        help="Output file path (default: ~/.config/hypr/wallpaper.png)",
    )
    parser.add_argument(
        "-r",
        "--resolution",
        default="1920x1080",
        help="Resolution in WIDTHxHEIGHT format (default: 1920x1080)",
    )
    parser.add_argument(
        "-s",
        "--setter",
        choices=["hyprpaper", "swww", "none"],
        default="none",
        help="Wallpaper setter to use (default: none)",
    )
    parser.add_argument(
        "--seed", type=int, help="Random seed for reproducible patterns"
    )
    parser.add_argument(
        "--show-colors",
        action="store_true",
        help="Show debug output including colors and progress",
    )
    parser.add_argument(
        "--antialias",
        type=int,
        default=4,
        help="Anti-aliasing factor (1=none, 2-4=smooth, default: 4)",
    )

    args = parser.parse_args()

    # Set random seed if provided
    if args.seed:
        random.seed(args.seed)

    # Load colors
    color_input = args.colors
    if Path(args.colors).exists():
        color_input = Path(args.colors).read_text()

    colors = load_colors(color_input)
    if args.show_colors:
        print(f"Loaded {len(colors)} colors: {colors}", file=sys.stderr)

    # Parse resolution
    width, height = map(int, args.resolution.split("x"))

    # Generate pattern
    gen = PatternGenerator(colors, width, height, antialias=args.antialias)
    pattern_methods = {
        "gradient": gen.generate_gradient,
        "triangles": gen.generate_triangles,
        "circles": gen.generate_circles,
        "stripes": gen.generate_stripes,
        "grid": gen.generate_grid,
        "waves": gen.generate_waves,
    }

    if args.show_colors:
        print(f"Generating {args.pattern} pattern...", file=sys.stderr)
    img = pattern_methods[args.pattern]()

    # Save image
    output_path = Path(args.output).expanduser()
    output_path.parent.mkdir(parents=True, exist_ok=True)
    img.save(output_path)
    if args.show_colors:
        print(f"Saved to {output_path}", file=sys.stderr)

    # Set wallpaper if requested
    if args.setter != "none":
        if args.show_colors:
            print(f"Setting wallpaper with {args.setter}...", file=sys.stderr)
        set_wallpaper(output_path, args.setter)

    # Print the output path to stdout (this is what the bash script captures)
    print(output_path)


if __name__ == "__main__":
    main()
