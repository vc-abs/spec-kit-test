---
name: gemini-imagen-cinematic
type: mcp-config
description: "Cinematic widescreen configuration for Gemini Imagen 3.0"
version: v1
provider: google
model: imagen-3.0-generate-001
server: gemini-imagen
parameters:
  aspect-ratio: "16:9"
  quality: "high"
  safety-filter: "medium"
  prompt-enhancement: true
cost-tier: medium
tags: ["imagen", "google", "cinematic", "widescreen", "16:9"]
---

# Gemini Imagen Cinematic Configuration

Widescreen configuration optimized for cinematic scenes, landscapes, and story panels. Produces 16:9 images ideal for storyboards and narrative visualization.

## Use Cases

- Cinematic scene composition
- Landscape and environment art
- Storyboard panels
- Video thumbnail generation
- Desktop wallpapers

## Parameters

- **aspect-ratio**: 16:9 (1920x1080 pixels) - Standard widescreen format
- **quality**: high - Detailed rendering suitable for large displays
- **safety-filter**: medium - Standard content moderation
- **prompt-enhancement**: true - Optimizes prompts for cinematic composition

## Cost Considerations

Medium tier - approximately $0.05-0.07 per image due to larger dimensions.

## Notes

Best suited for scenes with horizontal orientation. For vertical compositions (portraits, mobile content), use the `gemini-imagen-portrait` configuration instead.
