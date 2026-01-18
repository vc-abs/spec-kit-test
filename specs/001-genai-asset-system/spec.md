# Feature Specification: GenAI Asset Generation System

**Feature Branch**: `001-genai-asset-system`
**Created**: 2026-01-04
**Status**: Draft
**Input**: User description: "Build an asset generation tool/system that utilizes GenAI tools and DVC to create image assets. The system should create and maintain abstract entities (style, environment, character, scene). Images will be created based on scene entities that combine multiple entity types. It should leverage the right model to generate images."

## Clarifications

### Session 2026-01-04

### Session 2026-01-09

- Q: Should entity types be explicitly enumerated or open-ended? → A: Leave entity types open-ended for future extensibility
- Q: Should circular dependencies between entities be allowed? → A: Allow circular dependencies between entities, with explicit cycle detection and handling. Example: Max is the son of Min and Min is the father of Max.
- Q: Should entity update/modification be allowed? → A: Allow entity update/modification, but require explicit versioning and audit trail (clarified 2026-01-09)
- Q: Should a formal requirement ID scheme and traceability mapping be established? → A: No formal requirement ID scheme; rely on section headings and manual cross-referencing (clarified 2026-01-09)
- Q: How should major edge cases be handled? → A: Specify fallback and error handling for all major edge cases (malformed YAML, binary generation failure, large descriptions, unsupported asset types, infinite recursion, detached HEAD, DVC full) (clarified 2026-01-09)
- Q: Should entity type lists be aligned and reflect extensibility? → A: Update FR-002 to reflect open-ended entity types with examples rather than closed list (clarified 2026-01-09)
- Q: What are network connectivity assumptions for API calls? → A: Document assumption: stable network connectivity required for API calls, with retry/timeout configuration for network resilience (clarified 2026-01-09)
- Q: How to resolve entity immutability conflict? → A: Entities are mutable with explicit versioning and audit trail; update assumptions to reflect versioned mutability model (clarified 2026-01-09)
- Q: How should concurrent entity creation be handled? → A: Auto generation workflows support concurrent entity creation; user-assisted generation (Copilot prompts) is sequential or batched (max 5 assets) (clarified 2026-01-09)
- Q: Are accessibility requirements needed for keyboard navigation and screen reader compatibility? → A: Out-of-scope: system is Copilot workflow-based with no custom UI; accessibility depends on VS Code's built-in support (clarified 2026-01-09)

**Scope & Architecture**

- **System Type**: Copilot workflow (NOT CLI tool) - Use Spec-kit with GitHub Copilot to generate images via prompts and agents
- **Implementation Priority**: P1 entity templates → P2 scene generation → P3 MCP validation → P4+ image generation. Scene entities serve as input for image generation.
- **MCP Validation**: Connection test + single test image generation from scene entity

**Storage & Organization**

- **Entity Storage**: YAML front-matter + Markdown files at `entities/<type>/<name>.md` (e.g., `entities/character/<name>.md`, `entities/scene/<name>.md`)
- **Asset Storage**: Flexible, context-driven organization. Examples: flat `content/` for simple projects, `content/<feature>/` for feature-based organization, `content/<type>/` for type-based grouping. Test assets in dedicated `test/` subdirectory within chosen structure (e.g., `content/test/` or `content/<feature>/test/`).
- **Naming Convention**: Kebab-case with only alphanumeric + hyphens. No special characters. Entities: `<type>/<name>.md`. Assets: `<feature>-<description>.<asset-type>.<ext>` or `<context>/<name>.<asset-type>.<ext>` depending on organization choice.
- **Batch Naming**: Descriptive suffixes for parameter variations (e.g., `-bright`, `-sunset`), fallback to `-v1`, `-v2`
- **Logs**: Per-asset files at `logs/<asset-name>.log` (naming constraints ensure filesystem safety)

**Model Configuration Architecture**

