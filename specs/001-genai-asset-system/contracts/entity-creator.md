# Contract: Entity Creator Workflow

**Workflow Name**: `entity-creator`
**Purpose**: Universal entity creation workflow - reads templates, resolves dependencies, creates all entity types
**Scope**: Creates template entities, character entities, process entities (scripts), output entities (videos, images) with binaries

**Structure**: Markdown file with YAML front-matter (consistent with entity pattern)

## Unified Entity Model

Everything in the system is an entity with dependencies:

**Bootstrap**: `entities/entity-templates/entity-template.template.md` (manually authored)
   ↓ creates
**Template Entities**: `entities/entity-templates/character.template.md`, `script.template.md`, `video.template.md`
   ↓ creates (with dependency resolution)
**Concrete Entities**:
- `entities/characters/max.md` (character entity)
- `entities/script/intro-script.md` (process entity - executable)
- `entities/video/max-intro.md` + `content/max-intro.mp4` (entity with binary body)

**Key Principles**:
- Templates are entities (created from entity-template.template.md)
- Process instructions are entities (scripts, sequences, flows)
- Outputs are entities (metadata + optional binary in content/)
- Dependencies form a network (cycles allowed for relationships)
- Entity-creator reads any template and creates any entity type

## Universal Entity Abstraction

- Entities can be of any type: definitions, assets (images, videos, etc.), code files, or entire projects.
- The entity-creator is responsible for generating, completing, or transforming any entity type, guided by templates and user input.
- If an entity definition is incomplete or underspecified, the entity-creator will prompt the user for missing details or infer them, ensuring every entity is fully described and usable.

## Workflow Capabilities

### Inputs
- **Entity Type**: character | script | video | image | entity-template | [extensible]
- **Entity Name**: Kebab-case string (alphanumeric + hyphens only)
- **User Properties**: Values for fields defined by template
- **Dependency Resolution Mode**: auto (prompt for missing) | manual (fail if missing)

### Outputs
- **Metadata File**: `entities/<type>/<name>.md` with YAML front-matter + Markdown body
- **Binary Output** (if entity type generates binaries): `content/<name>.<ext>` tracked by DVC
- **Process Execution Log** (if process entity): `logs/<name>.log`
- **Dependency Graph**: Updated with new entity and its dependencies

### Preconditions
- **Bootstrap exists**: `entities/entity-templates/entity-template.template.md` manually authored
- **Template exists**: `entities/entity-templates/<type>.template.md` exists for target entity type
- **Dependencies resolved**: All dependencies declared in template either exist or can be created
- **Unique name**: No existing entity with same type and name

### Postconditions
- Entity metadata file created at `entities/<type>/<name>.md`
- Binary output created (if applicable) at `content/<name>.<ext>` and tracked by DVC
- All dependencies satisfied (created recursively if needed)
- Git commit with entity metadata (and DVC file if binary generated)

### Postconditions
- Entity file created at correct path
- File contains valid YAML front-matter
- Name matches filename
- Model config follows discriminated union structure
- Timestamps auto-populated

## Workflow Steps (Universal)

The workflow is template-agnostic and handles all entity types:

1. **Load Template**
   - Read `entities/entity-templates/<type>.template.md`
   - Parse schema (required fields, validation rules, default values)
   - Extract dependency declarations (if any)

2. **Discover Dependencies (JIT)**
   - Discovery happens just-in-time as entity creation progresses
   - Check template for `dependencies:` declaration
   - Check entity definition for dependency references
   - Parse user prompt/instructions for implicit dependencies
   - Infer dependencies from tacit context (e.g., video type typically needs character)
   - Example: `video.template.md` might declare `dependencies: [character, script]`
   - Build comprehensive dependency list from all sources

3. **Resolve Dependencies (JIT)**
   - For each dependency:
     - Check if entity exists
     - If missing: Prompt user "Need <dependency-type> entity. Create now?"
     - If user confirms: Recursively call entity-creator for dependency
     - If user declines: Fail with clear error
   - Continue only when all dependencies satisfied

4. **Collect Entity Properties**
   - Prompt user for fields defined in template
   - Apply validation rules from template
   - For model_config fields: Validate MCP server or env var

5. **Execute Process Entities** (if applicable)
   - If template declares entity is a "process" type (e.g., script.template.md)
   - Mark entity as executable
   - Store process instructions in entity body

