---
name: entity-template
type: entity-template
description: "Bootstrap meta-template defining structure and validation rules for all entity types"
version: v1
---

# Entity Template Meta-Template

**Purpose**: Bootstrap template that defines how all other entity templates (character, style, environment, scene, etc.) are structured. Templates created from this meta-template guide the entity-creator agent in creating and validating entities.

**Status**: Bootstrap - Self-validating

---

## Entity Template Structure

All entity templates MUST follow this structure:

### Front-Matter (Minimal Required Fields)

```yaml
---
name: <template-name>              # Kebab-case identifier (e.g., "character", "style")
type: <entity-type>                 # Entity type this template defines
description: "<brief-description>"  # Single-line purpose statement
version: v<N>                       # Simple version (v1, v2, v3, etc.)
---
```

**Note**: Validation rules and quality gates are defined in the template BODY, not front-matter.

### Body Structure (Markdown)

1. **Template Purpose**: What entities of this type represent
2. **Required Fields**: List of mandatory YAML fields for entities of this type
3. **Optional Fields**: List of optional YAML fields
4. **Format Rules**: Constraints on field values (kebab-case, max length, etc.)
5. **Quality Gates**: Validation checks with severity levels (critical/warning)
6. **Examples** (optional): Entity-creator agent can find similar entities in project as examples

---

## Validation Rules Framework

Templates define validation rules in the body using this format:

### Required Fields

List all mandatory YAML keys that entities of this type MUST have:

```markdown
**Required Fields**:
- `name` - Kebab-case entity identifier
- `type` - Entity type (must match template type)
- `description` - Brief purpose statement
```

### Optional Fields

List YAML keys that MAY be present:

```markdown
**Optional Fields**:
- `visual_properties` - Visual characteristics
- `model_config` - GenAI model configuration
- `dependencies` - References to other entities
```

### Format Rules

Specify constraints on field values:

```markdown
**Format Rules**:
- `name`: Must be kebab-case (lowercase, hyphens only, alphanumeric)
- `description`: 1-200 words
- `dependencies`: Must reference existing entities with version tags
```

---

## Quality Gates Framework

Templates define quality gates in the body using this format:

### Gate Structure

```markdown
**Quality Gates**:

1. **QG001 - Name Format**
   - Check: Entity name follows kebab-case convention
   - Severity: critical
   - Action: Abort if fails

2. **QG002 - Required Fields Present**
   - Check: All required fields exist in YAML front-matter
   - Severity: critical
   - Action: Abort if fails

3. **QG003 - Description Length**
   - Check: Description is concise (< 150 words)
   - Severity: warning
   - Action: Log warning and continue if fails
```

### Severity Levels

- **critical**: Entity creation ABORTS if gate fails
- **warning**: Gate failure LOGGED, creation CONTINUES (lenient mode)

---

## Self-Validation

This template validates itself using its own rules:

**Required Fields Check**: ✅

- `name`: entity-template ✓
- `type`: entity-template ✓
- `description`: Present ✓
- `version`: v1 ✓

**Format Rules Check**: ✅

- `name`: kebab-case ✓
- `description`: < 200 words ✓

**Quality Gates**: ✅

- QG001 (Name Format): Pass ✓
- QG002 (Required Fields): Pass ✓
- QG003 (Description Length): Pass ✓

---

## Template Evolution

When updating this template:

1. Increment version: `v1` → `v2`
2. Apply own validation rules to the update
3. Document changes in git commit
4. Update dependent templates if schema changes

---

## Related Documentation

- Entity-Creator Agent: [.github/agents/entity-creator.agent.md](../../../.github/agents/entity-creator.agent.md)
- Technical Plan: [specs/001-genai-asset-system/plan.md](../../../specs/001-genai-asset-system/plan.md)
- Data Model: [specs/001-genai-asset-system/data-model.md](../../../specs/001-genai-asset-system/data-model.md)

**Selected Mode**: Lenient validation

