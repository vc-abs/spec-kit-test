# Data Model: GenAI Asset Generation System

**Phase**: 1 - Design & Contracts
**Date**: 2026-01-05
**Purpose**: Define entity structures, relationships, and validation rules

## Overview

This system uses a **unified entity model** where everything is an entity. All entities stored as YAML front-matter + Markdown files. Entities form a dependency network (not hierarchy). Templates are entities. Process instructions (scripts) are entities. Output artifacts (videos, images) are entities with optional binary bodies. Relationships are implicit through dependency references in entity metadata.

**Key Principles**:
- Everything is an entity: templates, characters, scripts, videos, images, code, projects
- Dependencies form a network (cycles allowed for relationships)
- Entity-creator workflow reads templates, discovers dependencies JIT, creates all entity types
- Entities can be any type: definitions, assets, code files, entire projects

## Entity Definitions

### 1. Entity (Universal Structure)

**Purpose**: Universal structure for all entity types - templates, characters, scripts, videos, images, code, projects

**Storage**: `entities/<type>/<name>.md` (metadata) + optional `content/<name>.<ext>` (binary body)

**Entity Types**:
- **Template entities**: `entities/entity-template/<type>.template.md` (e.g., character.template.md)
- **Character entities**: `entities/character/<name>.md` (e.g., max.md)
- **Process entities**: `entities/script/<name>.md` (executable by entity-creator)
- **Output entities**: `entities/video/<name>.md` + `content/<name>.mp4` (metadata + binary)
- **Extensible**: Any type can be added by creating a template

**Structure**:
```yaml
---
name: string                  # Unique within type, kebab-case, alphanumeric + hyphens only
type: string                  # Entity type (character, script, video, image, entity-template, etc.)
description: string           # Brief summary
dependencies: array           # Optional: List of entity paths this entity depends on
visual_properties: object     # Optional: Flexible key-value pairs describing visual attributes
model_config: object          # Optional: Discriminated union for entities that generate outputs
creation_date: date          # ISO 8601 format
last_modified: date          # ISO 8601 format
---

[Markdown body with rich description, examples, usage notes, or process instructions]
```

**Validation Rules**:
- `name`: Required, must match filename, kebab-case, `^[a-z0-9]+(-[a-z0-9]+)*$`
- `type`: Required, string (extensible - not limited to enum)
- `dependencies`: Optional, array of entity paths (resolved JIT during creation)
- `model_config`: Optional (required only for entities that generate binary outputs)
- `visual_properties`: Optional, flexible schema
- `creation_date` / `last_modified`: ISO 8601 format, auto-generated

**Example (Character Entity)**:
```markdown
---
name: max
type: character
description: Friendly golden retriever with red collar
visual_properties:
  species: golden retriever
  accessories: red collar
  personality: playful, energetic
  color_palette:
    - warm golden
    - red
    - brown
model_config:
  provider: mcp
  server: dalle-mcp
  model: dall-e-3
creation_date: 2026-01-05
last_modified: 2026-01-05
---

# Max the Golden Retriever

Max is a friendly golden retriever with a vibrant red collar...
```

**Example (Video Entity with Dependencies)**:
```markdown
---
name: max-intro
type: video
description: Introduction video featuring Max
dependencies:
  - entities/character/max.md
  - entities/script/intro-script.md
model_config:
  provider: mcp
  server: runway-mcp
  model: gen-3-alpha
creation_date: 2026-01-05
last_modified: 2026-01-05
---

# Max Introduction Video

A 30-second introduction video showing Max playing in the park...

Binary output: content/max-intro.mp4
```

---

### 2. Model Config (Discriminated Union)

**Purpose**: Specify GenAI model provider and credentials for asset generation

**Type 1: MCP Provider**
```yaml
model_config:
  provider: mcp              # Discriminator field
  server: string             # MCP server name (resolves from .vscode/settings.json)
  model: string              # Model identifier (e.g., dall-e-3, stable-diffusion-xl)
  parameters: object         # Optional model-specific params (e.g., {style: vivid})
```

