# Implementation Plan: GenAI Asset Generation System

**Branch**: `001-genai-asset-system` | **Date**: 2026-01-05 | **Spec**: [spec.md](spec.md)
**Input**: Feature specification from `/specs/001-genai-asset-system/spec.md`

**Note**: This template is filled in by the `/speckit.plan` command. See `.specify/templates/commands/plan.md` for the execution workflow.

## Summary

Build a **unified entity model system** where everything is an entity (templates, characters, scripts, videos, images). Entities form a dependency network (not hierarchy) where dependencies are declared in templates. The `entity-creator` workflow reads entity templates, resolves dependencies just-in-time, and creates entities (writes metadata files, executes process entities, generates binary outputs via GenAI). The system uses `entity-template.template.md` as the bootstrap; all other templates (character.template.md, video.template.md, script.template.md) are entities created from this bootstrap. Circular dependencies are allowed for relationships. Everything is version-controlled (DVC for binaries, git for text).

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
- Entity types: 4 (character, style, environment, entity-template)
- Asset types: 4 initial (greeting-card, informative-image, sprite-sheet, video)
- Expected entity count: 10-50 entities
- Expected asset count: Hundreds to thousands over project lifetime
- User stories: 5 (P1 entities, P2 MCP validation, P3 single gen, P4 batch, P5 browse)

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

### Initial Check (Pre-Phase 0)

**Principle I: Copilot-First Enablement** ✅ PASS
- Template-driven architecture: Users define templates, Copilot reads and processes them
- Entity templates (YAML + Markdown) are Copilot-readable context files
- Spec explicitly states "Copilot workflow, NOT CLI tool" (clarification)
- Copilot workflows in `.github/agents/` implement template processing logic

**Principle II: Test-Driven Development** ⚠️ DEVIATION (JUSTIFIED)
- No automated tests - this is a content generation system, not software
- Validation is operational: "Can Copilot generate asset? Is it tracked by DVC?"
- P2 user story validates MCP connectivity through test asset generation
- Quality gates: format compliance, resolution validation, metadata completeness (FR-014, FR-019)
- **Entity-creator validation**: Can invoke a validator entity (planned) to validate generated entities against their descriptions (unless exceptions explicitly mentioned)
- **Justification**: TDD applies to code; this project generates assets via external APIs with file-based validation

**Principle III: CLI and Text Protocols** ⚠️ DEVIATION (JUSTIFIED)
- System uses template files + Copilot workflows, not CLI commands
- DVC and git are CLI tools integrated into workflow
- Templates and metadata are text-based (YAML/Markdown)
- Logs are plain text files
- **Justification**: Template-centric architecture supersedes CLI requirement; underlying tools (DVC, git) are CLI-based

**Principle IV: Simplicity and Minimalism** ✅ PASS
- Flat content directory (no complex hierarchy)
- Entity templates are simple YAML + Markdown
- No abstractions - direct file manipulation
- Discriminated union model_config is minimal (2 variants: MCP vs direct-api)
- Manual cleanup on failures (no complex rollback logic)

**Principle V: Observability and Versioning** ✅ PASS
- Per-asset log files capture all generation attempts (FR-011)
- DVC tracks binary asset versions
- Git tracks metadata YAML files with entity references, prompts, parameters
- Conventional commit format for assets
- Error messages include specific failure points

**Principle VI: Content Quality and Asset Management** ✅ PASS
- DVC version control for binary assets (constitution requirement)
- Metadata YAML files capture generation parameters, model versions, prompts
- Quality validation gates: format compliance, resolution checks (FR-014, FR-019)
- Naming conventions enforce filesystem safety
- Asset organization: production in `content/`, test in `content/test/`

**GATE STATUS**: ✅ **PASS WITH JUSTIFIED DEVIATIONS**
- TDD and CLI deviations are appropriate for content generation system
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
- Agent contracts define clear Copilot integration points
- All workflows use `@workspace` and `@entities/` references
- No dependencies on tools outside Copilot ecosystem
- Quickstart demonstrates Copilot-first prompts

**Principle II: Test-Driven Development** ✅ CONFIRMED (Deviation Justified)
- P2 MCP validation agent provides operational testing framework
- Test assets in `content/test/` prove generation pipeline
- Quality gates (FR-014, FR-019) act as validation checkpoints
- Deviation remains justified: no code to unit test