- **Critical errors**: Abort entity creation immediately
- **Warnings**: Log warning and continue entity creation
- **Behavior**: Allow entities with non-critical issues to be created

**Rationale**: Enables faster iteration during development while catching serious issues.

---

## Entity Versioning: Simple Integer Format

**Format**: `@v1`, `@v2`, `@v3` (simple integer increments)

**Usage**:

- Entity references in YAML use version tags: `character: max@v1`
- Version increments when entity content changes materially
- Version history tracked through git commits

**Versioning Workflow**:

1. Initial entity creation: `@v1`
2. Material update: Increment to `@v2`, `@v3`, etc.
3. References specify version to maintain consistency

---

## Filename Conflict Resolution

**Strategy**: Context-aware conflict handling

**Rules**:

1. **Explicit update request** (e.g., "update character/max.md"):
   - Allow file modification
   - Increment version in YAML front-matter: `@v1` → `@v2`
   - Log update operation

2. **Explicit new version request** (e.g., "create max@v2"):
   - Allow file modification
   - Update version to specified value
   - Log version creation

3. **Create request for existing file** (e.g., "create character/max.md"):
   - **ABORT** with error: "File already exists. Use 'update' or specify new version."
   - Require user to clarify intent

**Rationale**: Prevents accidental overwrites while allowing intentional updates.

---

## Quality Gates Framework

All entity templates MUST define quality gates for validation:

### Gate Structure

```yaml
quality_gates:
  - id: QG001
    description: "Entity name follows kebab-case convention"
    severity: critical
  - id: QG002
    description: "All required fields present in YAML front-matter"
    severity: critical
  - id: QG003
    description: "Description is clear and concise (< 200 words)"
    severity: warning
```

### Severity Levels

- **critical**: Validation failure aborts entity creation
- **warning**: Validation issue logged, creation continues (lenient mode)

---

## Validation Rules Framework

All entity templates MUST define validation rules:

### Rule Categories

1. **Required Fields**: YAML keys that MUST be present
2. **Optional Fields**: YAML keys that MAY be present
3. **Format Rules**: Constraints on field values (e.g., kebab-case, max length)

### Example

```yaml
validation_rules:
  required_fields:
    - name
    - type
    - description
  optional_fields:
    - visual_properties
    - model_config
  format_rules:
    - "name: Must be kebab-case (lowercase, hyphens only)"
    - "description: Must be 1-200 words"
```

---

## Template Creation Workflow

To create a new entity template using this meta-template:

1. **Define entity type**: What does this template represent? (character, style, scene, etc.)
2. **Specify required fields**: What YAML keys are mandatory for this entity type?
3. **Specify optional fields**: What additional YAML keys are useful but not required?
4. **Define format rules**: What constraints apply to field values?
5. **Define quality gates**: What validation checks ensure entity quality?
6. **Examples** (optional): Entity-creator agent can search project for similar entities as examples

**Self-Validation**: This meta-template can validate itself using its own validation rules and quality gates framework, demonstrating the template validation pattern.

---

## Bootstrap Template Notes

- **Self-referential**: This template was NOT created from itself (bootstrap paradox)
- **Foundation**: All other templates (character.template.md, scene.template.md) ARE created from this template
- **Immutable**: This template should remain stable; versioning applies to entities created FROM templates, not the bootstrap itself
- **Meta-validation**: This template defines validation for OTHER templates, not for itself

---

## Related Documentation

- Technical Plan: [specs/001-genai-asset-system/plan.md](../../../specs/001-genai-asset-system/plan.md)
- Data Model: [specs/001-genai-asset-system/data-model.md](../../../specs/001-genai-asset-system/data-model.md)
- Entity-Creator Agent: [.github/agents/entity-creator.agent.md](../../../.github/agents/entity-creator.agent.md)
- Quickstart Guide: [specs/001-genai-asset-system/quickstart.md](../../../specs/001-genai-asset-system/quickstart.md)