- **Config Location**: Inline in entity YAML front-matter (model_config field). MCP server details in `.vscode/settings.json` (version-controlled). Credentials in `.env` (gitignored)
- **Config Structure**: Discriminated union by provider field. MCP: `{provider: mcp, server: <name>, model: <model>}`. Direct API: `{provider: direct-api, endpoint: <url>, api_key: ${ENV_VAR}, model: <model>}`
- **Model Resolution**: When entities have different preferences, asset type determines final model (first entity's model_config or agent default). No runtime fallback between MCP/direct-api
- **MCP Endpoint Updates**: Entity references MCP server name; endpoint details in `.vscode/settings.json` updated centrally

**Asset Format & Parameters**

- **Format Specification**: Template-driven. MVP focuses on image generation from scene entities. Format details defined in entity-template files or Copilot prompts
- **Parameter Source**: Flexible - entity-template files for reusable configs, or Copilot prompt for one-off customizations

**DVC & Version Control**

- **DVC Workflow**: Custom Copilot prompt/workflow executes `dvc add <asset>` + `git add`, then prompts user for commit approval before executing `git commit`
- **DVC Prerequisite**: Remote storage (S3/Azure/GCS/local) configured before P2 (MCP validation) - not part of implementation
- **Commit Format**: Single assets: `feat(asset): add <type> with <entity1>, <entity2>`. Batches: `feat(asset): add <count> <type> variations with <entities>`
- **Batch Commits**: All batch assets in single atomic commit
- **Metadata**: Path references with version tracking (e.g., `entities/character/<name>.md@v2`, `entities/scene/<name>.md@v1`). Entity versioning ensures reproducibility

**Error Handling & Validation** (Fail-Fast Principle)

- **Filename Conflicts**: Fail with error, prompt user to rename/delete/abort. No auto-overwrite or versioning
- **DVC/Git Failures**: Stop immediately, show failure point, require manual cleanup (no auto-rollback)
- **Batch Size Limits**: 5 assets maximum. Reject entire batch if exceeded (no partial generation)
- **Rate Limits**: Fail immediately with API details (retry-after, quota info), log error, require manual retry
- **Missing Env Vars**: Validate before generation, fail with config error showing variable name and setup instructions
- **Resolution Mismatch**: Reject asset, prompt adjustment or acceptance of model's native resolution
- **Entity Dependencies**: No automated tracking - users manually search metadata for references before deletion

### Validation Model (Hybrid Approach)

The system uses a hybrid validation model that balances pre-checks with fail-fast runtime behavior:

- **Templates Define Rules**: Asset-type templates declare validation rules including format requirements, resolution constraints, required environment variables, and quality gates. The entity-template meta-template defines the structure for these validation rules. Validation rules can be specified in YAML front-matter (structured) or Markdown body (free-form documentation) based on complexity.
- **Agent Implements Validation**: The entity-creator agent implements template-defined rules and exposes an optional `validate` pre-check command.
- **Optional Pre-Checks**: The `validate` command verifies:
  - Required `.env` variables are defined
  - MCP endpoint reachability (if using MCP servers)
  - DVC remote configuration (optional warning if missing)
- **Fail-Fast Generation**: Generation itself remains fail-fast for runtime errors. If a required environment variable is missing or an API call fails during generation, the agent stops immediately with a clear error message.
- **Iterative Workflow**: The entity-creator agent follows a validation → implementation → verification cycle, iterating until successful conclusion or explicit user abort.

### Entity-Creator Workflow

The entity-creator agent implements an iterative quality assurance workflow:

1. **Validation Phase**: Check prerequisites (entities exist, env vars defined, optional pre-checks pass)
2. **Implementation Phase**: Execute generation (call GenAI APIs, create assets, track with DVC)
3. **Verification Phase**: Validate outputs (format compliance, resolution match, metadata completeness)
4. **Iteration**: If verification fails, log errors and allow user to adjust parameters and retry
5. **Conclusion**: When verification passes, commit assets with user approval

This workflow ensures quality without requiring strict test-first development, making the system accessible to non-technical content creators.

**Resource Constraints**

- **Batch Limit**: Maximum 5 assets per batch request to prevent resource exhaustion

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Define and Manage Entity Templates (Priority: P1)

A content creator needs to define reusable entity templates (characters, styles, environments, scenes) as structured files that the entity-creator agent can read and use for consistent image generation. These templates capture core attributes, visual properties, and model configuration preferences in YAML front-matter + Markdown format.

**Why this priority**: Foundation for all workflows. Entity templates define the structure that both validation and production workflows depend on.

**Independent Test**: Can be fully tested by creating a character entity file `entities/character/<name>.md` with YAML front-matter (name, type, visual_properties, model_config with provider/endpoint/model) and Markdown description, then verifying the entity-creator agent can read and reference it in prompts.

**Acceptance Scenarios**:

1. **Given** no existing entity files, **When** I create `entities/character/<name>.md` with YAML front-matter containing character attributes and model_config, **Then** the file is saved in `entities/character/` directory and the entity-creator agent can access it as context
2. **Given** an existing style entity `entities/style/<name>.md`, **When** I update its model_config to switch from MCP to direct API, **Then** the updated configuration is persisted in YAML front-matter
3. **Given** multiple entities of different types, **When** I list all entities, **Then** I see entities organized by type folders (character/, style/, environment/, scene/)
4. **Given** an entity with dependent images, **When** I attempt to delete the entity, **Then** I receive a warning about dependent images (user manually searches metadata files to identify dependencies)

---

### User Story 2 - Generate Scene Entities (Priority: P2)

A content creator uses the entity-creator agent to generate scene entity files (Markdown descriptions) that combine character, style, and environment entities. These scene descriptions serve as input for image generation via MCP.

**Why this priority**: Scenes are the bridge between entity templates and image generation. Scene entities combine multiple entity types into narrative descriptions that drive image generation.

**Independent Test**: Can be fully tested by prompting the entity-creator agent to generate a scene combining character, style, and environment entities, and verifying a scene .md file is created in `entities/scene/` with proper YAML front-matter and narrative description.

**Acceptance Scenarios**:

1. **Given** character, style, and environment entities exist, **When** I prompt the entity-creator agent to generate a scene combining these entities, **Then** a scene .md file is created at `entities/scene/<name>.md` with entity references in YAML front-matter and narrative description in Markdown body
2. **Given** a scene entity file, **When** I review its YAML front-matter, **Then** I see references to source entities (character, style, environment) with version tags
3. **Given** multiple scene entities, **When** I browse `entities/scene/` directory, **Then** I see scene files organized and ready for image generation

---

### User Story 3 - MCP Configuration and Image Validation (Priority: P3)

A developer creates an MCP config template (using the entity-template meta-template from P1), then uses it to build MCP server configurations for this system. Once MCP is configured, they validate connectivity by generating a test image from a scene entity.

**Why this priority**: Validates infrastructure after scene generation. MCP config itself is created via template (decoupled from entity-creator). This story proves MCP/API connectivity works with scene-driven image generation before production use.

**Independent Test**: Can be fully tested by: 1) Using entity-template to create an MCP config template, 2) Using that template to configure MCP servers, 3) Prompting the entity-creator agent to generate a test image from a scene entity and verifying successful generation with DVC tracking.

