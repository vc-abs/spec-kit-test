# Research: GenAI Asset Generation System

**Phase**: 0 - Outline & Research
**Date**: 2026-01-05
**Purpose**: Resolve technical unknowns and establish best practices before design phase

## Research Tasks

### 1. MCP (Model Context Protocol) Integration Patterns

**Unknown**: How do MCP servers integrate with GitHub Copilot for GenAI model access?

**Decision**: MCP servers are VS Code extensions that expose AI capabilities through a standardized protocol. Configuration stored in `.vscode/settings.json`.

**Rationale**:
- MCP is a VS Code/Copilot ecosystem standard for AI tool integration
- Centralized configuration allows endpoint updates without modifying entity files
- Server name references in entities resolve to configs at runtime

**Alternatives Considered**:
- Hardcoded API endpoints in entities → Rejected: Difficult to update, violates DRY
- Separate MCP config file outside .vscode → Rejected: Non-standard, harder for Copilot to discover

**Implementation**: Entity model_config contains `{provider: mcp, server: dalle-mcp, model: dall-e-3}`, resolves server details from `.vscode/settings.json` namespace.

---

### 2. DVC Workflow for Binary Asset Tracking

**Unknown**: How should DVC integrate into Copilot-driven asset generation workflow?

**Decision**: Custom Copilot prompt/agent executes shell commands: `dvc add <asset> && git add <asset>.dvc <metadata>.yaml && git commit -m "..."`

**Rationale**:
- DVC CLI is well-documented and stable
- Direct shell execution from Copilot agents is supported (via `run_in_terminal` per `.github/copilot-instructions.md`)
- Single atomic workflow prevents orphaned files
- Manual cleanup on failure maintains simplicity (no rollback logic)
- Auto-commit is feature-specific requirement (FR-005), not general Copilot behavior

**Alternatives Considered**:
- Automatic DVC tracking via git hooks → Rejected: Implicit behavior, harder to debug
- Separate DVC commit step → Rejected: Risk of forgetting, incomplete tracking
- Python wrapper script → Rejected: Adds complexity, violates simplicity principle

**Implementation**: Copilot prompt template includes DVC commands with conventional commit format. Prerequisite: DVC remote configured (S3/Azure/GCS/local) before P1.

---

### 3. Unified Entity Model Architecture

**Unknown**: How should the system be architected - should entities and assets be separate concepts?

**Decision**: **Unified entity model** where everything is an entity. Templates are entities. Characters are entities. Scripts (process instructions) are entities. Videos are entities (metadata + binary). Dependencies form a network (cycles allowed). Entity-creator workflow reads entity templates, resolves dependencies just-in-time, and creates all entity types.

**Rationale**:
- **Conceptual Simplicity**: One mental model ("entity with dependencies") instead of multiple (entities vs assets vs templates vs processes)
- **Dependency Network**: Natural representation of relationships (video depends on character and script)
- **Extensibility**: Add new entity types by creating new templates - no system changes
- **Process as Data**: Scripts/sequences are entities that entity-creator executes, not hardcoded logic
- **Uniform Treatment**: Same create/read/update/delete operations for all entity types

**Alternatives Considered**:
- Pure YAML agents + separate Markdown prompts → Rejected: Splits related content, less consistent with entity pattern
- JSON agents → Rejected: Less human-readable than YAML front-matter
- Agents as code (Python/JS) → Rejected: Adds build complexity, not Copilot-first

**Implementation** (Entity-Creator Workflow):
- `entity-creator.md`: Universal entity creation workflow
  - Reads entity template (e.g., video.template.md)
  - Discovers dependencies (requires: [character, script])
  - Prompts user to resolve missing dependencies
  - Creates dependencies first (recursive)
  - Creates target entity:
    - Writes metadata file (entities/video/max-intro.md)
    - Executes process entities if needed (script/intro-script.md)
    - Generates binary outputs via GenAI (content/max-intro.mp4)
    - Tracks with DVC

**Key Point**: Single workflow handles all entity types by reading their templates.

---

### 4. Entity Template Meta-Architecture

**Unknown**: How should entity-templates themselves be structured and created?

**Decision**: Use a recursive meta-template architecture with dependency network:
1. **Manual Bootstrap**: `entity-template.template.md` (master meta-template, manually authored)
2. **Generated Templates**: All templates (character.template.md, script.template.md, video.template.md) are entities created from bootstrap
3. **Generated Entities**: Concrete entities created from templates (character/max, script/intro, video/max-intro)
4. **Dependency Resolution**: Templates declare dependencies; entity-creator resolves them just-in-time

**Rationale**:
- **Self-similarity**: Templates are entities, entities follow templates - consistent pattern
- **Extensibility**: New entity types can be added by creating new templates (using entity-template-template)
- **Single Agent**: The `entity-creator` doesn't need type-specific logic - it just reads templates
- **Bootstrap Pattern**: Common in meta-systems (compilers that compile themselves, etc.)
- **Discoverability**: All templates live in `entities/entity-template/`, easy to find and understand

**Alternatives Considered**:
- Hardcoded entity types in agent → Rejected: Not extensible, violates DRY
- Separate template format from entity format → Rejected: Adds complexity, breaks self-similarity
- Templates as code (JSON Schema, etc.) → Rejected: Less human-readable, not Copilot-first

