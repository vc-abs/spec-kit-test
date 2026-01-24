---
name: style
type: entity-template
description: "Template for defining art direction and visual style entities"
version: v1
---

# Style Entity Template

## Purpose

Defines the structure and validation rules for style entities that specify art direction, visual aesthetics, color palettes, and artistic techniques for asset generation.

## Required Fields

### Core Fields

- **name** (string): Unique identifier for the style (kebab-case)
- **type** (string): Must be "style"
- **description** (string): Brief summary of the style
- **version** (string): Version identifier (e.g., v1, v2)

### Style-Specific Fields

- **art_direction** (string): Primary artistic approach or movement (e.g., "cinematic realism", "watercolor impressionism", "low-poly 3D")
- **color_palette** (array[string]): Key colors or color scheme description (e.g., ["warm earth tones", "vibrant neon", "#FF5733"])
- **mood** (string): Emotional tone or atmosphere (e.g., "dreamy", "dramatic", "playful")

## Optional Fields

- **technique** (string): Artistic medium or rendering style (e.g., "oil painting", "digital illustration", "procedural generation")
- **lighting** (string): Lighting characteristics (e.g., "soft diffused", "high contrast", "golden hour")
- **reference_artists** (array[string]): Influences or reference artists
- **tags** (array[string]): Additional categorization tags

## Validation Rules

### VR-STYLE-001: Name Format

- Name must use kebab-case (lowercase with hyphens)
- Only alphanumeric characters and hyphens allowed
- Must be unique within styles directory

### VR-STYLE-002: Required Field Presence

- All core fields and style-specific required fields must be present
- Empty strings not allowed for required fields

### VR-STYLE-003: Color Palette

- If color_palette provided, must be non-empty array
- Can contain color names, hex codes, or descriptive terms

## Quality Gates

### QG-STYLE-001: Art Direction Defined (critical)

- **Check**: art_direction field is non-empty
- **Fix**: Add clear artistic direction description
- **Why**: Art direction is fundamental to style definition

### QG-STYLE-002: Color Palette Specified (critical)

- **Check**: color_palette contains at least one entry
- **Fix**: Define primary colors or color scheme
- **Why**: Color is essential to visual style

### QG-STYLE-003: Mood Described (warning)

- **Check**: mood field is non-empty
- **Fix**: Add emotional tone or atmosphere description
- **Why**: Mood helps convey intended aesthetic feeling

### QG-STYLE-004: Technique Noted (warning)

- **Check**: technique field is present and non-empty
- **Fix**: Specify artistic medium or rendering approach
- **Why**: Technique clarifies implementation method

## Self-Validation Example

```yaml
---
name: cinematic-realism
type: style
description: "Hollywood-quality photorealistic rendering with dramatic lighting"
version: v1
art_direction: "cinematic realism"
color_palette: ["rich shadows", "warm highlights", "desaturated midtones"]
mood: "dramatic"
technique: "photorealistic digital rendering"
lighting: "high contrast with rim lighting"
tags: ["photorealism", "cinematic", "dramatic"]
---

A style focused on achieving photorealistic quality with cinematic lighting techniques,
emphasizing depth through contrast and atmospheric perspective.
```

**Validation Results**:

- ✅ QG-STYLE-001: Art direction defined ("cinematic realism")
- ✅ QG-STYLE-002: Color palette specified (3 entries)
- ✅ QG-STYLE-003: Mood described ("dramatic")
- ✅ QG-STYLE-004: Technique noted ("photorealistic digital rendering")

## Usage Notes

Style entities can be referenced in scene entities and asset generation prompts to ensure consistent visual aesthetics across generated content.