**Acceptance Scenarios**:

1. **Given** scene entity with MCP server endpoints and API credentials in `.env` file, **When** I prompt the entity-creator agent to generate a test image from the scene, **Then** the image is successfully generated, saved to `content/test/`, and tracked by DVC
2. **Given** an MCP server connection fails, **When** the scene entity specifies direct API fallback config, **Then** the entity-creator agent uses the direct API endpoint and generation succeeds
3. **Given** an invalid MCP server endpoint in scene entity config, **When** I attempt test generation, **Then** the entity-creator agent provides clear error message indicating connection failure and suggests checking endpoint configuration

---

### User Story 4 - Generate Single Image from Scene (Priority: P4)

A content creator uses the entity-creator agent with a scene entity to generate a single image. The agent generates the image using the model configuration specified in the scene entity (MCP server or direct API).

**Why this priority**: Core value proposition - generating production images with the entity-creator agent from scene entities. This story delivers immediate value by producing actual output, building on validated MCP infrastructure.

**Independent Test**: Can be fully tested by opening a scene entity file `entities/scene/<name>.md` in workspace, prompting the entity-creator agent "Generate an image from this scene", and verifying an image is generated, tracked by DVC, with metadata.

**Acceptance Scenarios**:

1. **Given** scene entity file `entities/scene/<name>.md` exists in workspace, **When** I prompt the entity-creator agent to generate an image from the scene, **Then** the agent generates an image with descriptive name, saves it to `content/`, tracks it with DVC, and creates a metadata YAML file
2. **Given** a scene entity with model_config specifying direct API endpoint, **When** I request image generation, **Then** the entity-creator agent uses the configured model from scene config and produces the image
3. **Given** generation parameters including resolution "1024x1024", **When** I generate an image, **Then** the output matches the specified resolution
4. **Given** a failed generation attempt, **When** the GenAI model returns an error, **Then** I see a clear error message and no partial image is saved

