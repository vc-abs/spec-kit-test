# Quickstart Guide: GenAI Asset Generation System

**Version**: 1.0
**Date**: 2026-01-05
**Prerequisites**: VS Code, GitHub Copilot, Git, DVC CLI

## Overview

This system uses a **unified entity model** where everything is an entity (templates, characters, scripts, videos, images). Entities form a dependency network. The entity-creator workflow reads templates, discovers dependencies just-in-time, and creates all entity types. Assets are version-controlled with DVC for binaries and git for metadata.

**Key Concepts**:
- Everything is an entity with optional dependencies
- Templates use dot notation: `character.template.md`
- Entity-creator fills gaps in underspecified entities
- Dependencies discovered JIT from templates, entities, prompts, or tacit context

## Setup Steps

### 1. Validate Prerequisites

**Manual check** (automation scripts to be created in Phase 2):

- Git 2.x+ installed: `git --version`
- DVC 3.x+ installed: `dvc --version`
- VS Code installed
- GitHub Copilot extension installed

If any checks fail, install missing tools before proceeding.

---

### 2. Initialize Workspace

**Manual setup** (automation script to be created in Phase 2):

Create directory structure:

```bash
mkdir -p entities/{character,script,video,image,entity-template}
mkdir -p content content/test logs .github/agents
```

Initialize DVC:

```bash
dvc init
# For local development:
dvc remote add -d local /tmp/dvc-storage
```

