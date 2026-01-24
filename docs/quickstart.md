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

## Scene Generation Workflow

Scenes are the composition layer that brings together characters, environments, and styles into narrative contexts. They serve as the primary input for image generation workflows.

### Creating Scenes with Entity-Creator

#### Step 1: Identify Entity Dependencies

Before creating a scene, identify which entities you want to compose:

- **Characters**: Who appears in the scene? (e.g., `hero-protagonist`, `max`)
- **Environment**: Where does the scene take place? (e.g., `ancient-library`, `neon-city`)
- **Style**: What visual treatment should be applied? (e.g., `cinematic-realism`, `watercolor-dream`)

All entity references are **optional** - scenes can be standalone or reference existing entities.

#### Step 2: Craft the Scene Prompt

Use the entity-creator agent with a descriptive prompt:

**Example 1: Scene with Entity References**

```text
@entity-creator Create a scene called "hero-library-quest" where the hero-protagonist
explores the ancient-library seeking legendary knowledge. Use cinematic-realism style
for dramatic lighting. The hero searches through towering shelves of dusty tomes,
looking for a legendary artifact mentioned in ancient prophecies.
```

**Example 2: Standalone Scene (No References)**

```text
@entity-creator Create a scene called "sunset-meditation" with a peaceful setting where
a figure meditates on a mountaintop at golden hour. The mood is serene and contemplative,
with warm orange and purple skies.
```

#### Step 3: Review Generated Scene

The entity-creator agent will:

1. Create workspace file for review
2. Resolve entity dependencies (verify referenced entities exist)
3. Generate scene file with YAML front-matter + Markdown narrative
4. Log operation to `logs/create-scene-<name>-operation.log`

**Generated Scene Structure**:

```yaml
---
name: hero-library-quest
type: scene
description: "Brave hero explores ancient library seeking legendary knowledge"
version: v1
narrative: "The hero ventures deep into the ancient library..."
setting: "Deep within the ancient library's oldest wing..."
mood: "mysterious, determined, awe-inspiring"
characters: ["hero-protagonist"]
environment: "ancient-library"
style: "cinematic-realism"
---

Detailed narrative description in Markdown...
```

#### Step 4: Validate Scene Quality

Check the created scene against quality gates:

- ✅ **QG-SCENE-001**: Narrative defined and descriptive
- ✅ **QG-SCENE-002**: Setting established (where/when)
- ✅ **QG-SCENE-003**: Mood conveyed (emotional tone)
- ✅ **QG-SCENE-004**: Entity references valid (if present)

#### Step 5: Use Scene for Asset Generation

Once validated, the scene entity can be used as input for:

- **Image generation** (Phase 5+)
- **Video generation** (future)
- **Animation sequences** (future)
- **Asset variations** (multiple renders from same scene)

### Scene Composition Patterns

#### Pattern 1: Full Composition (All References)

```yaml
characters: ["hero-protagonist", "wise-mentor"]
environment: "ancient-library"
style: "cinematic-realism"
```

**Use when**: You want maximum consistency with existing entity definitions.

#### Pattern 2: Partial Composition (Some References)

```yaml
characters: ["max"]
style: "watercolor-dream"
# No environment reference - described in setting field
```

**Use when**: You want flexibility while maintaining some consistency.

#### Pattern 3: Standalone (No References)

```yaml
# No entity references
# All context in narrative, setting, and mood fields
```

**Use when**: Creating one-off scenes or rapid prototyping.

### Common Scene Generation Issues

#### Issue: "Referenced entity not found"

**Problem**: Scene references an entity that doesn't exist.

**Solution**:

1. Check entity exists: `ls content/entities/characters/<name>.md`
2. Verify spelling matches exactly (case-sensitive)
3. Create missing entity first, then retry scene

#### Issue: "Narrative too vague"

**Problem**: Scene description lacks specificity for asset generation.

**Solution**:

- Add concrete details: lighting, positioning, actions
- Specify mood and emotional tone
- Include visual elements: colors, textures, atmosphere

#### Issue: "Entity references don't match setting"

**Problem**: Referenced entities contradict scene description.

**Solution**:

- Review referenced entity descriptions
- Ensure setting is compatible (e.g., don't put medieval character in cyberpunk environment)
- Update scene narrative to resolve conflicts

### Example Scenes

#### Example 1: Hero Library Quest

```yaml
---
name: hero-library-quest
type: scene
description: "Brave hero explores ancient library seeking legendary knowledge"
version: v1
narrative: "The hero-protagonist ventures deep into the ancient library, searching through towering shelves"
setting: "Deep within the ancient library's oldest wing"
mood: "mysterious, determined, awe-inspiring"
characters: ["hero-protagonist"]
environment: "ancient-library"
style: "cinematic-realism"
---
```

**Pattern**: Full composition with all entity types referenced.

#### Example 2: Max's Golden Morning

```yaml
---
name: max-golden-morning
type: scene
description: "Max enjoys a joyful morning run through the park"
version: v1
narrative: "Max bounds across the dewy grass with unbridled enthusiasm"
setting: "Neighborhood park at sunrise"
mood: "joyful, energetic, warm"
characters: ["max"]
style: "watercolor-dream"
---
```

**Pattern**: Partial composition with character and style, environment described in setting.

### Scene Template Reference

For complete field specifications and validation rules, see:

- **Template**: [scene.template.md](../content/entities/entity-templates/scene.template.md)
- **Validation Rules**: VR-SCENE-001 through VR-SCENE-003
- **Quality Gates**: QG-SCENE-001 through QG-SCENE-004

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
│   ├── wise-mentor.md
│   ├── max.md
│   ├── rex.md
│   ├── luna.md
│   └── buddy.md
├── scenes/               # Scene entities
│   ├── hero-library-quest.md
│   ├── max-golden-morning.md
│   └── park-morning.md
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