---

### User Story 5 - Generate Batch Images from Scenes (Priority: P5)

A content creator uses the entity-creator agent to generate multiple image variations in sequence from different scene entities or parameters. The agent iterates up to 5 times per batch request.

**Why this priority**: Efficiency improvement over single generation. Batch workflows save time but are not essential for MVP - users can manually prompt the entity-creator agent multiple times.

**Independent Test**: Can be fully tested by prompting the entity-creator agent "Generate images from these 3 scene entities" and verifying 3 distinct images are generated with unique filenames, each tracked and versioned.

**Acceptance Scenarios**:

1. **Given** 3 scene entity files in `entities/scene/`, **When** I prompt the entity-creator agent for batch image generation from all scenes, **Then** 3 images are generated sequentially, each tracked by DVC with unique filenames
2. **Given** batch generation parameters with variations, **When** I generate image batch, **Then** images are produced with descriptive suffixes or sequential versioning
3. **Given** a batch operation in progress, **When** one image fails to generate, **Then** the batch continues and I receive a summary of successes and failures

---

### User Story 6 - Browse Images via VS Code File Explorer (Priority: P6)

A content creator browses previously generated images using VS Code's file explorer in the `content/` directory and retrieves specific versions from DVC history using standard DVC commands in the terminal.

**Why this priority**: Nice-to-have for image management but not required for core generation workflow. VS Code's built-in file explorer provides sufficient browsing capability.

**Independent Test**: Can be fully tested by generating several images, then using VS Code file explorer to navigate `content/` directory and view associated metadata YAML files.

**Acceptance Scenarios**:

1. **Given** 20 generated images in `content/` directory, **When** I use VS Code's file search to filter by image extension (e.g., `.png`), **Then** I see images with associated metadata YAML files
2. **Given** an image file in VS Code, **When** I open its corresponding metadata YAML file, **Then** I can see scene entity reference with path (e.g., `entities/scene/<name>.md`) and generation parameters
3. **Given** an image tracked by DVC, **When** I run `dvc diff` in terminal, **Then** I see version history for that image
4. **Given** multiple image directories, **When** I use VS Code's file search (Ctrl+P), **Then** I can quickly locate any image by filename

---

### Edge Cases