**For production**: Edit `.dvc/config` to change remote storage (S3/Azure/GCS). See [DVC remote documentation](https://dvc.org/doc/command-reference/remote).

---

### 3. Configure API Credentials

Create `.env` file in repository root with your API keys:

```bash
# Example .env structure (gitignored)
OPENAI_API_KEY=sk-your-key-here
STABILITY_API_KEY=sk-your-key-here
RUNWAY_API_KEY=your-key-here
```

**Security**: `.env` is gitignored - never commit API keys.

---

### 4. Configure MCP Servers (Optional)

Edit `.vscode/settings.json` to add MCP server configurations. See [data-model.md](data-model.md#6-mcp-server-config-vs-code-settings) for examples.

**Commit settings** (no secrets):
```bash
git add .vscode/settings.json
git commit -m "feat(config): add MCP server configurations"
```

---

### 5. Create Bootstrap Template

**Manual creation** (automation script to be created in Phase 2):

Create the master meta-template manually at `entities/entity-template/entity-template.template.md`.

See [data-model.md](data-model.md) for structure and examples.

**Commit** the bootstrap template:

```bash
git add entities/entity-template/entity-template.template.md
git commit -m "feat(bootstrap): add entity-template meta-template"
```

---

### 6. Run P2 Validation (MCP Connectivity Test)

**In VS Code with Copilot**:
```
@workspace /validate-mcp
```

**Tests**: MCP connectivity for all asset types (greeting-card, image, sprite-sheet, video)

**On failure**: Verify API keys in `.env` and MCP server configs in `.vscode/settings.json`

---

## First Entity Creation

### Step 1: Create a Character Template

**Using entity-creator workflow**:

```
@workspace /entity-creator

Create a character.template.md using the entity-template.template.md bootstrap.
```

**Entity-creator will**:
- Read entity-template.template.md
- Prompt for template schema fields
- Create entities/entity-template/character.template.md

---

### Step 2: Create a Character Entity

**Using entity-creator workflow**:

```
@workspace /create-entity

Create a character entity named "max" - a friendly golden retriever with a red collar.
Use DALL-E via MCP server.
```

**Agent will prompt for details**:
- Visual properties (species, color, personality)
- Model config (MCP server name or direct API)

**Result**: `entities/character/max.md` created

**Example Entity File**:
```markdown
---
name: max
type: character
description: Friendly golden retriever with red collar
visual_properties:
  species: golden retriever
  coat_color: warm golden
  accessories: red collar
  personality: playful, energetic
  expression: happy, tongue out
model_config:
  provider: mcp
  server: dalle-mcp
  model: dall-e-3
creation_date: 2026-01-05T14:00:00Z
last_modified: 2026-01-05T14:00:00Z
---

# Max the Golden Retriever

Max is a friendly golden retriever with a vibrant red collar. He loves to play fetch
and has an infectious enthusiasm that brings joy to everyone around him. His fur is
a warm golden color, and his eyes sparkle with curiosity.

## Visual Style Notes
- Rounded, soft edges for friendly appearance
- Expressive eyes with highlights
- Dynamic poses showing movement and energy
```

---

### Step 3: Generate a Video Asset

**Using entity-creator workflow with dependencies**:

```
@workspace /entity-creator

Create a video entity named "max-intro" - a 30-second introduction featuring Max.
Dependencies: character/max, script/intro-script
```

**Entity-creator will**:
- Check if dependencies exist (character/max ✓, script/intro-script ✗)
- Prompt to create script/intro-script first (or use existing)
- Resolve dependencies just-in-time
- Generate video using resolved dependencies
- Create metadata: `entities/video/max-intro.md`
- Generate binary: `content/max-intro.mp4` (via video GenAI model)
- Track with DVC
- Create generation log: `logs/max-intro.log`

---

## Common Workflows

### Viewing Asset Metadata

```bash
# View metadata for an asset
cat content/001-genai-asset-system-max-birthday-card.greeting-card.meta.yaml
```

**Example Output**:
```yaml
asset_name: max-intro
asset_type: video
generation_timestamp: 2026-01-05T14:30:22Z
generation_prompt: "Create a 30-second introduction featuring Max"
model_name: gen-3-alpha
model_version: "1.0"
entity_references:
  - entities/character/max.md
  - entities/script/intro-script.md
generation_parameters:
  duration: 30
  resolution: "1920x1080"
  fps: 30
file_format: mp4
dvc_hash: b4f8e3c9d0f2a7e6b5c3d2f1a0b9c8d7
log_file: logs/max-intro.log
```

---

### Viewing Generation Logs

```bash
# View generation log for debugging
cat logs/max-intro.log
```

**Shows**:
- Dependency resolution steps
- API calls and responses
- Validation checks
- DVC tracking commands
- Any errors or warnings

---

### Checking DVC Status

```bash
# See which assets are tracked
dvc list . content/

# Check DVC remote sync status
dvc status

# Push assets to remote storage
dvc push

# Pull assets from remote storage (on different machine)
dvc pull
```

### Browsing Assets in VS Code

1. Open VS Code File Explorer
2. Navigate to `content/` directory
3. Use file search (Ctrl+P) to filter:
   - `*.greeting-card.png` - All greeting cards
   - `*.meta.yaml` - All metadata files
4. Preview images directly in VS Code

---

## Troubleshooting

### Error: "Environment variable ${OPENAI_API_KEY} is undefined"

**Solution**: Add the variable to `.env` file:
```bash
echo "OPENAI_API_KEY=sk-your-key-here" >> .env
```

### Error: "MCP server 'dalle-mcp' not configured"

**Solution**: Add server to `.vscode/settings.json` (see Step 4 above)

### Error: "DVC tracking failed"

**Solution**: Verify DVC remote is configured and accessible:
```bash
dvc remote list
dvc status
```

### Error: "Filename conflict detected"

**Solution**: Asset with that name already exists. Choose different name, delete old asset, or use batch naming with suffixes.

### Error: "GenAI API rate limit: retry after 60s"

**Solution**: Wait 60 seconds and retry. Check API quota/billing if persistent.

---

## Next Steps

1. **Create More Entities**: Define styles, environments for rich asset variations
2. **Experiment with Batches**: Generate variations with different parameters
3. **Organize Assets**: Use consistent naming and metadata for easy discovery
4. **Set Up CI/CD**: Automate DVC push on commits for team collaboration
5. **Explore Asset Types**: Try sprite-sheets, videos, informative images

## Resources

- [DVC Documentation](https://dvc.org/doc)
- [GitHub Copilot Workspace](https://docs.github.com/copilot)
- [MCP Specification](https://modelcontextprotocol.io)
- [Entity Template Examples](entities/entity-template/)

---

**Ready to generate!** Use Copilot prompts with `@workspace`, `@entities/<type>/<name>.md` references, and agent commands to create assets.
