# Implementation Plan: GenAI Asset Generation System

**Branch**: `001-genai-asset-system` | **Date**: 2026-01-05 | **Spec**: [spec.md](spec.md)
**Input**: Feature specification from `/specs/001-genai-asset-system/spec.md`

**Note**: This template is filled in by the `/speckit.plan` command. See `.specify/templates/commands/plan.md` for the execution workflow.

## Summary

Build a **unified entity model system** where everything is an entity (templates, characters, scenes, images). Entities form a dependency network (not hierarchy) where dependencies are declared in templates. The `entity-creator` workflow reads entity templates, resolves dependencies just-in-time, and creates entities (writes metadata files, executes process entities, generates binary outputs via GenAI). The system uses `entity-template.template.md` as the bootstrap; all other templates (character.template.md, scene.template.md, etc.) are entities created from this bootstrap. **MVP scope**: Image generation from scene entities. **Future examples**: video.template.md, script.template.md for multi-media workflows. Circular dependencies are allowed for relationships. Everything is version-controlled (DVC for binaries, git for text).

**Key Abstraction**: Everything is an entity with dependencies. Entity-creator reads templates → resolves dependencies → creates entities (metadata + binaries + processes).

## Technical Context

**Language/Version**: Not applicable - configuration-driven system using YAML/Markdown entity templates, no compiled code
**Primary Dependencies**:

- GitHub Copilot (required for asset generation workflows)
- DVC (Data Version Control) for binary asset tracking (prerequisite: remote storage configured)
- MCP (Model Context Protocol) servers OR direct GenAI API access (DALL-E, Stable Diffusion, Runway, etc.)
- VS Code (for .vscode/settings.json MCP configuration)
- Git (for text artifact version control)

**Storage**:

- File-based: Entity templates in `entities/<type>/`, assets in `content/`, metadata YAML in git
- DVC remote: S3/Azure/GCS/local for binary assets (prerequisite)
- Logs: Per-asset files in `logs/`

**Testing**: Manual validation via Copilot prompts testing entity creation, asset generation, DVC tracking. No automated test framework - validation is operational (does asset generate? is it tracked?)

**Target Platform**: VS Code workspace with GitHub Copilot extension, DVC CLI, git CLI. Linux/macOS/Windows compatible.

**Project Type**: Template-driven content generation system - users define templates, Copilot generates from them

**Performance Goals**:

- Entity file creation: <1 minute manual workflow
- Single asset generation: Seconds (images) to minutes (videos) depending on GenAI model latency
- Batch generation (5 assets): <5 minutes excluding model API time
- Asset generation success rate: >95%

**Constraints**:

- Naming: Kebab-case, alphanumeric + hyphens only (filesystem safety)
- Batch limit: 5 assets maximum per request
- No runtime fallback between MCP and direct-api (config-driven)
- Manual cleanup on DVC/git failures (no auto-rollback)
- Entity files assumed immutable after asset generation (metadata stores paths only)

**Scale/Scope**:

- Entity types: 5 MVP (character, style, environment, scene, entity-template)
- Asset types: 1 MVP (image); 3 future (greeting-card, sprite-sheet, video)
- Expected entity count: 10-50 entities
- Expected asset count: Hundreds to thousands over project lifetime
- User stories: 6 (P1 entity templates, P2 scene generation, P3 MCP validation, P4 single image, P5 batch images, P6 browse)

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

### Initial Check (Pre-Phase 0)

**Principle I: Copilot-First Enablement** ✅ PASS

- Template-driven architecture: Users define templates, Copilot reads and processes them
- Entity templates (YAML + Markdown) are Copilot-readable context files
- Spec explicitly states "Copilot workflow, NOT CLI tool" (clarification)
- Copilot workflows in `.github/agents/` implement template processing logic

**Principle II: Iterative Validation and Quality Assurance** ✅ PASS