**Implementation**:
- `entities/entity-template/entity-template.template.md`: Manually authored bootstrap (defines what a template is)
- `entities/entity-template/character.template.md`: Created by entity-creator from bootstrap
- `entities/entity-template/script.template.md`: Created by entity-creator from bootstrap (declares it's a process entity)
- `entities/entity-template/video.template.md`: Created by entity-creator from bootstrap (declares dependencies: character, script)
- `entities/character/max.md`: Created by entity-creator using character.template.md
- `entities/script/intro-script.md`: Created by entity-creator using script.template.md (executable process)
- `entities/video/max-intro.md` + `content/max-intro.mp4`: Created by entity-creator using video.template.md (resolves deps, executes script, generates binary)

**Workflow**: Read template → Parse dependencies → Resolve dependencies → Create entity (metadata + process execution + binary generation)

**Example Agent Structure**:
```markdown
---
name: entity-creator
purpose: Guide users through creating entity templates
inputs:
  - entity_type: character | style | environment
  - entity_name: kebab-case identifier
outputs:
  - entities/<type>/<name>.md
---

# Entity Creator Agent

## Workflow
1. Prompt user for entity type
2. Load relevant entity-template
...
```

---

### 4. Entity Template Best Practices (YAML + Markdown)

**Unknown**: How should entity templates balance structure (YAML) and narrative (Markdown)?

**Decision**: YAML front-matter for machine-readable fields (model_config, visual_properties), Markdown body for rich descriptions and examples.

**Rationale**:
- YAML front-matter is standard in static site generators (Jekyll, Hugo)
- Copilot can parse both YAML and Markdown efficiently
- Visual properties as YAML enables validation and programmatic access
- Markdown body provides context for Copilot's generation prompts

**Alternatives Considered**:
- Pure YAML → Rejected: Difficult to write long narrative descriptions
- Pure Markdown with inline YAML blocks → Rejected: Non-standard, harder to parse
- Separate .yaml and .md files → Rejected: Splits entity definition across files

**Implementation Example**:
```markdown
---
name: max
type: character
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

Max is a friendly golden retriever with a vibrant red collar. He loves to play fetch and has an infectious enthusiasm that brings joy to everyone around him. His fur is a warm golden color, and his eyes sparkle with curiosity.

## Visual Style Notes

- Rounded, soft edges for friendly appearance
- Expressive eyes with highlights
- Dynamic poses showing movement and energy
```

---

### 5. Asset Type Format Specifications

**Unknown**: Should asset format details (resolution, duration, frame rate) be standardized in the spec or flexible per entity?

**Decision**: Template-driven specification. Asset types (greeting cards, sprite-sheets, videos) are examples. Format details defined in entity-template files or specified in Copilot prompts at generation time.

**Rationale**:
- Different projects have different format needs
- Entity-template files capture reusable configurations
- Prompt-level overrides support one-off customizations
- Flexibility prevents over-specification in the base system

**Alternatives Considered**:
- Hardcoded format constraints in spec → Rejected: Inflexible, doesn't scale to new asset types
- Global config file → Rejected: Centralization conflicts with entity-centric design
- Hash-based format registry → Rejected: Overcomplicated for simple use case

**Implementation**: Entity-template files (e.g., `entities/entity-template/sprite-sheet-template.md`) define default parameters. Copilot prompts can override with generation-time parameters.

---

### 6. Error Handling Patterns for GenAI APIs

**Unknown**: What error handling patterns work best with unpredictable GenAI API responses?

**Decision**: Fail-fast with detailed error messages. No automatic retries or fallbacks. Log all errors to per-asset log files.

**Rationale**:
- GenAI errors often indicate quota/rate limits or invalid prompts
- Automatic retries can exhaust quotas or incur unexpected costs
- Clear error messages enable user-driven resolution
- Per-asset logs provide debugging context

**Alternatives Considered**:
- Automatic retry with exponential backoff → Rejected: Can compound quota issues
- Silent failure with partial results → Rejected: Violates observability principle
- Runtime fallback between MCP and direct-api → Rejected: Unpredictable behavior, complexity

**Implementation**: Copilot agents validate prerequisites (env vars, entity files, filename conflicts) before API calls. On API errors, display failure details and log to `logs/<asset-name>.log`.

---

### 7. Naming Convention Enforcement

**Unknown**: How to enforce kebab-case and filesystem-safe naming across all artifacts?

**Decision**: Validation in Copilot agents. Reject entity/asset creation if name contains special characters or violates kebab-case. Only alphanumeric + hyphens permitted.

**Rationale**:
- Prevents filesystem issues across platforms (Windows, Linux, macOS)
- Log filenames directly correspond to asset names (no escaping needed)
- Consistent naming improves discoverability

**Alternatives Considered**:
- Automatic sanitization (replace special chars) → Rejected: Silent changes confuse users
- Platform-specific validation → Rejected: Inconsistent behavior
- Hash-based filenames → Rejected: Loss of human readability

**Implementation**: Agent pre-generation validation step checks name against regex `^[a-z0-9]+(-[a-z0-9]+)*$`. Fail with error if invalid.

---

## Summary of Research Outcomes

All technical unknowns resolved. Key decisions:

1. **MCP Integration**: Server names in entities → details in `.vscode/settings.json`
2. **DVC Workflow**: Custom Copilot prompt executes shell commands, human approves commit
3. **Agent Structure**: Markdown with YAML front-matter (consistent with entity template pattern)
4. **Entity Format**: YAML front-matter + Markdown body
5. **Asset Formats**: Template-driven, flexible per entity or prompt
6. **Error Handling**: Fail-fast with detailed logging, no auto-retry
7. **Naming**: Strict kebab-case validation, alphanumeric + hyphens only

Ready to proceed to Phase 1: Design (data models, contracts, quickstart).
