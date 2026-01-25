# spec-kit-test

A scaffold to help with kick-starting AIFSD projects or to convert existing projects into one.

## Approach

This project / repo is meant to provide the scaffolding for AIFSD. New projects could use this to setup their base repos by prompting. With existing projects, the idea is to merging this repo without overriding.

## Supported Tools

This scaffold is **optimized for GitHub Copilot** integration. Prompts, agents, and workflows are designed specifically for Copilot's capabilities and context model.

- **Supported:** GitHub Copilot (Chat, CLI, Editor integration)
- **Not supported:** Cursor, OpenAI configuration

*Focus: Copilot-first development to avoid scope creep and maintain consistent tooling.*

## Phased Implementation Pattern

For large implementations creating 10+ files, this project uses a **phased checkpoint approach** to ensure reviewable, committable increments:

- **Pattern**: Break work into 3-8 file phases with interactive approval gates
- **Session Persistence**: Phase plans survive Copilot session restarts
- **Documentation**: See [.github/patterns/phased-implementation.md](.github/patterns/phased-implementation.md)
- **Example**: See [.github/examples/phase-plan-example.md](.github/examples/phase-plan-example.md)

This prevents massive 20+ file commits and enables incremental validation and rollback safety.

## Features

### GenAI Asset Generation System

An AI-powered system for generating and managing visual assets using entity-based templates and version control.

**Quick Start:** [docs/quickstart.md](docs/quickstart.md)

**Key Features:**

- **Entity-Based Design**: Characters, styles, environments, scenes as reusable YAML+Markdown entities
- **Template-Driven**: Quality gates and validation rules defined in entity templates
- **DVC Integration**: Binary asset tracking and versioning with Data Version Control
- **MCP Support**: Imagen 3 integration via Model Context Protocol
- **Agent Workflow**: Automated entity creation and asset generation via Copilot agent

**Directory Structure:**

```text
content/
  entities/
    entity-templates/  # Meta-templates defining entity types
    characters/        # Character entity definitions
    styles/            # Art style templates
    environments/      # Scene environment settings
    scenes/            # Composed scene descriptions
  images/              # Generated images (DVC-tracked)
  test/                # Test assets and validation
.github/
  agents/              # Copilot agent definitions
  prompts/             # Delegation prompts
logs/                  # Operation logs (timestamped)
```

**Status:** ✅ Core implementation complete (Phases 1-9, excluding API-dependent Phase 5 tasks)

**Documentation:**

- Quick Start Guide: [docs/quickstart.md](docs/quickstart.md)
- Specification: [specs/001-genai-asset-system/spec.md](specs/001-genai-asset-system/spec.md)
- Technical Plan: [specs/001-genai-asset-system/plan.md](specs/001-genai-asset-system/plan.md)
- Implementation Tasks: [specs/001-genai-asset-system/tasks.md](specs/001-genai-asset-system/tasks.md)
- Data Model: [specs/001-genai-asset-system/data-model.md](specs/001-genai-asset-system/data-model.md)