- System implements validation → implementation → verification cycle via entity-creator agent workflow
- Entity-creator agent iterates until successful conclusion or user abort
- Validation is operational: "Can entity-creator agent generate asset? Is it tracked by DVC?"
- P2 user story validates MCP connectivity through test asset generation
- Quality gates: format compliance, resolution validation, metadata completeness (FR-014) - all template-driven
- Hybrid validation model: optional pre-checks (`validate` command) + fail-fast generation
- **Alignment**: Constitution Principle II now supports iterative quality cycles for content generation systems

**Principle III: CLI and Text Protocols** ✅ PASS

- Template-driven workflows operate through GitHub Copilot, exempt from CLI requirements per Constitution Principle III amendment
- DVC and git are CLI tools integrated into workflow
- Templates and metadata are text-based (YAML/Markdown)
- Logs are YAML arrays (human-readable plain text)
- **Alignment**: Constitution Principle III now exempts template-driven agent systems from CLI requirements

**Principle IV: Simplicity and Minimalism** ✅ PASS

- Flat content directory (no complex hierarchy)
- Entity templates are simple YAML + Markdown
- No abstractions - direct file manipulation
- Discriminated union model_config is minimal (2 variants: MCP vs direct-api)
- Manual cleanup on failures (no complex rollback logic)

**Principle V: Observability and Versioning** ✅ PASS

- Per-asset log files capture all generation attempts (FR-011), with logging format defined in the entity-creator agent.
- DVC tracks binary asset versions
- Git tracks metadata YAML files with entity references, prompts, parameters
- Conventional commit format for assets
- Error messages include specific failure points (fail-fast approach)

**Principle VI: Content Quality and Asset Management** ✅ PASS

- DVC version control for binary assets (constitution requirement)
- Metadata YAML files capture generation parameters, model versions, prompts
- Quality validation gates: format compliance, resolution checks (FR-014) are template-driven and handled by entity-creator agent using fail-fast approach
- Naming conventions enforce filesystem safety
- Asset organization: production in `content/`, test in `content/test/`

**GATE STATUS**: ✅ **PASS - CONSTITUTION COMPLIANT**

- Iterative validation cycle aligns with amended Principle II
- Template-driven agent system exempt from CLI requirements per amended Principle III
- All content-specific requirements (Principle VI) fully satisfied
- Copilot-first principle strictly enforced

**Alignment with Copilot Instructions** (`.github/copilot-instructions.md`):

- ✅ File naming: Agents use nouns, prompts use imperative verbs, all kebab-case
- ✅ Git operations: Use `run_in_terminal` for all git commands
- ⚠️ **Auto-commit exception**: Asset generation agents auto-commit after successful generation (FR-005 requirement). This is feature-specific behavior, not general Copilot behavior. User can still use `/commit` for manual commits of other changes.
- ✅ Architecture: Separation of concerns (agents per capability), minimal dependencies
- ✅ Documentation: Plan, research, contracts, quickstart provide comprehensive context

---

### Post-Design Check (After Phase 1)

**Design Artifacts Reviewed**:

- `research.md`: 7 technical decisions documented
- `data-model.md`: 6 entity definitions with validation rules
- `contracts/`: 4 agent contracts (entity, asset, batch, MCP validation)
- `quickstart.md`: Complete setup guide with examples

**Principle I: Copilot-First Enablement** ✅ CONFIRMED

- Agent contracts define clear entity-creator agent integration points
- All workflows use `@workspace` and `@entities/` references
- No dependencies on tools outside Copilot ecosystem
- Quickstart demonstrates entity-creator agent prompts

**Principle II: Iterative Validation and Quality Assurance** ✅ CONFIRMED

- Entity-creator agent implements validation → implementation → verification workflow cycle
- Iterates until conclusion or user abort
- Quality gates explicit in contracts (format, resolution, integrity)
- Operational validation appropriate for content generation use case

**Principle III: CLI and Text Protocols** ✅ CONFIRMED

- Template-driven agent system exempt per Constitution Principle III
- DVC CLI, git CLI integrated into entity-creator agent workflows
- All data formats are text-based (YAML, Markdown, YAML array logs)

