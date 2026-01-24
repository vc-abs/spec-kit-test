---
name: asset-generation
type: prompt-template
description: "Prompt template for generating images from scene entities using GenAI models"
version: v1
---

# Asset Generation Prompt Template

## Purpose

This template guides Copilot in generating images from scene entities using configured MCP servers or direct API calls. It defines the workflow for reading scene context, constructing generation prompts, invoking GenAI models, and tracking results with DVC.

## Workflow Steps

### Step 1: Read Scene Entity

Load the scene entity file to extract:

- **narrative**: Core story/action happening in the scene
- **setting**: Location and time context
- **mood**: Emotional tone and atmosphere
- **model_config**: Generation parameters (MCP server, model, settings)
- Referenced entities (characters, environment, style)

### Step 2: Resolve Entity Dependencies

If scene references other entities, read them to gather context:

- **Characters**: Appearance, personality, distinctive features
- **Environment**: Location details, atmosphere, lighting
- **Style**: Art direction, color palette, visual treatment

### Step 3: Construct Generation Prompt

Combine scene narrative with entity context into a detailed prompt:

```
[Style art direction]: [Scene narrative] in [Environment location]
with [Character appearance]. [Scene mood] atmosphere.
[Environment lighting]. [Style color palette].
```

**Example**:

```
Cinematic photorealistic style: A brave young adventurer with athletic build
and bright eyes searches through towering shelves of ancient books in a vast
library interior. Mysterious and determined atmosphere. Soft amber glow from
floating magical orbs. Rich naturalistic tones with dramatic shadows.
```

### Step 4: Extract Model Configuration

From `model_config` field, determine:

- **Generation method**: MCP server or direct API
- **Model**: Specific model name (imagen-3.0-generate-001, dall-e-3, etc.)
- **Parameters**: Aspect ratio, quality, safety filters

### Step 5: Generate Image

#### Using MCP Server (Preferred)

```text
@<mcp-server> Generate an image with the following prompt:

<detailed-prompt-from-step-3>

Parameters:
- Aspect ratio: <from-model_config>
- Quality: <from-model_config>
- Safety filter: <from-model_config>
```

#### Using Direct API (Alternative)

Execute API call using environment variables from `.env`:

```python
import os
from google.generativeai import ImageGenerationModel

api_key = os.getenv('GOOGLE_API_KEY')
model = ImageGenerationModel(model_name='imagen-3.0-generate-001', api_key=api_key)

response = model.generate(
    prompt=detailed_prompt,
    aspect_ratio='1:1',
    quality='high'
)

image_path = f'content/test/{scene_name}-{timestamp}.png'
response.images[0].save(image_path)
```

### Step 6: Save Generated Image

Save image to appropriate location:

- **Test images**: `content/test/`
- **Production images**: `content/images/`

Naming convention: `<scene-name>-<version>-<timestamp>.png`

Example: `hero-library-quest-v1-20260124T213045.png`

### Step 7: Create Image Metadata

Create YAML metadata file alongside image:

```yaml
---
name: hero-library-quest-v1-20260124T213045
type: generated-image
version: v1
generated_at: 2026-01-24T21:30:45Z
source_scene: hero-library-quest
source_scene_version: v1
model:
  provider: google
  model: imagen-3.0-generate-001
  method: mcp
  server: gemini-imagen
generation_params:
  aspect_ratio: "1:1"
  quality: high
  safety_filter: medium
  prompt_enhancement: true
prompt: |
  Cinematic photorealistic style: A brave young adventurer with athletic
  build searches through towering shelves of ancient books in a vast library
  interior. Mysterious and determined atmosphere. Soft amber glow from
  floating magical orbs.
referenced_entities:
  characters:
    - name: hero-protagonist
      version: v1
  environments:
    - name: ancient-library
      version: v1
  styles:
    - name: cinematic-realism
      version: v1
file:
  path: content/test/hero-library-quest-v1-20260124T213045.png
  size_bytes: 245678
  format: png
  dimensions:
    width: 1024
    height: 1024
---

Test image generated from hero-library-quest scene entity demonstrating
Gemini Imagen integration with MCP server.
```

### Step 8: Track with DVC

Add image to DVC tracking:

```bash
dvc add content/test/hero-library-quest-v1-20260124T213045.png
git add content/test/hero-library-quest-v1-20260124T213045.png.dvc
git add content/test/hero-library-quest-v1-20260124T213045-metadata.yaml
```

### Step 9: Create Operation Log

Log the generation operation in YAML format:

```yaml
- operation_id: generate-image-hero-library-quest-001
  timestamp: 2026-01-24T21:30:45Z
  operation_type: generate-image
  scene_entity: hero-library-quest@v1
  model_config:
    provider: google
    model: imagen-3.0-generate-001
    method: mcp
    server: gemini-imagen
  assets_created:
    - path: content/test/hero-library-quest-v1-20260124T213045.png
      size: 245678
      format: png
      dvc_tracked: true
  status: success
  duration_seconds: 12.3
  cost_usd: 0.04
```

## Prompt Construction Best Practices

### 1. Be Specific and Detailed

❌ **Vague**: "A person in a library"

✅ **Specific**: "A young athletic adventurer with bright eyes and determined expression, standing before a towering bookshelf filled with ancient leather-bound tomes in a vast cathedral-like library"

### 2. Include Visual Style Elements

Always incorporate:

- **Art direction** from style entity (photorealistic, watercolor, anime, etc.)
- **Color palette** guidance (warm tones, cool blues, dramatic shadows)
- **Lighting** description (soft ambient, harsh directional, magical glow)
- **Mood** keywords (mysterious, joyful, ominous, serene)

### 3. Maintain Consistency with Referenced Entities

If scene references entities, ensure prompt reflects their characteristics:

- Character appearance details must match character entity
- Environment description must align with environment entity
- Style treatment must follow style entity guidelines

### 4. Use Narrative Context

Transform scene narrative into visual description:

- Action/moment → pose and composition
- Emotion/mood → facial expression and body language
- Setting → environmental details and atmosphere

### 5. Specify Technical Requirements

Include model-specific technical details:

- Aspect ratio (1:1 for square, 16:9 for landscape, 9:16 for portrait)
- Quality level (standard, high, premium)
- Safety/content filtering preferences

## Error Handling

### API Errors

- **Rate limiting**: Wait and retry with exponential backoff
- **Invalid API key**: Check `.env` file and environment variables
- **Content policy violation**: Review and refine prompt for safety

### MCP Server Errors

- **Server not responding**: Check MCP server configuration in `.vscode/settings.json`
- **Model not found**: Verify model name in `model_config` matches server configuration
- **Environment variable missing**: Ensure `.env` file loaded and variables defined

### DVC Errors

- **DVC not initialized**: Run `dvc init` in workspace root
- **Cache directory missing**: Verify `.dvc/cache` exists and has write permissions
- **Remote not configured**: Check `.dvc/config` for local or cloud remote

## Validation Checklist

Before considering generation complete, verify:

- ✅ Image file saved to correct location
- ✅ Image file has correct naming convention
- ✅ Metadata YAML file created with all required fields
- ✅ DVC tracking file (.dvc) generated
- ✅ Operation log entry created
- ✅ All referenced entities exist and versions recorded
- ✅ Prompt accurately reflects scene narrative and entity context
- ✅ Generation parameters match `model_config` specification

## Example: Complete Generation Flow

**Input**: Scene entity `hero-library-quest.md`

**Process**:

1. Read scene: narrative, setting, mood, model_config
2. Resolve references: hero-protagonist, ancient-library, cinematic-realism
3. Construct prompt: Combine style + narrative + environment + character
4. Extract config: MCP server = gemini-imagen, model = imagen-3.0-generate-001
5. Generate via MCP: `@gemini-imagen` with constructed prompt
6. Save: `content/test/hero-library-quest-v1-20260124T213045.png`
7. Create metadata: `hero-library-quest-v1-20260124T213045-metadata.yaml`
8. Track DVC: `dvc add <image-file>`
9. Log operation: Append to `logs/image-generation-operations.log`

**Output**:

- PNG image file (1024x1024)
- DVC tracking file (.dvc)
- Metadata YAML file
- Operation log entry

## Usage Notes

This template enables consistent, traceable image generation from scene entities. By following the 9-step workflow, every generated asset has complete provenance (source scene, model used, parameters, timestamp) and is properly version-controlled through DVC.

For batch generation (multiple images from multiple scenes), repeat this workflow for each scene, ensuring unique file names and proper logging for each operation.