- What happens when a referenced entity file is deleted while Copilot is generating an asset? → Fail-fast with clear error message (entity file not found)
- What happens when an entity has no compatible GenAI model defined in the model configuration file? → Fail-fast with error; use entity-creator agent default as fallback only if explicitly configured in agent
- When combining multiple entities with different model_config preferences, how is the final model selected? → Scene entity model_config determines primary model; templates may define multi-step orchestration with different models per step

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: System MUST provide entity template structure as YAML front-matter + Markdown files stored in `entities/<type>/` subdirectories (e.g., `entities/character/`, `entities/style/`, `entities/environment/`)
- **FR-002**: Entity files MUST follow naming pattern `entities/<type>/<name>.md` (e.g., `entities/character/<name>.md`, `entities/scene/<name>.md`). Names MUST use kebab-case with only alphanumeric characters and hyphens (no special characters). No feature prefix. Entity types are extensible and open-ended. MVP types: character, style, environment, scene, entity-template. Future types may include: script, video, audio.
- **FR-003**: System MUST support image generation workflows via GitHub Copilot from scene entities. MVP focuses on image generation; future expansion may include video, sprite-sheets, etc.
- **FR-004**: Entity templates MUST include model_config in YAML front-matter using discriminated union by provider. For MCP: `{provider: mcp, server: <mcp-server-name>, model: <model-name>}`. For direct API: `{provider: direct-api, endpoint: <url>, api_key: ${ENV_VAR}, model: <model-name>}`. MCP server names resolve to configurations in `.vscode/settings.json`.
- **FR-005**: System MUST provide custom Copilot prompt/workflow that tracks all generated binary assets using DVC with human-approved commit and versioning. After asset generation and validation, workflow executes `dvc add <asset>` + `git add <asset>.dvc <metadata>.yaml`, then MUST present proposed commit message to user for approval before executing `git commit`. Commit message format: `feat(asset): add <asset-type> with <entity1>, <entity2>` for single assets. Batch commits use format: `feat(asset): add <count> <asset-type> variations with <entities>` to group all batch assets in single commit. User MUST explicitly approve (via typing "yes", "commit", or confirming) before commit executes.
- **FR-006**: System MUST generate and store metadata for each asset including: generation timestamp, entity references, model used, generation parameters
- **FR-007**: System MUST store asset metadata as YAML files version-controlled in git (separate from binary assets in DVC)
- **FR-008**: Entity-creator agent MUST validate entity file references exist before asset generation and provide clear error messages if missing
- **FR-009**: Entity-creator agent MUST support batch asset generation (up to 5 assets per request) with entity variation parameters. Batch assets use descriptive suffixes encoding varied parameter values (e.g., `-bright`, `-watercolor-style`) when semantically meaningful, otherwise fall back to `-v1`, `-v2`, `-v3` sequential numbering.
- **FR-010**: Generated image files MUST follow naming pattern appropriate to chosen organizational structure. Examples: `<feature>-<description>.image.<ext>` (e.g., `001-genai-asset-system-scene-01.image.png`) for flat structure, or `<context>/<name>.image.<ext>` for hierarchical organization. Names MUST use kebab-case with only alphanumeric characters and hyphens (no special characters). Production images stored in `content/` (or subdirectories). P3 MCP validation test images stored in dedicated `test/` subdirectory within chosen structure.
- **FR-011**: Entity-creator agent MUST log all GenAI model interactions including prompts, parameters, model versions, and response metadata to `logs/` directory. Logs are stored as YAML arrays with each attribute on a new line for human readability (target audience: non-technical content creators). Log schema includes: timestamp, level, status, step, activity, model, model_version, duration_s (in seconds with decimal precision). Each feature gets dedicated log file `logs/<feature-id>.log` containing all generation attempts for that feature.

  **Logging Format Example:**

  ```yaml
  - timestamp: 2026-01-19T14:23:00Z
    level: INFO
    status: intent-understood
    step: 1
    activity: generate_image_from_scene
    notes: "User requested image generation from scene entity"
  - timestamp: 2026-01-19T14:23:01Z
    level: INFO
    status: success
    step: 2
    activity: generate_image_from_scene
    model: dall-e-3
    model_version: "2024-01"
    duration_s: 4.5
  - timestamp: 2026-01-19T14:28:15Z
    level: ERROR
    status: failed
    step: 3
    activity: generate_image_from_scene
    model: dall-e-3
    model_version: "2024-01"
    duration_s: 1.2
    error: "API rate limit exceeded"
  ```

