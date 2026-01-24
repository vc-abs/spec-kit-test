---
name: gemini-imagen-default
type: mcp-config
description: "Default configuration for Google Gemini Imagen 3.0 image generation"
version: v1
provider: google
model: imagen-3.0-generate-001
server: gemini-imagen
parameters:
  aspect-ratio: "1:1"
  quality: "high"
  safety-filter: "medium"
  prompt-enhancement: true
cost-tier: medium
tags: ["imagen", "google", "default", "square"]
---

# Gemini Imagen Default Configuration

Balanced configuration for Google Gemini Imagen 3.0, suitable for most image generation workflows. Produces square (1:1) images with high quality and moderate safety filtering.

## Use Cases

- Character portraits and profile images
- Icon and logo generation
- Social media content (Instagram, avatars)
- General purpose scene visualization

## Parameters

- **aspect-ratio**: 1:1 (1024x1024 pixels) - Square format for versatile usage
- **quality**: high - Good balance between detail and generation speed
- **safety-filter**: medium - Standard content moderation
- **prompt-enhancement**: true - Automatically improves prompt for better results

## Cost Considerations

Medium tier - approximately $0.04-0.06 per image with Imagen 3.0 pricing.

## Notes

This configuration uses the MCP server defined in `.vscode/settings.json` as `gemini-imagen`. Ensure `GOOGLE_API_KEY` is set in your `.env` file.
