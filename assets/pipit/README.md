# Pipit Assets

This directory contains all assets for the Pipit mobile app.

## Structure

- `images/` - App images and graphics
- `icons/` - App icons and UI icons  
- `fonts/` - Solaiman Lipi font files

## Font Installation

To use the Solaiman Lipi font, download the font files and place them in the `fonts/` directory:

- `SolaimanLipi.ttf` - Regular weight
- `SolaimanLipi-Bold.ttf` - Bold weight

The font is configured in `pubspec.yaml` under the `fonts` section.

## Adding Assets

1. Place image files in the `images/` subdirectory
2. Place icon files in the `icons/` subdirectory  
3. Update `pubspec.yaml` if needed to reference new asset directories
4. Use `AssetImage` or `Image.asset` to load images in Flutter code

## Asset Guidelines

- Use SVG for scalable icons when possible
- Optimize PNG/JPEG images for mobile (reasonable file sizes)
- Follow naming conventions: lowercase with underscores (e.g., `user_avatar.png`)
- Provide multiple resolutions for raster images (1x, 2x, 3x)