- **FR-012**: System MUST provide entity-creator agent for common workflows: entity creation, single asset generation, batch generation, MCP validation
- **FR-013**: System MUST integrate with MCP servers when available for enhanced GenAI model capabilities. Selection between MCP and direct API is config-driven per entity (no automatic runtime fallback).
- **FR-017**: When generating assets referencing multiple entities with different model_config preferences, the system MUST resolve model selection using asset-type default logic: use first entity's model_config or entity-creator agent default for that asset type. Entity model preferences are informational, not binding.
- **FR-018**: P3 story (MCP Validation) MUST validate MCP/direct-API connectivity by generating one test image from a scene entity and confirming successful generation with DVC tracking. Test image stored in `content/test/` subdirectory, separate from production images. Requires P1 entity templates and P2 scene entities.
- **FR-019**: (Merged into FR-014) Resolution validation is template-driven and fail-fast.
- **FR-020**: System MUST manage API credentials via environment variables stored in gitignored `.env` file. Entity model_config references credentials by env var name (e.g., `api_key: ${OPENAI_API_KEY}`), never hardcoded secrets. MCP server configurations stored in `.vscode/settings.json` (version-controlled) with env var references for secrets. Setup documentation MUST guide credential and MCP configuration.
- **FR-021**: Setup documentation MUST specify DVC remote storage as prerequisite, not part of P2 (MCP validation) implementation. Reference DVC documentation for configuring S3, Azure, GCS, or local remote options.
- **FR-022**: Entity-creator agent MUST detect filename conflicts before generation. When target filename already exists in `content/` directory, agent MUST fail with clear error message and prompt user to: rename new asset, keep existing asset (abort generation), or manually delete old asset first before retrying. No automatic overwrites or versioning.
- **FR-023**: When DVC add or git commit operations fail during asset workflow, system MUST stop immediately and display clear error message indicating failure point (DVC operation vs git commit). User must manually clean up generated asset files, .dvc files, and git staging area before retrying. No automatic rollback or cleanup.
- **FR-024**: Entity-creator agent MUST validate batch generation requests before starting. When batch size exceeds 5 assets, agent MUST reject entire request with clear error message and prompt user to reduce batch size to 5 or fewer, or split into multiple separate requests. No partial generation or automatic batch splitting.
- **FR-025**: When GenAI API returns rate limit or quota exhaustion errors, entity-creator agent MUST stop generation immediately and display clear error message including rate limit details from API response (retry-after time, quota reset time, exceeded limit type). Error MUST be logged to asset log file. User must manually retry after waiting. No automatic retries or request queueing.
- **FR-026**: Entity-creator agent MUST enforce template-driven validation with hybrid pre-check support. The agent exposes an optional `validate` command that verifies required environment variables, MCP endpoint reachability, and DVC remote configuration. Generation remains fail-fast: if .env file is missing or any referenced environment variable (e.g., `${OPENAI_API_KEY}`) is undefined at generation time, agent MUST fail immediately with clear error message specifying variable name and providing .env setup instructions. No fallback to empty values or alternative configurations. Validation rules are defined in asset-type templates.
- **FR-014**: Entity-creator agent MUST validate generated assets for format compliance, integrity, and resolution match. Validation rules are defined in asset-type templates and implemented by the entity-creator agent. Validation is fail-fast: errors are surfaced as encountered during generation, with no pre-validation.
- **FR-015**: Asset metadata YAML files MUST capture complete generation parameters enabling entity-creator agent to reproduce any asset. Entity references stored as file paths only (assumes entity files unchanged since generation).
- **FR-016**: System MUST provide prompt templates and agent files in `.github/prompts/` and `.github/agents/` following Spec-kit conventions

### Key Entities

