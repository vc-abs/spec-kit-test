# Feature Specification: GenAI Asset Generation System

**Feature Branch**: `001-genai-asset-system`
**Created**: 2026-01-04
**Status**: Draft
**Input**: User description: "Build an asset generation tool/system that utilizes GenAI tools and DVC to create assets. The system should create and maintain abstract entities (style, environment, character). Assets will be created based on these entities in various types (informative images, greeting cards, sprite-sheets, videos). It should leverage the right model to generate assets."

## Clarifications

### Session 2026-01-04

- Q: For entity storage, how should entities be persisted? → A: YAML front-matter with Markdown files
- Q: How should the system handle entity uniqueness and naming conflicts? → A: Entity templates stored in `entities/<type>/<name>.md` (e.g., `entities/character/max.md`, `entities/style/watercolor.md`). Type subfolder organization. Assets use feature-based naming: `<feature>-<description>.<asset-type>.<ext>`
- Q: For GenAI model selection, how should the system determine which model to use for each asset type? → A: Configuration file mapping with per-generation override capability
- Q: What maximum limits should apply to batch generation requests to prevent resource exhaustion? → A: 5 assets per batch maximum
- Q: How should generated assets be organized in the content directory structure? → A: Single flat `content/` directory - no nesting by type
- Q: Is this building a new CLI tool or using existing Copilot workflow? → A: **Copilot workflow** - Use Spec-kit with GitHub Copilot to generate assets. NOT building a new CLI tool. Focus on content structure, prompts, and agents that Copilot can use.
- Q: Should MCP server setup be validated before entity definition, or should entities come first? → A: **P1 MCP validation → P2 entities**. MCP/API connectivity must be validated first as absolute prerequisite. Entities are useless without working generation infrastructure.
- Q: How should the system handle MCP server unavailability? → A: **Config-driven per asset type** - no automatic runtime fallback. Model config in entity specifies either MCP or direct API endpoint for each asset type.
- Q: Where should model configuration be stored? → A: **Inline in entity templates** - each entity YAML front-matter includes model_config field specifying provider (mcp/direct-api), endpoint, model name, parameters.
- Q: When combining entities with different model preferences in a single asset, how is the model selected? → A: **Asset type determines model** - entity model preferences are informational only. Asset type has default model selection logic (first entity's model config or Copilot agent default).
- Q: What constitutes successful MCP server validation? → A: **Connection + single test generation per supported asset type** - validate each asset type (greeting card, informative image, sprite-sheet, video) can generate minimal test output.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Setup and Validate MCP Servers (Priority: P1)

A developer needs to configure MCP server connections and validate that each supported asset type can successfully generate test outputs. This establishes confidence in the GenAI generation pipeline before any entity or production asset work begins.

**Why this priority**: Absolute foundational prerequisite. Without validated MCP/API connectivity, nothing else can proceed - entities are useless if the generation infrastructure doesn't work. This validates the technical feasibility of the entire system before investing effort in content structure or workflows.

**Independent Test**: Can be fully tested by configuring MCP server endpoints (or direct API fallback) in test entity files, then prompting Copilot to generate one test asset per supported type (greeting-card, informative-image, sprite-sheet, video) and verifying successful generation with DVC tracking.

**Acceptance Scenarios**:

1. **Given** MCP server endpoints configured in test entity files, **When** I prompt Copilot to generate a test greeting card, **Then** the asset is successfully generated, saved to `content/`, and tracked by DVC
2. **Given** an MCP server connection fails, **When** the entity specifies direct API fallback config, **Then** Copilot uses the direct API endpoint and generation succeeds
3. **Given** all 4 asset types (greeting-card, informative-image, sprite-sheet, video), **When** I run validation test for each type, **Then** all 4 test assets are generated successfully
4. **Given** an invalid MCP server endpoint in entity config, **When** I attempt test generation, **Then** Copilot provides clear error message indicating connection failure and suggests checking endpoint configuration

---

### User Story 2 - Define and Manage Entity Templates (Priority: P2)

A content creator needs to define reusable entity templates (characters, styles, environments) as structured files that GitHub Copilot can read and use for consistent asset generation. These templates capture core attributes, visual properties, and model configuration preferences in YAML front-matter + Markdown format.

**Why this priority**: Content structure foundation. After validating MCP/API connectivity (P1), entity templates provide the structured context that ensures consistency across generated assets. These files define what to generate with the validated infrastructure.

**Independent Test**: Can be fully tested by creating a character entity file `entities/character/max.md` with YAML front-matter (name, type, visual_properties, model_config with provider/endpoint/model) and Markdown description, then verifying Copilot can read and reference it in prompts.

**Acceptance Scenarios**:

1. **Given** no existing entity files, **When** I create `entities/character/max.md` with YAML front-matter containing "name: Max, type: character, visual_properties: golden retriever, red collar, playful, model_config: {provider: mcp, server: dalle-mcp, model: dall-e-3}", **Then** the file is saved in `entities/character/` directory and Copilot can access it as context
2. **Given** an existing style entity `entities/style/watercolor.md`, **When** I update its model_config to switch from MCP to direct API, **Then** the updated configuration is persisted in YAML front-matter
3. **Given** multiple entities of different types, **When** I list all entities, **Then** I see entities organized by type folders (character/, style/, environment/)
4. **Given** an entity with dependent assets, **When** I attempt to delete the entity, **Then** I receive a warning about dependent assets

---

### User Story 3 - Generate Single Asset via Copilot Prompt (Priority: P3)

A content creator uses GitHub Copilot with entity file context to generate a single asset. They provide a Copilot prompt referencing entity files and asset type, and Copilot generates the asset using the model configuration specified in entity templates (MCP server or direct API).

**Why this priority**: Core value proposition - generating production assets with Copilot. This story delivers immediate value by producing actual output, building on validated generation infrastructure (P1) and entity templates (P2).

**Independent Test**: Can be fully tested by opening entity files `entities/character/max.md` and `entities/style/watercolor.md` in workspace, prompting Copilot "Generate a greeting card combining these entities", and verifying an image is generated, tracked by DVC, with metadata.

**Acceptance Scenarios**:

1. **Given** entity files `entities/character/max.md` and `entities/style/watercolor.md` exist in workspace, **When** I prompt Copilot to generate a greeting card referencing both entities, **Then** Copilot generates an image with name like `001-genai-asset-system-max-card.greeting-card.png`, saves it to `content/`, tracks it with DVC, and creates a metadata YAML file
2. **Given** an environment entity "Forest" with model_config specifying direct API endpoint, **When** I request an informative image, **Then** Copilot uses the configured model from entity config and produces the asset
3. **Given** generation parameters including resolution "1024x1024", **When** I generate an asset, **Then** the output matches the specified resolution
4. **Given** a failed generation attempt, **When** the GenAI model returns an error, **Then** I see a clear error message and no partial asset is saved

---

### User Story 4 - Generate Batch Assets with Copilot Workflow (Priority: P4)

A content creator uses a Copilot prompt or agent to generate multiple asset variations in sequence, exploring different entity combinations or parameters. Copilot iterates up to 5 times per batch request.

**Why this priority**: Efficiency improvement over single generation. Batch workflows save time but are not essential for MVP - users can manually prompt Copilot multiple times.

**Independent Test**: Can be fully tested by prompting Copilot "Generate 5 greeting card variations" with character and style entities (containing model_config) in context, and verifying 5 distinct assets are generated (e.g., `001-genai-asset-system-max-card-v1.greeting-card.png` through v5), each tracked and versioned.

**Acceptance Scenarios**:

1. **Given** entity files `entities/character/max.md` and 3 style entities in `entities/style/`, **When** I prompt Copilot for batch generation of greeting cards with all style combinations, **Then** 3 greeting cards are generated sequentially, each tracked by DVC with unique filenames
2. **Given** batch generation parameters with variations in lighting (bright, dim, sunset), **When** I generate an environment asset batch, **Then** 3 images are produced with different lighting conditions
3. **Given** a batch operation in progress, **When** one asset fails to generate, **Then** the batch continues and I receive a summary of successes and failures

---

### User Story 5 - Browse Assets via VS Code File Explorer (Priority: P5)

A content creator browses previously generated assets using VS Code's file explorer in the `content/` directory and retrieves specific versions from DVC history using standard DVC commands in the terminal.

**Why this priority**: Nice-to-have for asset management but not required for core generation workflow. VS Code's built-in file explorer provides sufficient browsing capability.

**Independent Test**: Can be fully tested by generating several assets, then using VS Code file explorer to navigate `content/` directory and view associated metadata YAML files.

**Acceptance Scenarios**:

1. **Given** 20 generated assets in `content/` directory, **When** I use VS Code's file search to filter by asset type (e.g., `.greeting-card.png`), **Then** I see only greeting card assets with associated metadata YAML files
2. **Given** an asset file in VS Code, **When** I open its corresponding metadata YAML file, **Then** I can see entity references with type paths (e.g., `entities/character/max.md`) and generation parameters
3. **Given** an asset tracked by DVC, **When** I run `dvc diff` in terminal, **Then** I see version history for that asset
4. **Given** multiple asset directories, **When** I use VS Code's file search (Ctrl+P), **Then** I can quickly locate any asset by filename

---

### Edge Cases

- What happens when a referenced entity file is deleted while Copilot is generating an asset?
- How does the system handle GenAI API rate limits or quota exhaustion during Copilot workflows?
- What occurs when DVC remote storage is unreachable during asset save?
- How are filename conflicts resolved when multiple assets are generated with the same name?
- What happens when an entity has no compatible GenAI model defined in the model configuration file?
- How does Copilot handle batch requests exceeding the 5-asset limit?
- When combining multiple entities with different model_config preferences (e.g., character prefers DALL-E MCP, style prefers Midjourney direct API), how is the final model selected?
- What happens when an MCP server endpoint in entity config becomes unreachable mid-generation (no runtime fallback configured)?

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: System MUST provide entity template structure as YAML front-matter + Markdown files stored in `entities/<type>/` subdirectories (e.g., `entities/character/`, `entities/style/`, `entities/environment/`)
- **FR-002**: Entity files MUST follow naming pattern `entities/<type>/<name>.md` (e.g., `entities/character/max.md`). Kebab-case for names, no feature prefix. Supported types: character, style, environment, entity-template.
- **FR-003**: System MUST support asset generation workflows via GitHub Copilot for types: informative images, greeting cards, sprite-sheets, videos
- **FR-004**: Entity templates MUST include model_config in YAML front-matter specifying: provider (mcp/direct-api), endpoint/server, model name, generation parameters. Model config is defined inline per entity, not in a central configuration file.
- **FR-005**: System MUST track all generated binary assets using DVC with automatic commit and versioning
- **FR-006**: System MUST generate and store metadata for each asset including: generation timestamp, entity references, model used, generation parameters
- **FR-007**: System MUST store asset metadata as YAML files version-controlled in git (separate from binary assets in DVC)
- **FR-008**: Copilot agents MUST validate entity file references exist before asset generation and provide clear error messages if missing
- **FR-009**: Copilot workflows MUST support batch asset generation (up to 5 assets per request) with entity variation parameters
- **FR-010**: Generated asset files MUST follow naming pattern `<feature>-<description>.<asset-type>.<ext>` (e.g., `009-diwali-greetings-lakshmi-on-a-lotus.insta-post.png`). Kebab-case for feature and description. All assets stored in single flat `content/` directory.
- **FR-011**: System MUST log all GenAI model interactions including prompts, parameters, model versions, and response metadata to `logs/` directory
- **FR-012**: System MUST provide Copilot agents for common workflows: entity creation, single asset generation, batch generation
- **FR-013**: System MUST integrate with MCP servers when available for enhanced GenAI model capabilities. Selection between MCP and direct API is config-driven per entity (no automatic runtime fallback).
- **FR-017**: When generating assets referencing multiple entities with different model_config preferences, the system MUST resolve model selection using asset-type default logic: use first entity's model_config or Copilot agent default for that asset type. Entity model preferences are informational, not binding.
- **FR-018**: P1 story MUST validate MCP/direct-API connectivity by generating one test asset per supported asset type (greeting-card, informative-image, sprite-sheet, video) and confirming successful generation with DVC tracking.
- **FR-014**: Copilot agents MUST validate generated assets for format compliance and integrity before DVC commit
- **FR-015**: Asset metadata YAML files MUST capture complete generation parameters enabling Copilot to reproduce any asset with identical entity snapshots and model settings
- **FR-016**: System MUST provide prompt templates and agent files in `.github/prompts/` and `.github/agents/` following Spec-kit conventions

### Key Entities

- **Entity Template**: Stored as `entities/<type>/<name>.md` file (e.g., `entities/character/max.md`, `entities/entity-template/character.md`) with YAML front-matter (name, type, description, visual_properties, model_config: {provider, endpoint/server, model, parameters}, creation_date, last_modified) + Markdown body. No feature prefix. Organized by type subdirectory. Copilot reads these files as context. Model config specifies preferred provider (mcp/direct-api), but asset type determines final model selection for multi-entity assets.
- **Asset**: Generated file following pattern `<feature>-<description>.<asset-type>.<ext>` (e.g., `009-diwali-greetings-lakshmi-on-a-lotus.insta-post.png`) with feature prefix matching current feature. Stored in `content/` directory. Attributes include asset_id, asset_type, file_path (DVC-tracked), metadata_path (git-tracked YAML), entity_references (list of entity paths like `entities/character/max.md`)
- **Asset Metadata**: YAML file (named `<asset-name>.meta.yaml`) stored in git containing generation_prompt (exact Copilot prompt used), model_name, model_version, entity_snapshots (copy of entity YAML at generation time), generation_parameters, resolution, file_format, dvc_hash
- **Copilot Agent**: Agent file in `.github/agents/` that defines asset generation workflows (single, batch, MCP validation) and integrates with entity files and inline model configuration. Implements asset-type-determines-model resolution logic for multi-entity assets.
- **Copilot Prompt**: Prompt template in `.github/prompts/` guiding users on how to request asset generation with entity references and model config specification

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Users can create an entity file and prompt Copilot to generate an asset using it in under 3 minutes
- **SC-002**: Generated assets are tracked by DVC with correct versioning and metadata YAML files 100% of the time
- **SC-003**: Asset generation success rate via Copilot workflow exceeds 95% for supported asset types and models
- **SC-004**: System logs every GenAI interaction with complete prompt and parameter history to `logs/` directory
- **SC-005**: Batch generation of 5 asset variations (max limit) via Copilot completes in under 5 minutes (excluding model API latency)
- **SC-006**: Asset metadata YAML allows Copilot to reproduce any asset with identical entity snapshots and generation parameters
- **SC-007**: Users can navigate `content/` directory and filter assets by filename pattern (e.g., `*.greeting-card.*`) in under 30 seconds
- **SC-008**: Copilot agents handle GenAI API failures gracefully without data loss or orphaned assets

## Assumptions

- GitHub Copilot is installed and configured in the workspace
- GenAI model APIs (image generation, video generation) are accessible via MCP servers or direct API integration
- DVC is installed, configured with remote storage, and accessible from the workspace
- Users have basic familiarity with GitHub Copilot, file-based workflows, and @ file references
- Asset generation is not real-time - acceptable latency ranges from seconds (images) to minutes (videos) depending on model
- Entity templates are text-based descriptions (YAML + Markdown), not reference images (text-to-image workflow)
- Storage capacity for DVC remote is sufficient for expected asset volume
- Model selection is config-driven per entity (no automatic runtime fallback between MCP and direct API). If MCP endpoint fails, generation fails - user must update entity config to direct API manually.
- When combining entities with different model preferences, asset type determines final model (uses first entity's model_config or Copilot agent default)
- P1 MCP validation story creates throwaway test assets to prove connectivity before any entity or production work
- Filesystem supports entity organization `entities/<type>/<name>.md` (no feature prefix) and asset naming `<feature>-<description>.<asset-type>.<ext>` (with feature prefix)
- Spec-kit framework is available for constitution, planning, and task management workflows

