# Phase Plan 03: Entity Type Templates

**Phase Goal**: Create concrete entity templates (character, style, environment, scene) with validation rules, example entities, and documentation.

**Status**: 🚧 IN PROGRESS

**Iterations**: 1 (initial planning)

---

## Files to Create/Modify (11 files)

### New Templates (4)

1. `content/entities/entity-template/character.template.md` - Character entity template (ALREADY EXISTS from Test 0 - may refine)
2. `content/entities/entity-template/style.template.md` - Style/art direction template with validation rules
3. `content/entities/entity-template/environment.template.md` - Environment/setting template with validation rules
4. `content/entities/entity-template/scene.template.md` - Scene template with validation rules for narrative descriptions

### Example Entities (6)

1. `content/entities/character/hero-protagonist.md` - Example character entity
2. `content/entities/character/wise-mentor.md` - Example character entity
3. `content/entities/style/cinematic-realism.md` - Example style entity
4. `content/entities/style/watercolor-dream.md` - Example style entity
5. `content/entities/environment/ancient-library.md` - Example environment entity
6. `content/entities/environment/neon-city.md` - Example environment entity

### Documentation (1)

1. `docs/quickstart.md` - Entity creation workflow and usage guide (CREATE NEW)

---

## Required User Inputs

### 1. Character Template Refinement

**Question**: The character.template.md already exists from Phase 2 Test 0. Should we:

Options:

- [ ] **Keep as-is** - Use the bootstrapped version without changes
- [ ] **Refine** - Review and improve based on Phase 2 learnings
- [ ] **Recreate** - Start fresh with more comprehensive structure

**Your selection**: _____________

**Rationale**: Determines whether to treat character template as complete or iterate on it.

### 2. Example Entity Scope

**Question**: How detailed should example entities be?

Options:

- [ ] **Minimal** - Just enough to demonstrate structure (2-3 properties each)
- [ ] **Realistic** - Production-ready examples with full details
- [ ] **Varied** - Mix of simple and complex examples

**Your selection**: _____________

**Rationale**: Affects time investment and usefulness as reference material.

### 3. Scene Template Dependencies

**Question**: Should scene template require or just suggest entity dependencies?

Options:

- [ ] **Required** - Scene MUST reference character, style, environment entities
- [ ] **Suggested** - Scene CAN reference entities but not mandatory
- [ ] **Flexible** - Scene can be standalone or reference entities

**Your selection**: _____________

**Rationale**: Determines coupling between entity types and workflow flexibility.

---

## Tasks Covered (Phase 3: T008-T014)

- [ ] T008: Create character template (review existing from Test 0)
- [ ] T009: Create style template
- [ ] T010: Create environment template
- [ ] T011: Create scene template
- [ ] T012: Create example entities (6 total: 2 per type for character/style/environment)
- [ ] T013: Validate entity file naming and kebab-case enforcement
- [ ] T014: Document entity creation workflow in quickstart.md

---

## Validation Steps

### Documentation Validation

- [ ] All 4 templates exist in `content/entities/entity-template/`
- [ ] Templates follow entity-template.template.md structure (minimal front-matter, rules in body)
- [ ] Each template has validation rules section
- [ ] Each template has quality gates with severity levels
- [ ] Example entities exist in correct directories
- [ ] Example entities use kebab-case filenames
- [ ] Example entities have valid YAML front-matter
- [ ] quickstart.md created with entity workflow documentation

### Content Validation

- [ ] Character template defines personality, appearance, background, relationships fields
- [ ] Style template defines art direction, color palette, mood, technique fields
- [ ] Environment template defines location, atmosphere, lighting, time fields
- [ ] Scene template defines narrative, characters, setting, mood fields
- [ ] Example entities demonstrate template usage
- [ ] Example entities validate successfully against their templates

---

## Commit Message