- **Entity Template**: Stored as `entities/<type>/<name>.md` file (e.g., `entities/character/<name>.md`, `entities/scene/<name>.md`, `entities/entity-template/character.template.md`) with YAML front-matter (name, type, description, visual_properties or narrative_description, model_config: discriminated union by provider - MCP: {provider, server, model} or direct-api: {provider, endpoint, api_key, model}, creation_date, last_modified) + Markdown body. No feature prefix. Organized by type subdirectory. Copilot reads these files as context. MCP server names resolve from `.vscode/settings.json`. Scene entities reference other entities and provide narrative descriptions for image generation.
- **Asset**: Generated image file following pattern `<feature>-<description>.image.<ext>` (e.g., `001-genai-asset-system-scene-01.image.png`) with feature prefix matching current feature. Stored in `content/` directory. Attributes include asset_id, asset_type (image), file_path (DVC-tracked), metadata_path (git-tracked YAML), scene_reference (path to scene entity like `entities/scene/<name>.md`)
- **Asset Metadata**: YAML file (named `<asset-name>.meta.yaml`) stored in git containing generation_prompt (exact Copilot prompt used), model_name, model_version, scene_reference (scene entity path with version reference like `entities/scene/<name>.md@v1` for reproducibility), generation_parameters, resolution, file_format, dvc_hash, log_file (path to dedicated log file for this asset)
- **Entity-Creator Agent**: Agent file in `.github/agents/entity-creator.agent.md` that defines image generation workflows (single, batch, MCP validation) from scene entities. Implements the iterative validation → implementation → verification workflow cycle, iterating until conclusion or user abort. Validation rules are declared in asset-type templates and implemented by the agent; supports optional pre-checks via `validate` command while maintaining fail-fast behavior during generation.
- **Prompt Template**: Prompt template in `.github/prompts/` guiding users on how to request image generation from scene entity references with model config specification

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Users can create an entity file and prompt Copilot to generate an asset using it in under 3 minutes
- **SC-002**: Generated assets are tracked by DVC with correct versioning and metadata YAML files 100% of the time
- **SC-003**: Image generation success rate via Copilot workflow from scene entities exceeds 95%
- **SC-004**: System logs every GenAI interaction with complete prompt and parameter history to `logs/` directory
- **SC-005**: Batch generation of 5 images (max limit) from scene entities via Copilot completes in under 5 minutes (excluding model API latency)
- **SC-006**: Image metadata YAML allows entity-creator agent to reproduce any image with identical scene entity snapshot and generation parameters
- **SC-007**: Users can navigate `content/` directory and filter images by filename pattern (e.g., `*.image.png`, `*.png`) in under 30 seconds
- **SC-008**: Entity-creator agent handles GenAI API failures gracefully without data loss or orphaned images

## Assumptions

- GitHub Copilot is installed and configured in the workspace
- GenAI model APIs (image generation) are accessible via MCP servers or direct API integration
- API credentials for GenAI services are configured in gitignored `.env` file at workspace root
- MCP server configurations stored in `.vscode/settings.json` (version-controlled) with env var references resolving to `.env` secrets
- DVC is installed and configured with remote storage (S3/Azure/GCS/local) as prerequisite - not part of P2 (MCP validation) implementation
- Users have basic familiarity with GitHub Copilot, file-based workflows, and @ file references
- Image generation is not real-time - acceptable latency ranges from seconds to tens of seconds depending on model and resolution
- Entity templates are text-based descriptions (YAML + Markdown), not reference images (text-to-image workflow)
- Entity files are mutable with explicit versioning and audit trail; metadata stores entity paths with version references for reproducibility
- Storage capacity for DVC remote is sufficient for expected asset volume
- Single entity templates may orchestrate multiple GenAI models for multi-step generation (e.g., generate image with DALL-E, then enhance with another model); each step tracked in logs with separate model_config
- Model selection is config-driven per entity (no automatic runtime fallback between MCP and direct API). If MCP endpoint fails, generation fails - user must update entity config to direct API manually.
- When combining entities with different model preferences, asset type determines final model (uses first entity's model_config or entity-creator agent default)
- P2 MCP validation story creates test assets in `content/test/` subdirectory to prove connectivity, separate from production assets
- Batch generation commits all assets in single git commit with batch summary message
- No automated entity dependency tracking - users manually search metadata files to identify asset dependencies before entity deletion
- Batch asset naming uses descriptive parameter-based suffixes when semantically meaningful (e.g., `-bright`, `-sunset`), otherwise sequential `-v1`, `-v2`
- Filesystem supports entity organization `entities/<type>/<name>.md` (no feature prefix) and flexible asset naming patterns based on chosen organizational structure
- Spec-kit framework is available for constitution, planning, and task management workflows
- All validation (format, resolution, env config) is template-driven and handled by the entity-creator agent using fail-fast approach - no pre-validation
- Asset organization is contextual and flexible: flat structure for simple projects, hierarchical (by feature or type) for larger projects