**Principle III: CLI and Text Protocols** ✅ CONFIRMED (Deviation Justified)
- DVC CLI, git CLI integrated into agent workflows
- All data formats are text-based (YAML, Markdown, plain text logs)
- Stdin/stdout not applicable (Copilot agents use file I/O)
- Deviation remains justified: Copilot-first overrides CLI-first

**Principle IV: Simplicity and Minimalism** ✅ CONFIRMED
- No new abstractions introduced in design
- File-based architecture maintained (no database, no services)
- Agent contracts are straightforward (no complex state machines)
- Research eliminated alternatives with higher complexity

**Principle V: Observability and Versioning** ✅ CONFIRMED
- Data model specifies ISO 8601 timestamps throughout
- Log format documented (plain text with timestamps)
- DVC + git provide dual versioning (binaries + metadata)
- Validation report format specified in MCP validation agent

**Principle VI: Content Quality and Asset Management** ✅ CONFIRMED
- Data model enforces metadata completeness
- Agent contracts specify validation checkpoints
- DVC workflow integrated into asset-generation and batch-generation agents
- Quality gates explicit in contracts (format, resolution, integrity)

**FINAL GATE STATUS**: ✅ **DESIGN PASSES CONSTITUTION COMPLIANCE**

All justified deviations maintained. Design phase introduces no new violations. System architecture aligns with constitution principles I, IV, V, VI. Deviations for II (TDD) and III (CLI) remain appropriate for content generation use case.

## Project Structure

### Documentation (this feature)

```text
specs/001-genai-asset-system/
├── plan.md              # This file (/speckit.plan command output)
├── research.md          # Phase 0 output (/speckit.plan command)
├── data-model.md        # Phase 1 output (/speckit.plan command)
├── quickstart.md        # Phase 1 output (/speckit.plan command)
├── contracts/           # Phase 1 output (/speckit.plan command)
│   ├── entity-agent.md      # Copilot agent contract for entity creation
│   ├── asset-agent.md       # Copilot agent contract for single asset generation
│   ├── batch-agent.md       # Copilot agent contract for batch generation
│   └── mcp-validation-agent.md  # Copilot agent contract for MCP validation
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
├── *.png               # Image assets (DVC-tracked)
├── *.mp4               # Video assets (DVC-tracked)
├── *.dvc               # DVC metadata files (git-tracked)
└── *.meta.yaml         # Asset metadata (git-tracked)

content/test/            # P1 validation test assets
└── [same structure as content/]

logs/                    # Per-asset generation logs
└── *.log               # e.g., 001-genai-asset-system-max-card.greeting-card.log

.github/                 # Copilot integration
└── agents/              # IMPLEMENTATION: Copilot workflows (read templates)
    ├── entity-creator.md     # Workflow: Read meta-template → create entity
    └── asset-generator.md    # Workflow: Read entities → generate asset

.vscode/                 # VS Code workspace config
└── settings.json        # MCP server configurations (version-controlled)

.env                     # API credentials (gitignored)
.dvc/                    # DVC configuration
```

**Structure Decision**: Unified entity model with dependency network. Everything is an entity (templates, characters, scripts, videos, images). Entity-creator workflow reads entity templates, resolves dependencies JIT, and creates all entity types (writes metadata, executes processes, generates binaries). No source code - all functionality through entity definitions and entity-creator workflow.

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
1. MCP Integration: Server names in entities → details in `.vscode/settings.json`
2. DVC Workflow: Custom Copilot prompt executes shell commands atomically
3. Agent Structure: YAML agents + Markdown prompts in `.github/`
4. Entity Format: YAML front-matter + Markdown body
5. Dependency Resolution: Dependencies declared in templates, entities, prompts, or inferred from tacit context
6. Error Handling: Fail-fast with detailed logging, no auto-retry
7. Naming: Strict kebab-case validation, alphanumeric + hyphens only

---

## Phase 1 Output: Unified Entity Model Design Complete

**Files Generated**:
- [`data-model.md`](data-model.md): Entity definitions with dependency network
- [`contracts/entity-creator.md`](contracts/entity-creator.md): Universal entity creation workflow specification
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
- **Contracts**: [contracts/](contracts/) (4 agent contracts)
- **Quickstart**: [quickstart.md](quickstart.md)

### Key Architectural Decisions
1. **No Source Code**: File-based system, Copilot agents manipulate YAML/Markdown
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