6. **Generate Binary Outputs** (if applicable)
   - If template declares entity generates binary (e.g., video, image)
   - Read model_config from dependencies or entity itself
   - Build GenAI prompt from entity properties + dependencies
   - Invoke GenAI API
   - Validate output (format, size)
   - Save to `content/<name>.<ext>`

7. **Validate Generated Entity** (optional)
   - If validation is required (not explicitly excepted)
   - Invoke validator entity (planned) to validate generated entity against its description
   - Check conformance to template schema and user requirements
   - Log validation results

8. **Create Metadata File**
   - Write `entities/<type>/<name>.md`
   - Include YAML front-matter with all properties
   - Include references to dependencies
   - Include Markdown body (description/instructions)

9. **Track with DVC** (if binary generated)
   - Execute `dvc add content/<name>.<ext>`
   - Create `.dvc` file

10. **Stage for Commit**
    - Stage metadata file: `git add entities/<type>/<name>.md`
    - Stage DVC file (if generated): `git add content/<name>.<ext>.dvc`
    - Prompt user for commit approval (human-in-the-loop)

11. **Confirm Creation**
    - Display entity path, dependencies used, binary output (if any), validation status
    - Log to `logs/<name>.log`

## Validation Rules

### Name Validation
```
Pattern: ^[a-z0-9]+(-[a-z0-9]+)*$
Examples:
  ✓ max
  ✓ golden-retriever
  ✓ watercolor-style
  ✗ Max (uppercase)
  ✗ max_character (underscore)
  ✗ max! (special char)
```

### Model Config Validation (MCP)
```yaml
model_config:
  provider: mcp              # Required literal
  server: dalle-mcp          # Must exist in .vscode/settings.json
  model: dall-e-3            # Required string
  parameters:                # Optional object
    style: vivid
```

### Model Config Validation (Direct API)
```yaml
model_config:
  provider: direct-api       # Required literal
  endpoint: https://api.openai.com/v1/images/generations
  api_key: ${OPENAI_API_KEY} # Must be env var reference
  model: dall-e-3            # Required string
  parameters:                # Optional object
    quality: standard
```

## Error Handling

| Error                     | Response                                                                                               |
| ------------------------- | ------------------------------------------------------------------------------------------------------ |
| Name exists               | Fail with message: "Entity {name} already exists in {type}. Choose different name or delete existing." |
| Invalid name format       | Fail with message: "Name must be kebab-case (alphanumeric + hyphens only). Got: {name}"                |
| MCP server not found      | Fail with message: "MCP server '{server}' not configured in .vscode/settings.json"                     |
| Invalid env var reference | Fail with message: "API key must be environment variable reference (e.g., ${OPENAI_API_KEY})"          |
| Missing required field    | Fail with message: "Required field '{field}' missing from model_config"                                |

## Example Workflow

**User Prompt**:
```
Create a character entity named "max" - a friendly golden retriever with a red collar. Use DALL-E via MCP.
```

**Agent Actions**:
1. Validate name "max" (kebab-case ✓)
2. Check `entities/characters/max.md` doesn't exist
3. Prompt for visual properties (guide user with examples)
4. Prompt for model config (detect MCP preference, validate server exists)
5. Generate file with structure:

```markdown
---
name: max
type: character
description: Friendly golden retriever with red collar
visual_properties:
  species: golden retriever
  accessories: red collar
  personality: playful, energetic
model_config:
  provider: mcp
  server: dalle-mcp
  model: dall-e-3
creation_date: 2026-01-05
last_modified: 2026-01-05
---

# Max the Golden Retriever

[User's narrative description here]
```

6. Confirm: "✓ Created entities/characters/max.md"

## Integration Points

- **Reads**: `.vscode/settings.json` (MCP server list)
- **Reads**: `.env` (validates env vars exist for direct-api)
- **Writes**: `entities/<type>/<name>.md`
- **Used By**: Asset generation agents (read entity files for context)

## Testing Criteria

- Creates valid entity file with all required fields
- Rejects invalid names (uppercase, special chars, underscores)
- Validates MCP server existence before creating entity
- Validates env var format for direct API configs
- Auto-populates timestamps in ISO 8601 format
- Fails gracefully with clear error messages
