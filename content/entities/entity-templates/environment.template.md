---
name: environment
type: entity-template
description: "Template for defining location and setting entities"
version: v1
---

# Environment Entity Template

## Purpose

Defines the structure and validation rules for environment entities that specify locations, settings, atmospheres, and spatial contexts for asset generation.

## Required Fields

### Core Fields

- **name** (string): Unique identifier for the environment (kebab-case)
- **type** (string): Must be "environment"
- **description** (string): Brief summary of the environment
- **version** (string): Version identifier (e.g., v1, v2)

### Environment-Specific Fields

- **location** (string): Primary setting or place (e.g., "ancient library", "neon-lit city street", "mountain summit")
- **atmosphere** (string): Overall environmental quality (e.g., "mystical and quiet", "bustling and energetic", "desolate and windswept")
- **time** (string): Time of day or period (e.g., "golden hour sunset", "midnight", "early morning", "timeless")

## Optional Fields

- **lighting** (string): Natural or artificial lighting conditions (e.g., "soft ambient", "harsh fluorescent", "candlelit")
- **weather** (string): Weather conditions if applicable (e.g., "clear", "stormy", "foggy", "snowy")
- **scale** (string): Spatial scope (e.g., "intimate interior", "vast landscape", "urban district")
- **cultural_context** (string): Historical or cultural setting (e.g., "Victorian England", "futuristic megacity", "medieval fantasy")
- **tags** (array[string]): Additional categorization tags

## Validation Rules

### VR-ENV-001: Name Format

- Name must use kebab-case (lowercase with hyphens)
- Only alphanumeric characters and hyphens allowed
- Must be unique within environments directory

### VR-ENV-002: Required Field Presence

- All core fields and environment-specific required fields must be present
- Empty strings not allowed for required fields

### VR-ENV-003: Time Format

- Time field should be descriptive and contextual
- Avoid overly technical or numeric formats

## Quality Gates

### QG-ENV-001: Location Clearly Defined (critical)

- **Check**: location field is non-empty and descriptive
- **Fix**: Provide specific place or setting description
- **Why**: Location anchors the environmental context

### QG-ENV-002: Atmosphere Described (critical)

- **Check**: atmosphere field is non-empty
- **Fix**: Define the environmental quality and mood
- **Why**: Atmosphere conveys sensory and emotional characteristics

### QG-ENV-003: Lighting Conditions Specified (warning)

- **Check**: lighting field is present and non-empty
- **Fix**: Describe natural or artificial light sources
- **Why**: Lighting significantly affects visual rendering

### QG-ENV-004: Time Period/Context Provided (warning)

- **Check**: time field is non-empty and contextual
- **Fix**: Specify time of day, season, or temporal context
- **Why**: Time helps establish mood and lighting conditions

## Self-Validation Example

```yaml
---
name: ancient-library
type: environment
description: "Vast library filled with towering bookshelves and dim ambient light"
version: v1
location: "ancient library interior"
atmosphere: "mystical and quiet"
time: "perpetual twilight"
lighting: "soft amber glow from floating orbs"
scale: "cathedral-like interior"
cultural_context: "fantasy realm of forgotten knowledge"
tags: ["library", "fantasy", "interior", "mystical"]
---

A vast repository of knowledge with endless rows of weathered tomes, illuminated by
magical floating orbs that cast warm amber light across dusty wooden floors and
stone pillars.
```

**Validation Results**:

- ✅ QG-ENV-001: Location clearly defined ("ancient library interior")
- ✅ QG-ENV-002: Atmosphere described ("mystical and quiet")
- ✅ QG-ENV-003: Lighting specified ("soft amber glow from floating orbs")
- ✅ QG-ENV-004: Time context provided ("perpetual twilight")

## Usage Notes

Environment entities establish the spatial and atmospheric context for scenes and asset generation, providing the foundational setting in which characters and events occur.
