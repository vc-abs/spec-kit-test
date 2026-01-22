---
description: "Task list for GenAI Asset Generation System feature implementation"
---

# Tasks: GenAI Asset Generation System

**Input**: Design documents from `/specs/001-genai-asset-system/`
**Prerequisites**: plan.md (required), spec.md (user stories), research.md, data-model.md, contracts/

## Format: `[ID] [P?] [Story] Description`

---

## Phase 1: Directory Structure

**Purpose**: Create basic directory structure for entities and content

- [X] T001 Create directory structure per plan.md in entities/, content/, logs/, .github/agents/
- [X] T002 [P] Add .gitignore for logs/ and future .env files
- [X] T003 [P] Update README.md with project structure overview

---

## Phase 2: Entity Template Bootstrap

**Purpose**: Create the meta-template that defines how all entity templates work

- [X] T004 Create entity-template meta-template at entities/entity-templates/entity-template.template.md (defines validation rules and quality gates structure for asset types; used to bootstrap other templates)
- [X] T005 [P] Scaffold .github/agents/entity-creator.agent.md with workflow contract (implements template-driven validation using fail-fast approach; includes YAML array logging format specification per FR-011)
- [X] T006 [P] Implement filename-conflict detection in entity-creator agent (abort generation if output file already exists)
- [X] T007 [P] Implement entity versioning with `@vN` metadata references in entity YAML (allow mutable entities with audit trail)

**Checkpoint**: Foundation ready - entity-template meta-template and entity-creator agent define the system's validation logic

---

## Phase 3: Entity Type Templates (Priority: P1) 🎯 MVP

**Goal**: Define reusable entity templates (characters, styles, environments) as YAML+Markdown files for entity-creator agent workflows. Templates define validation rules and quality gates.

**Independent Test**: Create a character entity file, verify entity-creator agent can read and reference it in prompts.

- [ ] T008 [US1] Create character template at entities/entity-templates/character.template.md (include validation rules)
- [ ] T009 [US1] Create style template at entities/entity-templates/style.template.md (include validation rules)
- [ ] T010 [US1] Create environment template at entities/entity-templates/environment.template.md (include validation rules)
- [ ] T011 [US1] Create scene template at entities/entity-templates/scene.template.md (include validation rules for scene descriptions)
- [ ] T012 [US1] Create example entities (one per type: character, style, environment) at entities/<type>/ with descriptive kebab-case names, YAML front-matter, and Markdown descriptions
- [ ] T013 [US1] Validate entity file naming and kebab-case enforcement
- [ ] T014 [US1] Document entity creation workflow in quickstart.md

**Checkpoint**: Entity templates and examples are available and entity-creator agent can read them

---

## Phase 4: Scene Generation (Priority: P2) 🎯 MVP

**Goal**: Generate scene entity files (Markdown descriptions) using entity-creator agent. Scenes combine character, style, and environment entities into narrative descriptions.

**Independent Test**: Prompt entity-creator agent to generate a scene combining character, style, and environment entities, verify scene .md file is created in entities/scenes/.

- [ ] T015 [US2] Generate scene entity file at entities/scenes/ combining character, style, and environment via entity-creator agent
- [ ] T016 [US2] Validate scene file format (YAML front-matter with entity references + Markdown narrative description)
- [ ] T017 [US2] Document scene generation workflow in quickstart.md

**Checkpoint**: Scene generation workflow is functional; scenes serve as input for image generation

---

## Phase 5: Asset Generation Setup (Priority: P3) 🎯 MVP

**Goal**: Configure MCP servers, DVC, and generate test images. This phase brings together the entity definitions with actual image generation capability.

**Independent Test**: Generate test image from scene entity, verify DVC tracking in content/test/.

- [ ] T018 [US3] Create .env.example for API credentials (no secrets)
- [ ] T019 [US3] Initialize DVC in workspace root
- [ ] T020 [US3] Add DVC local remote for development in .dvc/config
- [ ] T021 [US3] Add .dvcignore for logs/ and temp files
- [ ] T022 [US3] Create MCP config template at entities/entity-templates/mcp-config.template.md (defines MCP server configuration structure)
- [ ] T023 [US3] Configure MCP servers in .vscode/settings.json using mcp-config template
- [ ] T024 [US3] Add prompt template for asset generation in .github/prompts/asset-generation.md
- [ ] T025 [US3] Add MCP and direct-api model_config examples to scene entity
- [ ] T026 [US3] Generate test image in content/test/ from scene entity via entity-creator agent prompt (REQUIRES: API credentials)
- [ ] T027 [US3] Track test image with DVC and commit
- [ ] T028 [US3] Validate DVC tracking and asset metadata YAML for test image
- [ ] T029 [US3] Document MCP and DVC workflow in quickstart.md

