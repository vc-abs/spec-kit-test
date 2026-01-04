# Feature Specification: GenAI Asset Generation System

**Feature Branch**: `001-genai-asset-system`
**Created**: 2026-01-04
**Status**: Draft
**Input**: User description: "Build an asset generation tool/system that utilizes GenAI tools and DVC to create assets. The system should create and maintain abstract entities (style, environment, character). Assets will be created based on these entities in various types (informative images, greeting cards, sprite-sheets, videos). It should leverage the right model to generate assets."

## Clarifications

### Session 2026-01-04

**Scope & Architecture**
- **System Type**: Copilot workflow (NOT CLI tool) - Use Spec-kit with GitHub Copilot to generate assets via prompts and agents
- **Implementation Priority**: P1 MCP validation → P2 entities → P3+ features. MCP/API connectivity is absolute prerequisite before entity work
- **MCP Validation**: Connection test + single test asset generation per supported type (greeting-card, informative-image, sprite-sheet, video)

**Storage & Organization**
- **Entity Storage**: YAML front-matter + Markdown files at `entities/<type>/<name>.md` (e.g., `entities/character/max.md`)
- **Asset Storage**: Flat `content/` directory for production; `content/test/` for P1 validation assets
- **Naming Convention**: Kebab-case with only alphanumeric + hyphens. No special characters. Entities: `<type>/<name>.md`. Assets: `<feature>-<description>.<asset-type>.<ext>`
- **Batch Naming**: Descriptive suffixes for parameter variations (e.g., `-bright`, `-sunset`), fallback to `-v1`, `-v2`
- **Logs**: Per-asset files at `logs/<asset-name>.log` (naming constraints ensure filesystem safety)

