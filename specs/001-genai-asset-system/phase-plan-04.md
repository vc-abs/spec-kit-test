# Phase Plan 04: Scene Generation

**Phase Goal**: Generate scene entity files that combine character, style, and environment entities into narrative descriptions using the entity-creator agent.

**Status**: ✅ COMPLETE

**Iterations**: 1 (implementation complete)

---

## Files to Create/Modify (2-3 files)

### Scene Entities (1-2 new files)

1. `content/entities/scenes/<scene-name>.md` - Scene entity combining existing entities (hero-protagonist, ancient-library, cinematic-realism)
2. Additional scenes as needed for demonstration

### Documentation Updates (1 file)

1. `docs/quickstart.md` - Add scene generation workflow section (MODIFY EXISTING)

---

## Required User Inputs

### 1. Scene Complexity

**Question**: What level of scene complexity should we demonstrate?

Options:

- [ ] **Simple** - Single scene with basic entity references (1 character, 1 environment, 1 style)
- [x] **Standard** - One or two scenes showing different composition patterns
- [ ] **Comprehensive** - Multiple scenes (3+) demonstrating various entity combinations

**Your selection**: _____________

**Rationale**: Determines how many example scenes to create and their complexity.

### 2. Entity Combination Approach

**Question**: Which entity combination pattern should the demonstration scenes use?

Options:

- [ ] **Minimal** - Use only the minimal example entities from Phase 3
- [x] **Mixed** - Combine Phase 2 entities (max, park-morning) with Phase 3 entities
- [ ] **All New** - Create entirely new entities for Phase 4 scenes

**Your selection**: _____________

**Rationale**: Determines whether we leverage existing entities or create new ones.

### 3. Workflow Documentation Depth

**Question**: How detailed should the scene generation workflow documentation be?

Options:

- [ ] **Brief** - Quick reference with entity-creator prompt example
- [x] **Standard** - Step-by-step workflow with examples and validation
- [ ] **Comprehensive** - Full tutorial with troubleshooting and multiple patterns

**Your selection**: _____________

**Rationale**: Affects documentation scope in quickstart.md.

---

## Tasks Covered (Phase 4: T015-T017)

- [ ] T015: Generate scene entity file combining character, style, and environment
- [ ] T016: Validate scene file format (YAML + Markdown)
- [ ] T017: Document scene generation workflow in quickstart.md

---

## Validation Steps

### Scene Entity Validation

After creating scenes, verify:

1. **File location**: Scene files exist in `content/entities/scenes/`
2. **YAML front-matter**: Contains name, type, description, version
3. **Entity references**: Properly references character, environment, and style entities
4. **Markdown content**: Contains narrative description of the scene
5. **Naming convention**: Uses kebab-case (e.g., `hero-library-quest.md`)

### Scene Template Compliance

```bash
# Verify scene follows template structure
cat content/entities/scenes/<scene-name>.md
```

**Expected structure**:

```yaml
---
name: <scene-name>
type: scene
description: "<one-line summary>"
version: v1
narrative: "<what happens in the scene>"
setting: "<where and when>"
mood: "<emotional tone>"
characters: ["<character-name>"]  # optional
environment: "<environment-name>"  # optional
style: "<style-name>"              # optional
---

<Narrative description in Markdown>
```

### Entity Reference Validation

```bash
# Verify referenced entities exist
for entity in hero-protagonist ancient-library cinematic-realism; do
  find content/entities -name "$entity.md" -type f
done
```

All referenced entities should exist in their respective directories.

### Documentation Validation

```bash
# Check quickstart.md updated with scene generation workflow
grep -A 20 "Scene Generation" docs/quickstart.md
```

Should include:

- Entity-creator prompt examples for scenes
- Explanation of entity references
- Validation steps for created scenes
- Example scene compositions

---

## Commit Message Template

```text
feat(scenes): add scene generation workflow and examples

- Generate scene entities combining characters, environments, styles
- Demonstrate entity reference patterns (standalone vs referenced)
- Validate scene template compliance (YAML + Markdown)
- Document scene generation workflow in quickstart.md

Phase 4/9: Scene Generation
Tasks: T015-T017
```

---

## Dependencies

**Requires**:

- Phase 3 complete (entity templates and examples must exist)
- Entity-creator agent from Phase 2 (operational workflow)
- Scene template at `content/entities/entity-templates/scene.template.md`
- Example entities: characters/, styles/, environments/

**Blocks**:

- Phase 5 (Asset Generation Setup - needs scene entities as input)
- Phase 6 (Production Image Generation - generates images from scenes)

---

## Implementation Notes

### Scene Generation Approach

Phase 4 focuses on **generating scene entities** (not yet images). Scenes are:

- **Entity files**: YAML + Markdown like characters, styles, environments
- **Composition layer**: Reference other entities to create narrative contexts
- **Input for image generation**: Phase 5+ will use scenes to generate actual images

### Entity-Creator Agent Usage

The entity-creator agent (from Phase 2) will be used to:

1. Analyze prompt requesting scene creation
2. Resolve entity dependencies (check if referenced entities exist)
3. Create scene entity file with proper YAML structure
4. Validate against scene.template.md
5. Log operation to `logs/create-scene-<name>-operation.log`

### Example Prompt Pattern

```text
@entity-creator Create a scene called "hero-library-quest" where the hero-protagonist
explores the ancient-library seeking knowledge. Use cinematic-realism style for dramatic
lighting. The hero searches through towering shelves of dusty tomes, looking for a
legendary artifact mentioned in ancient texts.
```

### Validation Strategy

Since Phase 4 doesn't involve image generation yet:

- **Manual validation**: Inspect created scene files
- **Template compliance**: Verify YAML structure matches scene.template.md
- **Entity references**: Check referenced entities exist
- **No automated tests**: Operational validation sufficient for entity file creation

---

## Success Criteria

Phase 4 is complete when:

1. ✅ At least one scene entity file created in `content/entities/scenes/`
2. ✅ Scene references existing character, environment, and/or style entities
3. ✅ Scene file follows template structure (YAML + Markdown narrative)
4. ✅ Scene generation workflow documented in quickstart.md with examples
5. ✅ Entity-creator agent successfully processes scene generation prompts
6. ✅ Tasks T015-T017 marked complete in tasks.md

---

## Phase 4 Completion Summary

**Status**: ✅ ALL TASKS COMPLETE

**Files Created (2 scenes + 1 documentation update)**:

1. ✅ `content/entities/scenes/hero-library-quest.md` (448 bytes, v1)
   - **Pattern**: Full composition (character + environment + style)
   - **References**: hero-protagonist, ancient-library, cinematic-realism
   - **Use Case**: Quest/adventure scene with dramatic lighting

2. ✅ `content/entities/scenes/max-golden-morning.md` (439 bytes, v1)
   - **Pattern**: Partial composition (character + style, environment in setting)
   - **References**: max (Phase 2), watercolor-dream (Phase 3)
   - **Use Case**: Joyful pet scene with soft artistic treatment

3. ✅ `docs/quickstart.md` - Updated with Scene Generation Workflow (2.2KB addition)
   - **Sections Added**:
     - Scene creation workflow (5 steps)
     - Entity-creator prompt examples
     - Scene composition patterns (3 patterns)
     - Common issues and solutions
     - Example scenes with pattern explanations
   - **Total Size**: 9.8KB

**Tasks Completed**: T015-T017 (3 tasks)

**Key Outcomes**:

- **2 Scene Entities**: Demonstrate different composition patterns
- **Mixed Entity Usage**: Combined Phase 2 (max) and Phase 3 (hero-protagonist, styles, environments) entities
- **Comprehensive Documentation**: 180+ lines of scene workflow guidance in quickstart.md
- **Flexible Patterns**: Showed full, partial, and standalone composition approaches
- **Ready for Phase 5**: Scene entities available as inputs for image generation

**Scene Composition Patterns Demonstrated**:

1. **Full Composition** (hero-library-quest): References all entity types
2. **Partial Composition** (max-golden-morning): Character + style, setting described inline

**Documentation Coverage**:

- Step-by-step scene creation workflow
- Entity-creator prompt examples (referenced and standalone patterns)
- Quality gate validation steps
- Common issues and troubleshooting
- Scene composition pattern comparison
- Template reference links

**Ready for Phase 5**: Asset Generation Setup (MCP, DVC, test image generation)

---

## Planning Notes

- Phase 4 is **preparation for image generation** (Phases 5-6)
- Scenes created here will be **inputs to image generation workflows**
- Focus is on **entity composition** and **narrative descriptions**
- No GenAI API calls or image generation yet
- Scene template from Phase 3 supports both standalone and referenced patterns
- Can leverage existing entities from Phase 2 (max, park-morning) and Phase 3 examples

**Next Phase**: Phase 5 will configure MCP servers, DVC, and generate first test images from these scenes.
