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
5. **Generate images** from scenes using the MCP workflow below

## Image Generation Workflow

Generate images from scene entities using the Gemini MCP server integration.

### Prerequisites

1. **API Key**: Set `GEMINI_API_KEY` in `.env` file
2. **MCP Server**: Configured in `.vscode/mcp.json`
3. **DVC**: Initialized for asset tracking

### Step 1: Select Scene Entity

Choose a scene from `content/entities/scenes/`:

```yaml
# content/entities/scenes/hero-library-quest.md
---
name: hero-library-quest
type: scene
narrative: "The hero ventures into the ancient library..."
characters: ["hero-protagonist"]
environment: "ancient-library"
style: "cinematic-realism"
---
```

### Step 2: Construct Prompt

Combine scene narrative with referenced entity attributes:

```text
[Style art-direction]: [Scene narrative] in [Environment location].
[Character appearance]. [Scene mood] atmosphere. [Environment lighting].
[Style color-palette].
```

**Example**:

```text
Photorealistic cinematic style: A brave young adventurer with athletic
build, short brown hair stands before towering bookshelves in a vast
ancient library. Mysterious, determined atmosphere. Soft amber glow
from floating magical orbs. Rich naturalistic tones with dramatic shadows.
```

### Step 3: Generate Image via MCP

Use the `gemini-imagen` MCP server tool:

```text
@gemini-imagen generateImage with prompt="<constructed-prompt>" aspectRatio="1:1"
```

Or select an MCP config entity from `content/entities/mcp-configs/`:

- `gemini-imagen-default` - Square 1:1 format
- `gemini-imagen-cinematic` - Widescreen 16:9
- `gemini-imagen-portrait` - Vertical 9:16

### Step 4: Save and Track

1. Move generated image to `content/test/` with naming convention:

   ```
   <scene-name>-<version>-<timestamp>.png
   ```

2. Track with DVC:

   ```bash
   dvc add content/test/<image-file>.png
   git add content/test/<image-file>.png.dvc content/test/.gitignore
   ```

3. Create metadata YAML alongside image with generation parameters

### Example Output

```
content/test/
├── hero-library-quest-v1-20260124T180719Z.png        # Generated image
├── hero-library-quest-v1-20260124T180719Z.png.dvc    # DVC tracking
└── hero-library-quest-v1-20260124T180719Z-metadata.yaml  # Generation params
```

## Production Image Generation

Once you have scene entities, you can generate production-ready images with full DVC tracking.

### Prerequisites

- Scene entity created in `content/entities/scenes/`
- `.env` file with `GEMINI_API_KEY` configured
- MCP server running (automatically started by VS Code)
- DVC initialized (`dvc init` already done in Phase 5)

### Production Workflow

#### Step 1: Select Scene Entity

Choose an existing scene to generate from:

```bash
ls content/entities/scenes/
# hero-library-quest.md
# max-golden-morning.md
```

#### Step 2: Generate Image via Entity-Creator

Invoke the entity-creator agent to execute the generation workflow:

```text
@entity-creator Generate a production image from the scene "max-golden-morning"
and save it to content/images/ with proper DVC tracking.
```

The agent will:

1. Create workspace file documenting the generation plan
2. Read the scene entity and resolve dependencies
3. Construct prompt combining entity attributes
4. Invoke MCP server to generate image
5. Save image to `content/images/<scene>-<timestamp>.png`
6. Create metadata YAML with generation parameters
7. Track with DVC (`dvc add` automatically)
8. Create operation log in `logs/`

#### Step 3: Review Generated Assets

Check the output files:

```bash
# Image file (gitignored, DVC tracked)
ls -lh content/images/max-golden-morning-*.png

# DVC tracking file (committed to git)
cat content/images/max-golden-morning-*.png.dvc

# Metadata with generation params
cat content/images/max-golden-morning-*-metadata.yaml

# Operation log
cat logs/generate-max-golden-morning-*-operation.log
```

#### Step 4: Commit to Git

```bash
# Stage DVC tracking file and metadata
git add content/images/*.dvc content/images/*-metadata.yaml

# Stage operation log
git add logs/

# Commit
git commit -m "feat(assets): generate max-golden-morning production image"
```

### Generated Files Structure

```
content/images/
├── max-golden-morning-20260125T090658Z.png           # Image (1.1MB, DVC tracked)
├── max-golden-morning-20260125T090658Z.png.dvc       # DVC tracking (committed)
└── max-golden-morning-20260125T090658Z-metadata.yaml # Metadata (committed)

logs/
└── generate-max-golden-morning-20260125-090658-operation.log
```

### Metadata Structure

The metadata YAML includes all generation parameters:

```yaml
generated-at: "2026-01-25T09:06:58Z"
source-scene: "max-golden-morning"
scene-version: "v1"

entities:
  characters:
    - name: "max"
      version: "v2"
  environments:
    - name: "sunrise-meadow"
      version: "v1"
  styles:
    - name: "watercolor-dream"
      version: "v1"

generation-params:
  provider: "google-gemini"
  model: "gemini-2.0-flash-exp-image-generation"
  aspect-ratio: "1:1"
  quality: "high"
```

### DVC Tracking

Images are automatically tracked with DVC:

```bash
# Check DVC status
dvc status

# Push to DVC remote (if configured)
dvc push

# Pull images from DVC remote
dvc pull content/images/max-golden-morning-*.png.dvc
```

### Common Production Issues

#### Issue: "Image not saved to content/images/"

**Problem**: Image saved to workspace root or wrong directory.

**Solution**: Ensure MCP server `outputPath` parameter specifies full path: `content/images/<filename>.png`

#### Issue: "DVC tracking failed"

**Problem**: `.gitignore` blocks `.dvc` files or image directory.

**Solution**: Update `.gitignore`:

```gitignore
content/images/*          # Ignore all files
!content/images/*.dvc     # Except .dvc tracking files
!content/images/*.yaml    # Except metadata
```

#### Issue: "Entity references not found"

**Problem**: Scene references entities that don't exist.

**Solution**: Create missing entities first, or update scene to remove references.

### Example Production Generation

**Input**: Scene entity `max-golden-morning.md` with:

- Character: `max` (golden retriever)
- Environment: `sunrise-meadow` (park at dawn)
- Style: `watercolor-dream` (soft watercolor aesthetic)

**Output**: Watercolor image of Max chasing tennis ball at sunrise with:

- Soft pastel tones
- Gentle gradients
- Dreamy morning light
- 1024x1024 resolution
- Full DVC tracking

### MCP Configuration

The MCP server is configured in `.vscode/mcp.json`:

```json
{
  "servers": {
    "gemini-imagen": {
      "command": "node",
      "args": ["${workspaceFolder}/.mcp-servers/gemini-mcp-server/server.js"],
      "envFile": "${workspaceFolder}/.env"
    }
  }
}
```

Required environment variables in `.env`:

- `GEMINI_API_KEY` - Your Google AI API key
- `MODEL_NAME` - Image generation model (default: `gemini-2.0-flash-exp-image-generation`)

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
