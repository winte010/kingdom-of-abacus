#!/usr/bin/env python3
"""
Generate placeholder PNG images for math objects.
This creates simple colored squares as placeholders until proper artwork is available.
"""

from PIL import Image, ImageDraw, ImageFont
import os

# Create output directory
output_dir = "assets/images/math_objects"
os.makedirs(output_dir, exist_ok=True)

# Define placeholder images
placeholders = [
    {
        "name": "shell.png",
        "size": (200, 200),
        "color": (135, 206, 235),  # Sky blue
        "shape": "ellipse",
        "text": "🐚"
    },
    {
        "name": "treasure.png",
        "size": (200, 200),
        "color": (255, 215, 0),  # Gold
        "shape": "diamond",
        "text": "💎"
    },
    {
        "name": "rock.png",
        "size": (200, 200),
        "color": (128, 128, 128),  # Gray
        "shape": "circle",
        "text": "🪨"
    },
    {
        "name": "chest.png",
        "size": (200, 200),
        "color": (139, 69, 19),  # Brown
        "shape": "rect",
        "text": "🎁"
    },
]

def draw_ellipse(draw, size, color):
    """Draw an ellipse shape"""
    margin = 20
    draw.ellipse([margin, margin, size[0] - margin, size[1] - margin],
                 fill=color, outline=(0, 0, 0), width=3)

def draw_diamond(draw, size, color):
    """Draw a diamond shape"""
    w, h = size
    points = [
        (w // 2, 10),      # Top
        (w - 10, h // 2),  # Right
        (w // 2, h - 10),  # Bottom
        (10, h // 2),      # Left
    ]
    draw.polygon(points, fill=color, outline=(0, 0, 0), width=3)

def draw_circle(draw, size, color):
    """Draw a circle shape"""
    margin = 20
    draw.ellipse([margin, margin, size[0] - margin, size[1] - margin],
                 fill=color, outline=(0, 0, 0), width=3)

def draw_rect(draw, size, color):
    """Draw a rounded rectangle"""
    margin = 20
    draw.rounded_rectangle([margin, margin, size[0] - margin, size[1] - margin],
                          radius=20, fill=color, outline=(0, 0, 0), width=3)

# Generate each placeholder
for placeholder in placeholders:
    # Create image with transparency
    img = Image.new('RGBA', placeholder["size"], (255, 255, 255, 0))
    draw = ImageDraw.Draw(img)

    # Draw shape
    shape = placeholder["shape"]
    color = placeholder["color"] + (255,)  # Add alpha channel

    if shape == "ellipse":
        draw_ellipse(draw, placeholder["size"], color)
    elif shape == "diamond":
        draw_diamond(draw, placeholder["size"], color)
    elif shape == "circle":
        draw_circle(draw, placeholder["size"], color)
    elif shape == "rect":
        draw_rect(draw, placeholder["size"], color)

    # Try to add emoji text
    try:
        # Use a larger font size for emoji
        font = ImageFont.truetype("/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf", 80)
    except:
        # Fallback to default font
        font = ImageFont.load_default()

    # Add text centered
    text = placeholder["text"]
    bbox = draw.textbbox((0, 0), text, font=font)
    text_width = bbox[2] - bbox[0]
    text_height = bbox[3] - bbox[1]

    position = (
        (placeholder["size"][0] - text_width) // 2,
        (placeholder["size"][1] - text_height) // 2 - 10
    )

    draw.text(position, text, fill=(255, 255, 255, 255), font=font)

    # Save image
    output_path = os.path.join(output_dir, placeholder["name"])
    img.save(output_path, "PNG")
    print(f"Created: {output_path}")

print("\nPlaceholder images generated successfully!")
print("These are simple placeholders. Replace with proper artwork for production.")