```
feat(templates): add entity type templates and examples

Phase 3: Entity Type Templates (T008-T014)

Templates:
- Review and refine character.template.md from Phase 2
- Add style.template.md for art direction definitions
- Add environment.template.md for setting/location definitions
- Add scene.template.md for narrative scene descriptions

Examples:
- Add 2 character examples (hero-protagonist, wise-mentor)
- Add 2 style examples (cinematic-realism, watercolor-dream)
- Add 2 environment examples (ancient-library, neon-city)

Documentation:
- Create quickstart.md with entity creation workflow
- Document template structure and validation rules
- Include examples for each entity type

All templates follow entity-template meta-template structure with
minimal front-matter and validation rules in body. Example entities
demonstrate proper YAML front-matter and kebab-case naming.
```

---

## Dependencies

- **Requires**: Phase 2 complete (entity-template.template.md, entity-creator.agent.md)
- **Blocks**: Phase 4 (Scene Generation - needs scene template)
- **Blocks**: Phase 5 (Asset Generation - needs all templates and examples)

---

## Next Phase

**Phase 4: Scene Generation** (T015-T017)

- Generate scene entity files combining character, style, environment
- Validate scene file format with entity references
- Document scene generation workflow

---

## Design Notes

### Template Structure Consistency

All templates should follow the same pattern established by entity-template.template.md:

1. **Minimal Front-Matter**: name, type, description, version only
2. **Body Structure**:
   - Purpose/Overview
   - Required Fields (with types and constraints)
   - Optional Fields
   - Validation Rules
   - Quality Gates (with severity levels: critical/warning)
   - Self-Validation Example

### Quality Gates by Entity Type

**Character Template**:

- QG-CHAR-001: Name must be non-empty (critical)
- QG-CHAR-002: Personality traits required (critical)
- QG-CHAR-003: Appearance description present (warning)
- QG-CHAR-004: Background context provided (warning)

**Style Template**:

- QG-STYLE-001: Art direction defined (critical)
- QG-STYLE-002: Color palette specified (critical)
- QG-STYLE-003: Mood/atmosphere described (warning)
- QG-STYLE-004: Technique/medium noted (warning)

**Environment Template**:

- QG-ENV-001: Location clearly defined (critical)
- QG-ENV-002: Atmosphere described (critical)
- QG-ENV-003: Lighting conditions specified (warning)
- QG-ENV-004: Time period/context provided (warning)

**Scene Template**:

- QG-SCENE-001: Narrative description present (critical)
- QG-SCENE-002: Setting/location specified (critical)
- QG-SCENE-003: Character references (if any) valid (critical)
- QG-SCENE-004: Mood/tone established (warning)
- QG-SCENE-005: Entity dependencies resolved (critical if referenced)

### Example Entity Guidelines

**Naming Convention**: kebab-case, descriptive, 2-3 words

- ✅ `hero-protagonist.md`, `wise-mentor.md`
- ✅ `cinematic-realism.md`, `watercolor-dream.md`
- ❌ `character1.md`, `style_modern.md`, `Env-Forest.md`

**YAML Front-Matter**: Consistent across entity types

```yaml
---
name: hero-protagonist
type: character
description: "Brave protagonist on hero's journey"
version: v1
# Type-specific fields follow
---
```

**Body Content**: Markdown with rich descriptions, examples, usage notes

---

## Open Questions

1. **Template Versioning**: Should templates themselves have versions (currently only entities do)?
2. **Template Inheritance**: Should scene template reference character/style/environment templates, or keep independent?
3. **Validation Strictness**: Continue with "lenient" mode from Phase 2, or make templates more strict?
4. **Example Complexity**: Balance between simple demos vs. production-ready reference material

---

## Iteration Log

### Iteration 1: Initial Planning (2026-01-23)

**Status**: 🚧 IN PROGRESS

**Planning Notes**:

- Phase 2 already created character.template.md (3800 bytes, 8 quality gates)
- Can review and refine character template or use as-is
- Need 3 new templates: style, environment, scene
- Need 6 example entities demonstrating each template
- Need quickstart.md for user-facing documentation

**Decisions Needed**:

1. Character template: keep/refine/recreate?
2. Example entity scope: minimal/realistic/varied?
3. Scene dependencies: required/suggested/flexible?

**Next Steps**:

- Get user input on 3 questions
- Begin template creation (style, environment, scene)
- Create example entities
- Write quickstart.md
