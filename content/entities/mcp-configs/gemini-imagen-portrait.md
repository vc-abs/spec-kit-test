---
name: gemini-imagen-portrait
type: mcp-config
description: "Vertical portrait configuration for Gemini Imagen 3.0"
version: v1
provider: google
model: imagen-3.0-generate-001
server: gemini-imagen
parameters:
  aspect-ratio: "9:16"
  quality: "high"
  safety-filter: "medium"
  prompt-enhancement: true
cost-tier: medium
tags: ["imagen", "google", "portrait", "vertical", "mobile"]
---

# Gemini Imagen Portrait Configuration

Vertical portrait configuration optimized for mobile content, character full-body shots, and social media stories. Produces 9:16 images ideal for Instagram Stories, TikTok, and mobile-first content.

## Use Cases

- Mobile app content and screenshots
- Instagram/Facebook Stories
- TikTok and Reels content
- Character full-body portraits
- Vertical comic panels

## Parameters

- **aspect-ratio**: 9:16 (1080x1920 pixels) - Mobile-optimized vertical format
- **quality**: high - Sharp detail for mobile displays
- **safety-filter**: medium - Standard content moderation
- **prompt-enhancement**: true - Optimizes prompts for vertical composition

## Cost Considerations

Medium tier - approximately $0.05-0.07 per image due to larger dimensions.

## Notes

Ideal for content consumed on mobile devices. The vertical orientation works well for character portraits showing full or partial body, architectural shots, and narrative sequences.
