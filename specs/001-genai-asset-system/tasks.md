---
description: "Task list for GenAI Asset Generation System feature implementation"
---

# Tasks: GenAI Asset Generation System

**Input**: Design documents from `/specs/001-genai-asset-system/`
**Prerequisites**: plan.md (required), spec.md (user stories), research.md, data-model.md, contracts/

## Format: `[ID] [P?] [Story] Description`

---

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Project initialization and basic structure

- [ ] T001 Create directory structure per plan.md in entities/, content/, logs/, .github/agents/
- [ ] T002 [P] Initialize DVC in workspace root
- [ ] T003 [P] Add DVC local remote for development in .dvc/config
- [ ] T004 [P] Create .env.example for API credentials (no secrets)
- [ ] T005 [P] Add .gitignore for .env, DVC cache, and logs/
- [ ] T006 [P] Create .vscode/settings.json with MCP server config example
- [ ] T007 [P] Create initial README.md with architecture summary

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core infrastructure that MUST be complete before ANY user story can be implemented

- [ ] T008 Create entity-template meta-template at entities/entity-template/entity-template.template.md (defines validation rules and quality gates structure for asset types; used to bootstrap other templates)
- [ ] T009 [P] Scaffold .github/agents/entity-creator.agent.md with workflow contract (implements template-driven validation using fail-fast approach; includes YAML array logging format specification per FR-011)
- [ ] T010 [P] Add prompt template for asset generation in .github/prompts/asset-generation.md
- [ ] T011 [P] Add prompt template for batch generation in .github/prompts/batch-generation.md
- [ ] T012 [P] Add prompt template for MCP validation in .github/prompts/mcp-validation.md
- [ ] T013 [P] Add .dvcignore for logs/ and temp files
- [ ] T014 [P] Document manual DVC remote setup in quickstart.md
- [ ] T054 Implement filename-conflict detection in entity-creator agent (abort generation if output file already exists; add operational test to verify detection works)
- [ ] T055 Implement entity versioning with `@vN` metadata references in entity YAML (allow mutable entities with audit trail; document versioning convention in quickstart.md)

**Checkpoint**: Foundation ready - entity-creator agent and templates define all validation logic; user story implementation can now begin in parallel

---

## Phase 3: User Story 1 - Define and Manage Entity Templates (Priority: P1) 🎯 MVP

**Goal**: Define reusable entity templates (characters, styles, environments) as YAML+Markdown files for entity-creator agent workflows. Templates define validation rules and quality gates (NOT logging format, which is part of entity-creator agent spec). This is the foundation; MCP config will be created in P2 using the entity-template meta-template.

**Independent Test**: Create a character entity file, verify entity-creator agent can read and reference it in prompts.

- [ ] T015 [US1] Create character template at entities/entity-template/character.template.md (include validation rules)
- [ ] T016 [US1] Create style template at entities/entity-template/style.template.md (include validation rules)
- [ ] T017 [US1] Create environment template at entities/entity-template/environment.template.md (include validation rules)
- [ ] T018 [US1] Create scene template at entities/entity-template/scene.template.md (include validation rules for scene descriptions)
- [ ] T019 [US1] Create example entities (one per type: character, style, environment) at entities/<type>/ with descriptive kebab-case names, YAML front-matter with model_config, and Markdown descriptions
- [ ] T020 [US1] Validate entity file naming and kebab-case enforcement
- [ ] T021 [US1] Update quickstart.md with template/entity creation steps

**Checkpoint**: Entity templates and examples are available and entity-creator agent can read them; templates define all validation/logging logic

---

## Phase 3.5: Scene Generation (Priority: P2) 🎯 MVP

**Goal**: Generate scene entity files (Markdown descriptions) using entity-creator agent. Scenes combine character, style, and environment entities into narrative descriptions that serve as input for image generation via MCP.

**Independent Test**: Prompt entity-creator agent to generate a scene combining character, style, and environment entities, verify scene .md file is created in entities/scene/.

- [ ] T022 [US2] Generate scene entity file at entities/scene/ combining character, style, and environment via entity-creator agent
- [ ] T023 [US2] Validate scene file format (YAML front-matter with entity references + Markdown narrative description)
- [ ] T024 [US2] Update quickstart.md with scene generation workflow

**Checkpoint**: Scene generation workflow is functional; scenes serve as input for image generation

---

## Phase 4: MCP Configuration and Image Validation (Priority: P3) 🎯 MVP

**Goal**: Create MCP config template (using entity-template from P1), build MCP server configurations, then validate connectivity by generating test images using scene entities. MCP config itself is template-created, decoupled from entity-creator agent.

**Independent Test**: Use entity-template to create MCP config template, configure MCP servers, prompt entity-creator agent to generate test image from scene entity, verify DVC tracking in content/test/.

- [ ] T025 [US3] Create MCP config template at entities/entity-template/mcp-config.template.md using entity-template meta-template (defines MCP server configuration structure)
- [ ] T026 [US3] Use MCP config template to configure MCP servers in .vscode/settings.json
- [ ] T027 [US3] Add MCP and direct-api model_config examples to test scene entity
- [ ] T028 [US3] Generate test image in content/test/ from scene entity via entity-creator agent prompt
- [ ] T029 [US3] Track test image with DVC and commit
- [ ] T030 [US3] Validate DVC tracking and asset metadata YAML for test image
- [ ] T031 [US3] Document MCP validation workflow in quickstart.md