**Model Configuration Architecture**
- **Config Location**: Inline in entity YAML front-matter (model_config field). MCP server details in `.vscode/settings.json` (version-controlled). Credentials in `.env` (gitignored)
- **Config Structure**: Discriminated union by provider field. MCP: `{provider: mcp, server: <name>, model: <model>}`. Direct API: `{provider: direct-api, endpoint: <url>, api_key: ${ENV_VAR}, model: <model>}`
- **Model Resolution**: When entities have different preferences, asset type determines final model (first entity's model_config or agent default). No runtime fallback between MCP/direct-api
- **MCP Endpoint Updates**: Entity references MCP server name; endpoint details in `.vscode/settings.json` updated centrally

**Asset Format & Parameters**
- **Format Specification**: Template-driven. Asset types (greeting cards, sprite-sheets, videos) are examples. Format details defined in entity-template files or Copilot prompts
- **Parameter Source**: Flexible - entity-template files for reusable configs, or Copilot prompt for one-off customizations

**DVC & Version Control**
- **DVC Workflow**: Custom Copilot prompt/workflow executes `dvc add <asset>` + `git add` + `git commit` after generation
- **DVC Prerequisite**: Remote storage (S3/Azure/GCS/local) configured before P1 - not part of implementation
- **Commit Format**: Single assets: `feat(asset): add <type> with <entity1>, <entity2>`. Batches: `feat(asset): add <count> <type> variations with <entities>`
- **Batch Commits**: All batch assets in single atomic commit
- **Metadata**: Path references only (e.g., `entities/character/max.md`), no entity snapshots. Assumes entities unchanged for reproducibility

**Error Handling & Validation** (Fail-Fast Principle)
- **Filename Conflicts**: Fail with error, prompt user to rename/delete/abort. No auto-overwrite or versioning
- **DVC/Git Failures**: Stop immediately, show failure point, require manual cleanup (no auto-rollback)
- **Batch Size Limits**: 5 assets maximum. Reject entire batch if exceeded (no partial generation)
- **Rate Limits**: Fail immediately with API details (retry-after, quota info), log error, require manual retry
- **Missing Env Vars**: Validate before generation, fail with config error showing variable name and setup instructions
- **Resolution Mismatch**: Reject asset, prompt adjustment or acceptance of model's native resolution
- **Entity Dependencies**: No automated tracking - users manually search metadata for references before deletion

**Resource Constraints**
- **Batch Limit**: Maximum 5 assets per batch request to prevent resource exhaustion

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Setup and Validate MCP Servers (Priority: P1)

A developer needs to configure MCP server connections and validate that each supported asset type can successfully generate test outputs. This establishes confidence in the GenAI generation pipeline before any entity or production asset work begins.

**Why this priority**: Absolute foundational prerequisite. Without validated MCP/API connectivity, nothing else can proceed - entities are useless if the generation infrastructure doesn't work. This validates the technical feasibility of the entire system before investing effort in content structure or workflows.

**Independent Test**: Can be fully tested by configuring MCP server endpoints (or direct API fallback) in test entity files, then prompting Copilot to generate one test asset per supported type (greeting-card, informative-image, sprite-sheet, video) and verifying successful generation with DVC tracking.

**Acceptance Scenarios**:

1. **Given** MCP server endpoints configured in test entity files and API credentials in `.env` file, **When** I prompt Copilot to generate a test greeting card, **Then** the asset is successfully generated, saved to `content/test/`, and tracked by DVC
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
4. **Given** an entity with dependent assets, **When** I attempt to delete the entity, **Then** I receive a warning about dependent assets (user manually searches metadata files to identify dependencies)

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
2. **Given** batch generation parameters with variations in lighting (bright, dim, sunset), **When** I generate an environment asset batch, **Then** 3 images are produced with descriptive suffixes like `001-...-forest-bright.informative-image.png`, `001-...-forest-dim.informative-image.png`, `001-...-forest-sunset.informative-image.png`
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
- What happens when an entity has no compatible GenAI model defined in the model configuration file?
- When combining multiple entities with different model_config preferences (e.g., character prefers DALL-E MCP, style prefers Midjourney direct API), how is the final model selected?

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: System MUST provide entity template structure as YAML front-matter + Markdown files stored in `entities/<type>/` subdirectories (e.g., `entities/character/`, `entities/style/`, `entities/environment/`)
- **FR-002**: Entity files MUST follow naming pattern `entities/<type>/<name>.md` (e.g., `entities/character/max.md`). Names MUST use kebab-case with only alphanumeric characters and hyphens (no special characters). No feature prefix. Supported types: character, style, environment, entity-template.
- **FR-003**: System MUST support asset generation workflows via GitHub Copilot for types: informative images, greeting cards, sprite-sheets, videos
- **FR-004**: Entity templates MUST include model_config in YAML front-matter using discriminated union by provider. For MCP: `{provider: mcp, server: <mcp-server-name>, model: <model-name>}`. For direct API: `{provider: direct-api, endpoint: <url>, api_key: ${ENV_VAR}, model: <model-name>}`. MCP server names resolve to configurations in `.vscode/settings.json`.
- **FR-005**: System MUST provide custom Copilot prompt/workflow that tracks all generated binary assets using DVC with automatic commit and versioning. Workflow executes `dvc add <asset>` + `git add <asset>.dvc <metadata>.yaml` + `git commit` after asset generation and validation. Commit message format: `feat(asset): add <asset-type> with <entity1>, <entity2>` for single assets. Batch commits use format: `feat(asset): add <count> <asset-type> variations with <entities>` to group all batch assets in single commit.
- **FR-006**: System MUST generate and store metadata for each asset including: generation timestamp, entity references, model used, generation parameters
- **FR-007**: System MUST store asset metadata as YAML files version-controlled in git (separate from binary assets in DVC)
- **FR-008**: Copilot agents MUST validate entity file references exist before asset generation and provide clear error messages if missing
- **FR-009**: Copilot workflows MUST support batch asset generation (up to 5 assets per request) with entity variation parameters. Batch assets use descriptive suffixes encoding varied parameter values (e.g., `-bright`, `-watercolor-style`) when semantically meaningful, otherwise fall back to `-v1`, `-v2`, `-v3` sequential numbering.
- **FR-010**: Generated asset files MUST follow naming pattern `<feature>-<description>.<asset-type>.<ext>` (e.g., `009-diwali-greetings-lakshmi-on-a-lotus.insta-post.png`). Names MUST use kebab-case with only alphanumeric characters and hyphens (no special characters). Feature and description components must be filesystem-safe. Production assets stored in flat `content/` directory. P1 test assets stored in `content/test/` subdirectory.
- **FR-011**: System MUST log all GenAI model interactions including prompts, parameters, model versions, and response metadata to `logs/` directory. Each asset gets dedicated log file `logs/<asset-name>.log` containing all generation attempts for that asset.
- **FR-012**: System MUST provide Copilot agents for common workflows: entity creation, single asset generation, batch generation
- **FR-013**: System MUST integrate with MCP servers when available for enhanced GenAI model capabilities. Selection between MCP and direct API is config-driven per entity (no automatic runtime fallback).
- **FR-017**: When generating assets referencing multiple entities with different model_config preferences, the system MUST resolve model selection using asset-type default logic: use first entity's model_config or Copilot agent default for that asset type. Entity model preferences are informational, not binding.
- **FR-018**: P1 story MUST validate MCP/direct-API connectivity by generating one test asset per supported asset type (greeting-card, informative-image, sprite-sheet, video) and confirming successful generation with DVC tracking. Test assets stored in `content/test/` subdirectory, separate from production assets.
- **FR-019**: Copilot agents MUST validate generated asset resolution matches requested resolution. If mismatch detected, agent MUST reject asset with clear error message prompting user to adjust request or accept model's native resolution.
- **FR-020**: System MUST manage API credentials via environment variables stored in gitignored `.env` file. Entity model_config references credentials by env var name (e.g., `api_key: ${OPENAI_API_KEY}`), never hardcoded secrets. MCP server configurations stored in `.vscode/settings.json` (version-controlled) with env var references for secrets. Setup documentation MUST guide credential and MCP configuration.
- **FR-021**: Setup documentation MUST specify DVC remote storage as prerequisite, not part of P1 implementation. Reference DVC documentation for configuring S3, Azure, GCS, or local remote options.
- **FR-022**: Copilot agents MUST detect filename conflicts before generation. When target filename already exists in `content/` directory, agent MUST fail with clear error message and prompt user to: rename new asset, keep existing asset (abort generation), or manually delete old asset first before retrying. No automatic overwrites or versioning.
- **FR-023**: When DVC add or git commit operations fail during asset workflow, system MUST stop immediately and display clear error message indicating failure point (DVC operation vs git commit). User must manually clean up generated asset files, .dvc files, and git staging area before retrying. No automatic rollback or cleanup.
- **FR-024**: Copilot agents MUST validate batch generation requests before starting. When batch size exceeds 5 assets, agent MUST reject entire request with clear error message and prompt user to reduce batch size to 5 or fewer, or split into multiple separate requests. No partial generation or automatic batch splitting.
- **FR-025**: When GenAI API returns rate limit or quota exhaustion errors, Copilot agent MUST stop generation immediately and display clear error message including rate limit details from API response (retry-after time, quota reset time, exceeded limit type). Error MUST be logged to asset log file. User must manually retry after waiting. No automatic retries or request queueing.
- **FR-026**: Copilot agents MUST validate all environment variable references in entity model_config before starting asset generation. If .env file is missing or any referenced environment variable (e.g., `${OPENAI_API_KEY}`) is undefined, agent MUST fail immediately with clear error message specifying variable name and providing .env setup instructions. No fallback to empty values or alternative configurations.
- **FR-014**: Copilot agents MUST validate generated assets for format compliance and integrity before DVC commit
- **FR-015**: Asset metadata YAML files MUST capture complete generation parameters enabling Copilot to reproduce any asset. Entity references stored as file paths only (assumes entity files unchanged since generation).
- **FR-016**: System MUST provide prompt templates and agent files in `.github/prompts/` and `.github/agents/` following Spec-kit conventions

### Key Entities

- **Entity Template**: Stored as `entities/<type>/<name>.md` file (e.g., `entities/character/max.md`, `entities/entity-template/character.md`) with YAML front-matter (name, type, description, visual_properties, model_config: discriminated union by provider - MCP: {provider, server, model} or direct-api: {provider, endpoint, api_key, model}, creation_date, last_modified) + Markdown body. No feature prefix. Organized by type subdirectory. Copilot reads these files as context. MCP server names resolve from `.vscode/settings.json`. Asset type determines final model for multi-entity assets.
- **Asset**: Generated file following pattern `<feature>-<description>.<asset-type>.<ext>` (e.g., `009-diwali-greetings-lakshmi-on-a-lotus.insta-post.png`) with feature prefix matching current feature. Stored in `content/` directory. Attributes include asset_id, asset_type, file_path (DVC-tracked), metadata_path (git-tracked YAML), entity_references (list of entity paths like `entities/character/max.md`)
- **Asset Metadata**: YAML file (named `<asset-name>.meta.yaml`) stored in git containing generation_prompt (exact Copilot prompt used), model_name, model_version, entity_references (list of entity file paths like `entities/character/max.md` - no content snapshot, assumes entities unchanged), generation_parameters, resolution, file_format, dvc_hash, log_file (path to dedicated log file for this asset)
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
- API credentials for GenAI services are configured in gitignored `.env` file at workspace root
- MCP server configurations stored in `.vscode/settings.json` (version-controlled) with env var references resolving to `.env` secrets
- DVC is installed and configured with remote storage (S3/Azure/GCS/local) as prerequisite - not part of P1 implementation
- Users have basic familiarity with GitHub Copilot, file-based workflows, and @ file references
- Asset generation is not real-time - acceptable latency ranges from seconds (images) to minutes (videos) depending on model
- Entity templates are text-based descriptions (YAML + Markdown), not reference images (text-to-image workflow)
- Entity files remain unchanged after asset generation for reproducibility - metadata only stores entity paths, not content snapshots
- Storage capacity for DVC remote is sufficient for expected asset volume
- Model selection is config-driven per entity (no automatic runtime fallback between MCP and direct API). If MCP endpoint fails, generation fails - user must update entity config to direct API manually.
- When combining entities with different model preferences, asset type determines final model (uses first entity's model_config or Copilot agent default)
- P1 MCP validation story creates test assets in `content/test/` subdirectory to prove connectivity, separate from production assets
- Batch generation commits all assets in single git commit with batch summary message
- No automated entity dependency tracking - users manually search metadata files to identify asset dependencies before entity deletion
- Batch asset naming uses descriptive parameter-based suffixes when semantically meaningful (e.g., `-bright`, `-sunset`), otherwise sequential `-v1`, `-v2`
- Filesystem supports entity organization `entities/<type>/<name>.md` (no feature prefix) and asset naming `<feature>-<description>.<asset-type>.<ext>` (with feature prefix)
- Spec-kit framework is available for constitution, planning, and task management workflows

