---
name: character
type: character
description: "Template defining the structure and validation rules for character entities"
version: v1
---

# Character Entity Template

Purpose: Defines the schema, validation rules, and quality gates for character entities used by the entity-creator agent.

Status: Draft - Created from entity-template.meta

---

## Template Structure

All character entity files MUST follow this structure in YAML front-matter and may include markdown body content describing usage, examples, and notes.

### Front-Matter (Required Fields)

```yaml
---
name: <entity-name>          # Kebab-case identifier (e.g., "max-the-dog")
type: character
description: "<one-line summary>"
version: v1
personality: <brief-personality-summary>
appearance: <brief-appearance-summary>
background: <short background or origin story>
relationships: []            # List of relationships to other entities (name@vN)
---
```

Required fields (enforced by validation rules): name, type, description, version, personality, appearance, background, relationships

Optional/Extended fields:
- visual_properties
- model_config
- abilities
- tags

---

## Format Rules

- `name`: Must be kebab-case (lowercase, hyphens allowed, alphanumeric)
- `type`: Must equal `character`
- `description`: 1-200 words recommended
- `version`: Simple integer format `v1`, `v2`, etc.
- `personality`: Short summary (1-3 sentences)
- `appearance`: Free-form but include distinguishing features (hair, clothing, color palette)
- `background`: Short origin/backstory (1-3 paragraphs max)
- `relationships`: Array of references in form `entity-type:name@vN` or `name` (defaults to latest)

---

## Quality Gates

Quality gates are evaluated during entity creation. Severity `critical` aborts creation; `warning` logs and continues (lenient mode).

**Quality Gates**:

1. QG-C001 - Name Format
   - Check: `name` follows kebab-case
   - Severity: critical
   - Action: Abort if fails

2. QG-C002 - Required Fields Present
   - Check: All required YAML keys exist in front-matter
   - Severity: critical
   - Action: Abort if fails

3. QG-C003 - Type Match
   - Check: `type` equals `character`
   - Severity: critical
   - Action: Abort if fails

4. QG-C004 - Description Length
   - Check: `description` <= 200 words
   - Severity: warning
   - Action: Log warning and continue if fails

5. QG-C005 - Personality Presence
   - Check: `personality` field not empty
   - Severity: warning
   - Action: Log warning and continue

6. QG-C006 - Relationships Format
   - Check: Each item in `relationships` follows `name` or `type:name@vN` format
   - Severity: warning
   - Action: Log malformed references and continue

---

## Validation Rules

```yaml
validation_rules:
  required_fields:
    - name
    - type
    - description
    - version
    - personality
    - appearance
    - background
    - relationships
  optional_fields:
    - visual_properties
    - model_config
    - abilities
    - tags
  format_rules:
    - "name: Must be kebab-case (lowercase, hyphens only)"
    - "type: Must be 'character'"
    - "description: Max 200 words recommended"
    - "relationships: Prefer 'type:name@vN' or 'name'"
```

---

## Examples

Example character front-matter:

```yaml
---
name: max-the-dog
type: character
description: "Max is a friendly golden retriever who loves fetch and people."
version: v1
personality: "Friendly, playful, loyal"
appearance: "Golden fur, medium build, wears a red collar"
background: "Rescued from a shelter at 2 years old, Max loves parks and children."
relationships:
  - owner:jane-doe@v1
  - friend:buddy-the-cat
---
```

Notes: Templates may be extended with additional gates or format rules as project needs evolve. Use this template as the canonical structure for character entities.
