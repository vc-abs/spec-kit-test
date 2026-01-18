# Phase Plan Example: Phased Implementation Pattern

**Status**: RETROACTIVE EXAMPLE (already executed)
**Purpose**: Demonstrate how future implementations should be broken into phases

## What Was Actually Done (Single Phase - TOO LARGE)

Created 20+ files in one implementation pass:

- 5 entity templates
- 3 example entities
- 1 scene entity
- 1 MCP config template
- 4 prompts
- 1 agent
- Multiple config files (.env.example, .gitignore, .vscode/settings.json, etc.)
- README.md and quickstart.md updates

**Problem**: This created an unmanageable commit with too many changes to review effectively.

---

## How It SHOULD Have Been Done (4 Phases)

### Phase 1: Foundation Setup

**Files**: 5

- `.env.example`
- `.gitignore` (modify)
- `.dvcignore`
- `.vscode/settings.json` (modify)
- `README.md` (modify)

**Validation**: Check configs, verify .env is gitignored
**Commit**: `feat(foundation): add GenAI system configuration`

---

### Phase 2: Bootstrap Templates

**Files**: 3

- `entities/entity-template/entity-template.template.md`
- `.github/agents/entity-creator.agent.md`
- `.github/prompts/asset-generation.md`

**Validation**: Verify template structure, test agent syntax
**Commit**: `feat(templates): add entity template system and creator agent`

---

### Phase 3: Entity Type Templates + Examples

**Files**: 7

- `entities/entity-template/character.template.md`
- `entities/entity-template/style.template.md`
- `entities/entity-template/environment.template.md`
- `entities/character/max.md`
- `entities/style/watercolor-soft.md`
- `entities/environment/sunset-park.md`
- `specs/001-genai-asset-system/quickstart.md` (modify - entity creation section)

**Validation**: Check template validation rules, verify examples follow templates
**Commit**: `feat(entities): add character/style/environment templates with examples`

---

### Phase 4: Scene Templates + MCP Configuration

**Files**: 5

- `entities/entity-template/scene.template.md`
- `entities/entity-template/mcp-config.template.md`
- `entities/scene/max-watercolor-sunset.md`
- `.vscode/settings.json` (modify - add MCP servers)
- `specs/001-genai-asset-system/quickstart.md` (modify - MCP validation section)

**Validation**: Verify scene dependencies, test MCP config format
**Commit**: `feat(scenes): add scene template and MCP configuration`

---

## Benefits of Phased Approach

1. **Reviewable commits**: Each phase ~300-500 lines, easy to review
2. **Testable checkpoints**: Can validate after each phase
3. **Incremental progress**: Foundation works before adding complexity
4. **Rollback safety**: Can revert single phase without losing everything
5. **Clear dependencies**: Each phase builds on previous

---

## Lesson Learned

**Before starting implementation**:

- Count total files to create
- If >10 files, create phase-plan-01.md FIRST
- Wait for user approval before executing
- Commit after each phase completion

**User Experience**:

```
Agent: "Created phase-plan-01.md for Foundation Setup (5 files). Review and reply 'continue'."
User: [reviews] "continue"
Agent: [executes Phase 1]
Agent: "Phase 1 complete. Review changes and commit. Reply 'next phase' when ready."
User: [commits] "next phase"
Agent: "Created phase-plan-02.md for Bootstrap Templates (3 files)..."
```

This creates 4 manageable commits instead of 1 massive unmanageable commit.
