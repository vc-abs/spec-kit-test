# Phase Plan 01: Directory Structure & Basic Setup

**Phase Goal**: Establish basic project directory structure and version control configuration for GenAI Asset Generation System.

**Status**: AWAITING USER INPUT

---

## Files to Create/Modify (3 files)

### Directory Structure (New)

```
content/
  entities/
    characters/
    styles/
    environments/
    scenes/
    meta-prompts/
```

### Files to Modify (2)

1. `.gitignore` - Add GenAI-specific patterns (.env, *.dvc, .dvc/cache, generated images)
2. `README.md` - Add GenAI Asset System section documenting directory structure

---

## Required User Inputs

Please answer the following questions:

### 1. API Providers

**Question**: What should be the default image generation resolution for later phases?

Options:

- [ ] 1024x1024 (square, DALL-E 3 default)
- [ ] 1792x1024 (landscape)
- [ ] 1024x1792 (portrait)

**Your selection**: _____________ (Can defer to Phase 5)

---

## Tasks Covered (Phase 1: T001-T003)

- [ ] T001: Create directory structure for entities and content
- [ ] T002: Add GenAI-specific patterns to .gitignore
- [ ] T003: Update README.md with GenAI system overview

---

## Validation Steps

After implementation, verify:

1. **Directory structure exists**:

   ```bash
   tree content/entities/ -L 1
   ```

2. **Gitignore patterns present**:

   ```bash
   grep -E '\.env|\.dvc' .gitignore
   ```

3. **README updated**:

   ```bash
   grep -i "genai" README.md
   ```

---

## Commit Message Template

```text
feat(genai): add directory structure and basic setup

- Create content/entities/ hierarchy (characters, styles, environments, scenes, meta-prompts)
- Update .gitignore with GenAI patterns (.env, *.dvc, .dvc/cache)
- Add GenAI system overview section to README.md

Phase 1/9: Directory Structure & Basic Setup
Tasks: T001-T003
```

---

## Next Steps

After Phase 1 is committed:

1. **Phase 2** will create entity template bootstrap system (meta-template, entity-creator agent)
2. **Phase 3** will create specific entity type templates (character, style, environment, scene)
3. **Phase 4** will implement scene generation and validation
4. **Phase 5** will add DVC, MCP, and environment configuration (deferred from this phase)

---

## Notes

- **DVC and MCP configuration deferred**: Originally planned for Phase 1, now moved to Phase 5 to allow entity definitions to be validated first
- **Environment variables deferred**: .env.example will be created in Phase 5 when API integration is needed
- **MCP server config deferred**: .vscode/settings.json updates will be added in Phase 5 when entity-creator agent is ready for use
- **Minimal scope**: This phase creates only the directory structure and basic version control setup to enable template development in Phase 2

---

## Dependencies

**Requires**:

- Git repository initialized
- VS Code workspace

**Blocks**:

- Phase 2 (Entity Template Bootstrap)
- All subsequent phases

---

## Next Phase

**Phase 02: Entity Template Bootstrap** (T004-T007)

- Entity meta-template system
- Entity-creator agent configuration
- Entity versioning structure
- Bootstrap DVC documentation placeholders
- Filename conflict detection
- Entity versioning

---

## Instructions

1. **Review this plan** and answer the 3 required input questions above
2. **Edit this file** with your answers
3. **Reply "continue" or "proceed with phase 1"** when ready
4. Agent will execute Phase 1 implementation
5. **Review changes and commit** using the template above
6. **Reply "next phase"** to proceed to Phase 2

**Note**: You can say "skip phase 1" if this work is already done, and agent will create phase-plan-02.md instead.