**Type 2: Direct API Provider**
```yaml
model_config:
  provider: direct-api       # Discriminator field
  endpoint: string           # Full API URL
  api_key: string            # Environment variable reference (e.g., ${OPENAI_API_KEY})
  model: string              # Model identifier
  parameters: object         # Optional model-specific params
```

**Validation Rules**:
- `provider`: Required, must be `mcp` or `direct-api`
- If `provider === mcp`: `server` and `model` required, `endpoint` and `api_key` invalid
- If `provider === direct-api`: `endpoint`, `api_key`, and `model` required, `server` invalid
- `api_key`: Must be env var reference format `${VAR_NAME}`, validated before generation
- `parameters`: Optional, flexible object

**Resolution Logic** (when multiple entities in single asset):
- Asset type determines model (first entity's model_config or agent default)
- Entity model preferences are informational only

---

### 3. Asset (Binary File)

**Purpose**: Generated image, video, or other binary content

**Storage**: `content/<asset-name>.<ext>` (production) or `content/test/<asset-name>.<ext>` (P1 validation)

**Naming Pattern**: `<feature>-<description>.<asset-type>.<ext>`
- `feature`: Feature identifier (e.g., `001-genai-asset-system`)
- `description`: Kebab-case descriptive name
- `asset-type`: `greeting-card | informative-image | sprite-sheet | video | insta-post` (examples, extensible)
- `ext`: File extension (`.png`, `.mp4`, etc.)

**Example**: `001-genai-asset-system-max-card.greeting-card.png`

**Batch Naming**: Append descriptive suffix (e.g., `-bright`, `-watercolor-style`) or sequential (`-v1`, `-v2`)

**DVC Tracking**: Each asset has corresponding `.dvc` file (e.g., `001-genai-asset-system-max-card.greeting-card.png.dvc`)

**Validation Rules**:
- Name must match pattern `^[a-z0-9]+(-[a-z0-9]+)*\.[a-z0-9-]+\.[a-z0-9]+$`
- Must have corresponding `.meta.yaml` file
- Must be tracked by DVC (`.dvc` file exists)

---

### 4. Asset Metadata (YAML File)

**Purpose**: Capture generation parameters for reproducibility and audit

**Storage**: `content/<asset-name>.meta.yaml` (git-tracked, NOT in DVC)

**Structure**:
```yaml
asset_name: string            # Matches asset filename (without extension)
asset_type: string            # greeting-card, informative-image, etc.
generation_timestamp: datetime # ISO 8601
generation_prompt: string     # Exact Copilot prompt used
model_name: string            # Model used (e.g., dall-e-3)
model_version: string         # Model version if available
entity_references:            # List of entity file paths
  - string                    # e.g., entities/character/max.md
generation_parameters:        # Model-specific params used
  resolution: string          # e.g., "1024x1024"
  style: string               # e.g., "vivid"
  [other params]
file_format: string           # e.g., png, mp4
dvc_hash: string              # DVC content hash for version tracking
log_file: string              # Path to generation log (e.g., logs/asset-name.log)
```

**Validation Rules**:
- `asset_name`: Required, must match corresponding asset file
- `generation_timestamp`: ISO 8601 format
- `entity_references`: Array of valid entity paths (Copilot validates existence)
- `generation_parameters`: Flexible object, must include `resolution` for images/videos
- `dvc_hash`: Auto-populated from DVC tracking

**Example**:
```yaml
asset_name: 001-genai-asset-system-max-card.greeting-card
asset_type: greeting-card
generation_timestamp: 2026-01-05T14:30:22Z
generation_prompt: "Generate a greeting card with @entities/character/max.md and @entities/style/watercolor.md"
model_name: dall-e-3
model_version: "2024-11"
entity_references:
  - entities/character/max.md
  - entities/style/watercolor.md
generation_parameters:
  resolution: "1024x1024"
  style: vivid
  quality: standard
file_format: png
dvc_hash: a3f7e2b8c9d4f1a6e5b3c2d1f0a9b8c7
log_file: logs/001-genai-asset-system-max-card.greeting-card.log
```

---

### 5. Generation Log (Text File)

**Purpose**: Capture all generation attempts, errors, and API interactions for debugging

**Storage**: `logs/<asset-name>.log` (git-tracked plain text)

**Format**: Plain text with timestamps, one entry per generation attempt

**Structure**:
```
[2026-01-05T14:30:00Z] INFO: Starting asset generation
[2026-01-05T14:30:01Z] INFO: Validated entity references: entities/character/max.md, entities/style/watercolor.md
[2026-01-05T14:30:02Z] INFO: Resolved model config: provider=mcp, server=dalle-mcp, model=dall-e-3
[2026-01-05T14:30:03Z] INFO: Sending prompt to GenAI API: "..."
[2026-01-05T14:30:45Z] INFO: Received response, size: 2.3MB
[2026-01-05T14:30:46Z] INFO: Validating resolution: expected 1024x1024, got 1024x1024 ✓
[2026-01-05T14:30:47Z] INFO: Validating format: expected png, got png ✓
[2026-01-05T14:30:48Z] INFO: Saved asset to content/001-genai-asset-system-max-card.greeting-card.png
[2026-01-05T14:30:49Z] INFO: Executing DVC tracking: dvc add content/001-genai-asset-system-max-card.greeting-card.png
[2026-01-05T14:30:50Z] INFO: Committing to git: feat(asset): add greeting-card with max, watercolor
[2026-01-05T14:30:51Z] INFO: Generation complete
```

**Failure Example**:
```
[2026-01-05T15:00:00Z] INFO: Starting asset generation
[2026-01-05T15:00:01Z] ERROR: Environment variable ${OPENAI_API_KEY} is undefined
[2026-01-05T15:00:01Z] ERROR: Generation failed - check .env file
```

---

### 6. MCP Server Config (VS Code Settings)

**Purpose**: Centralized configuration for MCP server endpoints

**Storage**: `.vscode/settings.json` (version-controlled)

**Structure** (within settings.json):
```json
{
  "genai.mcp.servers": {
    "dalle-mcp": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-dalle"],
      "env": {
        "OPENAI_API_KEY": "${env:OPENAI_API_KEY}"
      }
    },
    "stable-diffusion-mcp": {
      "type": "http",
      "endpoint": "http://localhost:7860",
      "auth": {
        "type": "bearer",
        "token": "${env:SD_API_TOKEN}"
      }
    }
  }
}
```

**Validation Rules**:
- Server names must be valid identifiers (referenced in entity model_config)
- Environment variable references resolved from `.env` file
- This file is version-controlled, actual secrets in `.env` (gitignored)

---

## Relationships

```
Entity Template (entities/type/name.md)
  ├── References: MCP Server Config (.vscode/settings.json) via model_config.server
  ├── References: Environment Variables (.env) via model_config.api_key
  └── Referenced By: Asset Metadata (content/*.meta.yaml) via entity_references[]

Asset (content/*.png|mp4|...)
  ├── Has One: Asset Metadata (content/*.meta.yaml) - same base name
  ├── Has One: DVC Metadata (content/*.dvc) - DVC tracking
  └── Has One: Generation Log (logs/*.log) - same base name

Asset Metadata
  └── References: Entity Template(s) via entity_references[] paths
```

## State Transitions

**Entity Template**: Draft → Published (manual file creation, no formal state)

**Asset**:
1. **Pre-Generation**: Name validated, entities validated, model resolved
2. **Generating**: API call in progress, logging to per-asset log
3. **Validation**: Format/resolution checks
4. **DVC Tracking**: `dvc add` execution
5. **Committed**: Git commit with metadata and .dvc file

**Error States** (Fail-Fast):
- Filename conflict → Abort, prompt user
- Missing env var → Abort, show config error
- API rate limit → Abort, log error with retry guidance
- DVC/Git failure → Abort, require manual cleanup

---

## Validation Summary

| Entity          | Key Validations                                                |
| --------------- | -------------------------------------------------------------- |
| Entity Template | Name kebab-case, type enum, model_config discriminated union   |
| Model Config    | Provider-specific fields, env var format, MCP server existence |
| Asset           | Naming pattern, DVC tracking, metadata file existence          |
| Asset Metadata  | Entity paths exist, timestamp format, required fields          |
| Generation Log  | Per-asset log file, plain text format                          |

All validations performed by Copilot agents before generation/commit.
