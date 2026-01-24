# GenAI Asset System - Quick Start Guide

This guide explains how to create and manage entities for the GenAI Asset Generation System.

## Overview

The GenAI Asset System uses a structured entity approach where you define characters, scenes, styles, and environments as reusable components. These entities can be composed together to generate consistent AI-powered assets.

## Entity Types

### Characters

Characters define personalities, appearances, and backgrounds for people, creatures, or beings in your generated assets.

**Example**: Create a character entity

```yaml
---
name: hero-protagonist
type: character
description: "Brave young adventurer ready to face any challenge"
version: v1
species: human
personality: "courageous, determined, optimistic"
appearance: "athletic build, short brown hair, bright eyes"
---

A determined hero embarking on their first major quest.
```

**Location**: `content/entities/characters/`

**Template**: See [character.template.md](../content/entities/entity-templates/character.template.md)

### Styles

Styles define visual aesthetics including art direction, color palettes, and mood for generated assets.

**Example**: Create a style entity

```yaml
---
name: cinematic-realism
type: style
description: "Photorealistic with dramatic lighting"
version: v1
art_direction: "photorealistic with cinematic framing"
color_palette: "rich naturalistic tones"
mood: "epic, immersive"
---

Photorealistic detail with dramatic cinematography.
```

**Location**: `content/entities/styles/`

**Template**: See [style.template.md](../content/entities/entity-templates/style.template.md)

### Environments

Environments define locations, settings, atmospheres, and spatial contexts.

**Example**: Create an environment entity

```yaml
---
name: ancient-library
type: environment
description: "Vast library with dim ambient light"
version: v1
location: "ancient library interior"
atmosphere: "mystical and quiet"
time: "perpetual twilight"
---

A repository of forgotten knowledge.
```

**Location**: `content/entities/environments/`

**Template**: See [environment.template.md](../content/entities/entity-templates/environment.template.md)

### Scenes

Scenes describe narrative moments, combining optional references to characters, environments, and styles.

**Example**: Create a standalone scene

```yaml
---
name: morning-walk
type: scene
description: "Peaceful walk through a quiet park"
version: v1
narrative: "A solitary figure walks along a tree-lined path"
setting: "urban park at dawn"
mood: "peaceful, contemplative"
---

The first light filters through tree canopy.
```

**Example**: Create a scene with entity references

```yaml
---
name: hero-library-quest
type: scene
description: "Hero explores the ancient library seeking knowledge"
version: v1
narrative: "The hero searches through dusty tomes for a legendary artifact"
setting: "deep within the ancient library"
mood: "tense, mysterious"
characters: ["hero-protagonist"]
environment: "ancient-library"
style: "cinematic-realism"
---

Dramatic search through towering shelves of ancient books.
```

**Location**: `content/entities/scenes/`

**Template**: See [scene.template.md](../content/entities/entity-templates/scene.template.md)

## Using the Entity Creator Agent

### Prerequisites

The entity-creator agent requires:

- Valid entity templates in `content/entities/entity-templates/`
- Workspace directory structure: `content/entities/{characters,scenes,styles,environments}/`

### Basic Workflow

1. **Choose an entity type**: character, scene, style, or environment
2. **Prepare your entity definition**: Use the appropriate template as a guide
3. **Invoke the entity-creator agent** with your entity data
4. **Validate the created entity**: Check for quality gate warnings or errors

### Entity Validation

All entities are validated against their templates with quality gates:

- **Critical gates**: Must pass or entity creation aborts
- **Warning gates**: Log issues but allow creation (lenient mode)
- **Info gates**: Optional best practices

Common quality gates:

- **Name format**: Must use kebab-case (e.g., `hero-protagonist`)
- **Required fields**: All mandatory fields must be present
- **Field formats**: Species, time, location must follow expected patterns

### Versioning

Entities use simple integer versioning:

- Initial version: `v1`
- Updates: `v2`, `v3`, etc.
- Version incremented automatically on updates

### Entity References

Scenes can reference other entities by name:

```yaml
characters: ["hero-protagonist", "wise-mentor"]
environment: "ancient-library"
style: "cinematic-realism"
```

References are validated to ensure referenced entities exist.

## Directory Structure

```
content/entities/
├── entity-templates/     # Template definitions
│   ├── character.template.md
│   ├── scene.template.md
│   ├── style.template.md
│   └── environment.template.md
├── characters/           # Character entities
│   ├── hero-protagonist.md
│   └── wise-mentor.md
├── scenes/               # Scene entities
│   └── morning-walk.md
├── styles/               # Style entities
│   ├── cinematic-realism.md
│   └── watercolor-dream.md
└── environments/         # Environment entities
    ├── ancient-library.md
    └── neon-city.md
```

## Next Steps

1. **Explore example entities** in `content/entities/{characters,scenes,styles,environments}/`
2. **Review templates** for complete field references and validation rules
3. **Create your first entity** using the entity-creator agent
4. **Compose scenes** by combining characters, environments, and styles

## Additional Resources

- **Entity Templates**: `content/entities/entity-templates/`
- **Agent Documentation**: `.github/agents/entity-creator.agent.md`
- **Data Model**: `specs/001-genai-asset-system/data-model.md`
- **Full Specification**: `specs/001-genai-asset-system/spec.md`

## Troubleshooting

### "Name format validation failed"

- Use kebab-case only: lowercase with hyphens
- Example: `my-character` not `My Character` or `my_character`

### "Required field missing"

- Check the template for required fields
- All core fields (name, type, description, version) are mandatory
- Each entity type has additional required fields

### "Referenced entity not found"

- Verify the referenced entity exists in its directory
- Check spelling and case (must match exactly)
- Ensure you're using the entity name, not the filename

### "Quality gate critical failure"

- Review the specific quality gate error message
- Consult the template for fix guidance
- Critical failures prevent entity creation