**Principle IV: Simplicity and Minimalism** ✅ CONFIRMED

- Entity-creator agent uses hybrid validation model with optional pre-checks
- Fail-fast approach for generation (no complex error recovery)
- Manual cleanup on failures (no automatic rollback logic)

- No new abstractions introduced in design
- File-based architecture maintained (no database, no services)
- Agent contracts are straightforward (no complex state machines)
- Research eliminated alternatives with higher complexity

**Principle V: Observability and Versioning** ✅ CONFIRMED

- Data model specifies ISO 8601 timestamps throughout
- Log format: YAML arrays with human-readable attributes (timestamp, level, status, activity, model, model_version, duration_ms)
- DVC + git provide dual versioning (binaries + metadata)
- Validation report format specified in MCP validation agent

**Principle VI: Content Quality and Asset Management** ✅ CONFIRMED

- Data model enforces metadata completeness
- Agent contracts specify validation checkpoints
- DVC workflow integrated into asset-generation and batch-generation agents
- Quality gates explicit in contracts (format, resolution, integrity)

**FINAL GATE STATUS**: ✅ **DESIGN PASSES CONSTITUTION COMPLIANCE**

All principles aligned with amended constitution. Design phase introduces no violations. System architecture aligns with Principles I (Copilot-first), II (Iterative validation), III (CLI exempt), IV (Simplicity), V (Observability), VI (Content quality).

## Project Structure

### Documentation (this feature)

```text
specs/001-genai-asset-system/
├── plan.md              # This file (/speckit.plan command output)
├── research.md          # Phase 0 output (/speckit.plan command)
├── data-model.md        # Phase 1 output (/speckit.plan command)
├── quickstart.md        # Phase 1 output (/speckit.plan command)
├── contracts/           # Phase 1 output (/speckit.plan command)
│   └── entity-creator.agent.md    # Universal workflow contract for all entity types
└── tasks.md             # Phase 2 output (/speckit.tasks command - NOT created by /speckit.plan)
```

### Source Code (repository root)

```text
# Content generation system - no compiled source code
# Structure based on file-based entity/asset organization

entities/                # Entity template storage
├── character/           # Character entities
│   └── *.md            # e.g., max.md (YAML front-matter + Markdown)
├── style/               # Style entities
│   └── *.md            # e.g., watercolor.md
├── environment/         # Environment entities
│   └── *.md            # e.g., forest.md
└── entity-template/     # Meta-templates defining entity schemas
    └── *.md            # e.g., character-template.md

content/                 # Generated assets (production)
├── *.png               # Image assets (DVC-tracked; future: *.mp4 videos)
├── *.dvc               # DVC metadata files (git-tracked)
└── *.meta.yaml         # Asset metadata (git-tracked)

content/test/            # P1 validation test assets
└── [same structure as content/]

logs/                    # Per-asset generation logs
└── *.log               # e.g., 001-genai-asset-system-max-card.greeting-card.log

.github/                 # Copilot integration
└── agents/              # IMPLEMENTATION: Copilot workflows (read templates)
    ├── entity-creator.agent.md     # Workflow: Read meta-template → create entity
    └── asset-generator.md    # Workflow: Read entities → generate asset

.vscode/                 # VS Code workspace config
└── settings.json        # MCP server configurations (version-controlled)

.env                     # API credentials (gitignored)
.dvc/                    # DVC configuration
```

**Structure Decision**: Unified entity model with dependency network. Everything is an entity (templates, characters, scenes, images). Entity-creator workflow reads entity templates, resolves dependencies JIT, and creates all entity types (writes metadata, executes processes, generates binaries). **MVP focus**: Scene-based image generation; **Future**: video, script, audio orchestration.

**No Traditional Source Code**: Notice there's no `src/`, `lib/`, or `app/` directory. System functionality comes from:

- Entity definitions in `entities/` (YAML+Markdown data files)
- Copilot agent workflows in `.github/agents/` (instructions for Copilot, not executable code)
- DVC and git for version control (CLI tools, not custom code)
- GenAI APIs for binary generation (external services)

The "implementation" is defining the entity-creator workflow (Markdown instructions) that tells Copilot how to interpret and manipulate these data files. See [Key Architectural Decisions](#key-architectural-decisions) below for detailed explanation.

## Complexity Tracking

> **Fill ONLY if Constitution Check has violations that must be justified**

| Violation              | Why Needed                                            | Simpler Alternative Rejected Because                                                                                  |
| ---------------------- | ----------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------- |
| No TDD/automated tests | Content generation system with operational validation | Unit tests cannot validate GenAI API responses; validation is inherently operational (does asset generate correctly?) |
| No CLI interface       | Copilot-first architecture                            | CLI would duplicate Copilot agent functionality; constitution Principle I (Copilot-First) takes precedence            |

---

## Phase 0 Output: Research Complete

**File**: [`research.md`](research.md)

**Key Decisions**:

1. MCP Integration: Server names in entities → details in `.vscode/settings.json` → **See [research.md §1](research.md#1-mcp-model-context-protocol-integration-patterns)**
2. DVC Workflow: Custom Copilot prompt executes shell commands atomically → **See [research.md §2](research.md#2-dvc-workflow-for-binary-asset-tracking)**
3. Agent Structure: YAML agents + Markdown prompts in `.github/` → **See [research.md §4](research.md#4-entity-template-best-practices-yaml--markdown)**
4. Entity Format: YAML front-matter + Markdown body → **See [research.md §4](research.md#4-entity-template-best-practices-yaml--markdown)**
5. Dependency Resolution: Dependencies declared in templates, entities, prompts, or inferred from tacit context → **See [research.md §3](research.md#3-unified-entity-model-architecture)**
6. Error Handling: Fail-fast with detailed logging, no auto-retry → **See [research.md §6](research.md#6-error-handling-patterns)**
7. Naming: Strict kebab-case validation, alphanumeric + hyphens only → **See [research.md §7](research.md#7-naming-conventions-and-validation)**

**For Implementers**: Read [research.md](research.md) in full before starting implementation. Pay special attention to §3 (Unified Entity Model Architecture) - this is the foundational design pattern.

---

## Phase 1 Output: Unified Entity Model Design Complete

**Files Generated**:

- [`data-model.md`](data-model.md): Entity definitions with dependency network
- [`contracts/entity-creator.agent.md`](contracts/entity-creator.agent.md): Universal entity workflow (handles entity creation, asset generation, batch generation, MCP validation)
- [`quickstart.md`](quickstart.md): Complete setup guide with examples

**Key Concepts** (Unified Entity Model):

1. **Everything is an Entity**: Templates, characters, scripts, videos, images all use same structure
2. **Bootstrap**: `entity-template.template.md` (manually authored)
3. **Template Entities**: character.template.md, script.template.md, video.template.md (created from bootstrap)
4. **Concrete Entities**: character/max, script/intro, video/max-intro (created from templates)
5. **Dependency Network**: Dependencies declared in templates/entities/prompts or inferred from tacit context (video requires character + script)
6. **Entity Structure**: Metadata file (YAML + Markdown) + optional binary body (content/)
7. **Model Config**: Discriminated union (MCP vs direct-api) in entity YAML

**Entity-Creator Workflow** (Single universal workflow):

1. Read entity template
2. Discover dependencies JIT (just-in-time) from template, entity definitions, prompts, or tacit context
3. Resolve dependencies JIT (prompt user, create if missing)
4. Create entity:
   - Write metadata file
   - Execute process entities (scripts, sequences)
   - Generate binary outputs via GenAI
   - Track binaries with DVC

---

## Implementation Roadmap

### Where to Find Information

| Topic | File | Section | Purpose |
|-------|------|---------|---------|
| Unified Entity Model Architecture | [research.md](research.md) | §3 | Core design pattern - read this first |
| MCP Integration Pattern | [research.md](research.md) | §1 | How MCP servers connect to entities |
| DVC Workflow | [research.md](research.md) | §2 | Asset tracking and version control |
| Entity Structure & Schema | [data-model.md](data-model.md) | §1 | YAML front-matter + Markdown format |
| Model Config (MCP vs Direct API) | [data-model.md](data-model.md) | §2 | Discriminated union for GenAI providers |
| Asset Metadata Format | [data-model.md](data-model.md) | §4 | Git-tracked YAML for reproducibility |
| Entity-Creator Workflow | [contracts/entity-creator.agent.md](contracts/entity-creator.agent.md) | Full document | Universal workflow for all entity types |
| Workflow Validation Rules | [contracts/entity-creator.agent.md](contracts/entity-creator.agent.md) | §Validation Rules | Name patterns, model config checks |
| Workflow Error Handling | [contracts/entity-creator.agent.md](contracts/entity-creator.agent.md) | §Error Handling | Fail-fast responses for common errors |
| Setup & First Entity | [quickstart.md](quickstart.md) | §Setup Steps, §First Entity Creation | Practical examples and walkthrough |
| Naming Conventions | [research.md](research.md) | §7 | Kebab-case validation rules |
| Error Handling Patterns | [research.md](research.md) | §6 | Fail-fast principles |

### Implementation Sequence

**Step 1: Understand the Architecture** (30-60 minutes reading)

1. Read [research.md §3](research.md#3-unified-entity-model-architecture) - **Core concept**: Everything is an entity with dependencies
2. Read [research.md §4](research.md#4-entity-template-meta-architecture) - Bootstrap pattern and meta-templates
3. Skim other research sections to understand technical decisions

**Step 2: Study Entity Structure** (20-30 minutes)

1. Read [data-model.md §1](data-model.md#1-entity-universal-structure) - YAML + Markdown format
2. Read [data-model.md §2](data-model.md#2-model-config-discriminated-union) - GenAI provider configuration
3. Study entity examples in data-model.md

**Step 3: Learn the Universal Workflow** (30-45 minutes)

1. Read [contracts/entity-creator.agent.md](contracts/entity-creator.agent.md) in full
2. Focus on "Workflow Steps (Universal)" section - this is what you'll implement
3. Study validation rules and error handling sections

**Step 4: See It in Action** (15-20 minutes)

1. Follow [quickstart.md](quickstart.md) examples
2. Understand the user experience flow
3. Note the manual steps marked for Phase 2 automation

**Step 5: Ready for Implementation**

- You now understand: unified entity model, entity-creator workflow, validation rules
- Next: Run `/speckit.tasks` to generate implementation breakdown
- Implementation will focus on: entity-creator workflow, DVC integration, validation logic

### Key Implementation Notes

**Universal Workflow**: Don't create separate logic for each entity type. The entity-creator reads templates and handles all types through the same workflow.

**JIT Dependency Resolution**: Dependencies aren't pre-computed - they're discovered just-in-time from templates, entity definitions, prompts, or tacit context.

**Fail-Fast Validation**: All validation happens upfront before any file writes. No partial state or rollback logic.

**No Source Code - What This Actually Means**:

This is a template-driven system where system behavior is defined by data files (entity templates) that Copilot interprets, not by compiled/interpreted source code.

- **What you WON'T be creating**:
  - No `src/main.py` or `src/index.js` entry points
  - No application that "runs" with `python main.py` or `npm start`
  - No classes/functions executing business logic
  - No build artifacts (`dist/`, `build/`, `target/`)

- **What you WILL be creating**:
  - Copilot agent workflow: `.github/agents/entity-creator.agent.md` (Markdown file with YAML front-matter)
  - This agent contains instructions for Copilot on how to:
    - Read entity template files (`entities/entity-template/*.template.md`)
    - Parse YAML front-matter and extract dependencies
    - Validate inputs (kebab-case names, model config structure)
    - Generate files (`entities/<type>/<name>.md`)
    - Execute shell commands (`dvc add`, `git add`, `git commit`)

- **How it works**:
  1. User invokes: `@workspace /create-entity`
  2. Copilot reads `.github/agents/entity-creator.agent.md` workflow
  3. Copilot follows instructions: read template → validate → prompt user → write files → run DVC/git
  4. Result: New entity created, no code compiled or executed

- **Key insight**: System functionality emerges from Copilot interpreting template structure, not from runtime execution. Adding a new entity type means creating a new template file, not modifying code.

---

## Phase 2: Tasks (Not Generated by /speckit.plan)

**Next Command**: Run `/speckit.tasks` to generate `tasks.md` with implementation breakdown

**Expected Task Categories**:

1. P1: Entity Template System
2. P2: MCP Validation Infrastructure
3. P3: Single Asset Generation
4. P4: Batch Generation
5. P5: Asset Browsing & Management
6. **Setup Automation**: Per `.github/copilot-instructions.md` ("prefer automation scripts over markdown instructions"), create setup scripts:
   - `scripts/setup-workspace.sh`: Directory structure creation
   - `scripts/init-dvc.sh`: DVC initialization with remote options
   - `scripts/validate-prerequisites.sh`: Check git, dvc, VS Code versions
   - These scripts replace manual command sequences in quickstart.md

---

## Implementation Summary

### Branch & Files

- **Branch**: `001-genai-asset-system`
- **Spec**: [spec.md](spec.md)
- **Plan**: [plan.md](plan.md) (this file)
- **Research**: [research.md](research.md)
- **Data Model**: [data-model.md](data-model.md)
- **Contracts**: [contracts/entity-creator.agent.md](contracts/entity-creator.agent.md) (universal workflow)
- **Quickstart**: [quickstart.md](quickstart.md)

### Key Architectural Decisions

1. **No Source Code**: File-based system, Copilot agents manipulate YAML/Markdown
   - **What this means**: There's no `src/` directory with Python/JavaScript/etc. code to compile or run
   - **Instead**: System functionality comes from entity definitions (YAML+Markdown files) that Copilot reads and processes
   - **Implementation work**: Creating Copilot agent workflows (in `.github/agents/`) that understand how to read entity templates, resolve dependencies, generate binaries via GenAI APIs, and track with DVC
   - **Analogy**: Like a Makefile system where rules are data (YAML), not imperative code
   - **Example**: A `video` entity declares `dependencies: [character, script]`. The entity-creator workflow reads this declaration and prompts for missing dependencies - no hardcoded "if video then require character" logic
   - **Why**: Extensibility without code changes. New entity types are added by creating templates, not modifying source code. Aligns with Copilot-first principle (Copilot reads templates, not APIs).

2. **Discriminated Union Model Config**: Provider field determines MCP vs direct-api structure
3. **Fail-Fast Validation**: All errors halt workflow with clear messages
4. **Manual Cleanup**: No automatic rollback on DVC/git failures
5. **Template-Driven Formats**: Asset types extensible via entity-template files
6. **Single Batch Commit**: All variations committed together

### Constitution Compliance

- ✅ Copilot-First (Principle I): Strict adherence
- ⚠️ TDD (Principle II): Justified deviation (operational validation)
- ⚠️ CLI (Principle III): Justified deviation (Copilot agents primary interface)
- ✅ Simplicity (Principle IV): No unnecessary abstractions
- ✅ Observability (Principle V): Per-asset logs, DVC + git versioning
- ✅ Content Quality (Principle VI): DVC, metadata, validation gates

### Ready for Implementation

- All technical unknowns resolved in Phase 0 research
- Complete data model with 6 entities defined
- 4 agent contracts specify behavior and integration points
- Quickstart provides setup guidance and first-asset workflow
- Constitution compliance verified (2 justified deviations)

**Status**: ✅ **PLAN COMPLETE** - Ready for `/speckit.tasks` to generate implementation breakdown