**Checkpoint**: System can generate and track images from scene entities; entity-creator agent validates MCP connectivity

---

## Phase 5: Single Image Generation (Priority: P4) 🎯 MVP

**Goal**: Use entity-creator agent with scene entity to generate a single image, tracked by DVC, with metadata. Agent validates using template-driven rules. Requires scene entities and MCP validation.

**Independent Test**: Prompt entity-creator agent to generate an image from a scene entity, verify image and metadata in content/.

- [ ] T032 [US4] Generate image from scene entity via entity-creator agent prompt
- [ ] T033 [US4] Validate image naming pattern and DVC tracking
- [ ] T034 [US4] Validate image metadata YAML includes scene entity reference and generation parameters
- [ ] T035 [US4] Document single image generation workflow in quickstart.md

**Checkpoint**: Single asset generation is functional and independently testable; entity-creator agent applies template-driven validation

---

## Phase 6: Batch Image Generation (Priority: P5)

**Goal**: Generate multiple image variations in sequence (up to 5 per batch) using entity-creator agent with different scene entities or parameters, each tracked and versioned.

**Independent Test**: Prompt entity-creator agent to generate 3 image variations from different scenes, verify all images and metadata in content/.

- [ ] T036 [US5] Generate batch of images from multiple scene entities via entity-creator agent prompt
- [ ] T037 [US5] Validate batch image naming and DVC tracking
- [ ] T038 [US5] Validate batch commit message format
- [ ] T039 [US5] Document batch generation workflow in quickstart.md

**Checkpoint**: Batch asset generation is functional and independently testable; entity-creator agent handles batch validation

---

## Phase 7: Browse Images via VS Code File Explorer (Priority: P6)

**Goal**: Browse generated images and metadata in VS Code file explorer and retrieve versions via DVC.

**Independent Test**: Generate several images, browse content/ in VS Code, and view metadata YAML files.

- [ ] T040 [US6] Generate multiple images and metadata files in content/
- [ ] T041 [US6] Validate image and metadata file discoverability in VS Code
- [ ] T042 [US6] Validate DVC version history for images
- [ ] T043 [US6] Document image browsing and DVC usage in quickstart.md

**Checkpoint**: Image browsing and version retrieval are functional

---

## Phase 8: Polish & Cross-Cutting Concerns

**Purpose**: Improvements that affect multiple user stories

- [ ] T044 [P] Documentation updates in README.md and quickstart.md
- [ ] T045 [P] Code and template cleanup in entities/ and .github/
- [ ] T046 [P] Performance optimization for entity-creator agent workflows
- [ ] T047 [P] Additional template-driven validation for edge cases (e.g., missing env vars, batch size limits)
- [ ] T048 [P] Security review for credential handling
- [ ] T049 [P] Run full quickstart.md validation walkthrough

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies - can start immediately
- **Foundational (Phase 2)**: Depends on Setup completion - BLOCKS all user stories
- **User Stories (Phase 3+)**: All depend on Foundational phase completion
  - User stories can then proceed in parallel (if staffed)
  - Or sequentially in priority order (P1 → P2 → P3 → P4 → P5)
- **Polish (Final Phase)**: Depends on all desired user stories being complete

### User Story Dependencies

- **User Story 1 (P1 - Entity Templates)**: Can start after Foundational (Phase 2) - No dependencies on other stories
- **User Story 2 (P2 - MCP Validation)**: Requires User Story 1 completion - needs test entities with model configs
- **User Story 3 (P3 - Single Asset)**: Requires User Story 1 and 2 completion - needs entities and validated MCP connectivity
- **User Story 4 (P4 - Batch Assets)**: Requires User Story 1 and 2 completion - needs entities and validated MCP connectivity
- **User Story 5 (P5 - Browse Assets)**: Requires User Story 3 or 4 - needs generated assets to browse

### Parallel Opportunities

- All [P] tasks in Setup and Foundational can run in parallel
- All user stories can be implemented in parallel after Foundational
- Within each story, asset/entity creation tasks can run in parallel if they touch different files

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup
2. Complete Phase 2: Foundational (CRITICAL - blocks all stories)
3. Complete Phase 3: User Story 1
4. **STOP and VALIDATE**: Test User Story 1 independently
5. Deploy/demo if ready

### Incremental Delivery

1. Complete Setup + Foundational → Foundation ready
2. Add User Story 1 → Test independently → Deploy/Demo (MVP!)
3. Add User Story 2 → Test independently → Deploy/Demo
4. Add User Story 3 → Test independently → Deploy/Demo
5. Each story adds value without breaking previous stories

### Parallel Team Strategy

- Team completes Setup + Foundational together
- Once Foundational is done:
  - Developer A: User Story 1
  - Developer B: User Story 2
  - Developer C: User Story 3
- Stories complete and integrate independently

---

## Notes

- [P] tasks = different files, no dependencies
- [Story] label maps task to specific user story for traceability
- Each user story should be independently completable and testable
- Commit after each task or logical group
- Stop at any checkpoint to validate story independently
- Avoid: vague tasks, same file conflicts, cross-story dependencies that break independence