**Checkpoint**: System can generate and track images from scene entities; MCP connectivity validated

---

## Phase 6: Production Image Generation (Priority: P4) 🎯 MVP

**Goal**: Generate production-ready images from scene entities with full metadata and DVC tracking. Requires MCP/DVC setup from Phase 5.

**Independent Test**: Prompt entity-creator agent to generate an image from a scene entity, verify image and metadata in content/.

- [ ] T030 [US4] Generate image from scene entity via entity-creator agent prompt (REQUIRES: API credentials)
- [ ] T031 [US4] Validate image naming pattern and DVC tracking
- [ ] T032 [US4] Validate image metadata YAML includes scene entity reference and generation parameters
- [ ] T033 [US4] Document production image generation workflow in quickstart.md

**Checkpoint**: Production image generation is functional with full DVC tracking and metadata

---

## Phase 7: Batch Image Generation (Priority: P5)

**Goal**: Generate multiple image variations in sequence (up to 5 per batch) using entity-creator agent with different scene entities or parameters, each tracked and versioned.

**Independent Test**: Prompt entity-creator agent to generate 3 image variations from different scenes, verify all images and metadata in content/.

- [ ] T034 [US5] Add prompt template for batch generation in .github/prompts/batch-generation.md
- [ ] T035 [US5] Generate batch of images from multiple scene entities via entity-creator agent prompt (REQUIRES: API credentials)
- [ ] T036 [US5] Validate batch image naming and DVC tracking
- [ ] T037 [US5] Validate batch commit message format
- [ ] T038 [US5] Document batch generation workflow in quickstart.md

**Checkpoint**: Batch asset generation is functional with proper naming and DVC tracking

---

## Phase 8: Browse Images via VS Code File Explorer (Priority: P6)

**Goal**: Browse generated images and metadata in VS Code file explorer and retrieve versions via DVC.

**Independent Test**: Generate several images, browse content/ in VS Code, and view metadata YAML files.

- [ ] T039 [US6] Generate multiple test images with different scenes (REQUIRES: API credentials)
- [ ] T040 [US6] Validate image and metadata file discoverability in VS Code
- [ ] T041 [US6] Validate DVC version history for images
- [ ] T042 [US6] Document image browsing and DVC usage in quickstart.md

**Checkpoint**: Image browsing and version retrieval are functional

---

## Phase 9: Polish & Cross-Cutting Concerns

**Purpose**: Improvements that affect multiple user stories

- [ ] T043 [P] Final documentation updates in README.md and quickstart.md
- [ ] T044 [P] Code and template cleanup in entities/ and .github/
- [ ] T045 [P] Performance optimization for entity-creator agent workflows
- [ ] T046 [P] Additional template-driven validation for edge cases (e.g., missing env vars, batch size limits)
- [ ] T047 [P] Security review for credential handling
- [ ] T048 [P] Run full quickstart.md validation walkthrough

---

## Dependencies & Execution Order

### Phase Dependencies

- **Phase 1 (Directory Structure)**: No dependencies - can start immediately
- **Phase 2 (Entity Template Bootstrap)**: Depends on Phase 1 - BLOCKS all user stories
- **Phase 3 (Entity Type Templates)**: Depends on Phase 2 - foundation for all entity definitions
- **Phase 4 (Scene Generation)**: Depends on Phase 3 - needs entity templates
- **Phase 5 (Asset Generation Setup)**: Depends on Phase 4 - needs scenes for test generation; adds DVC and MCP config
- **Phase 6 (Production Images)**: Depends on Phase 5 - needs MCP/DVC setup
- **Phase 7 (Batch Generation)**: Depends on Phase 5 - needs MCP/DVC setup
- **Phase 8 (Browse Images)**: Depends on Phase 6 or 7 - needs generated images
- **Phase 9 (Polish)**: Depends on all desired phases being complete

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
