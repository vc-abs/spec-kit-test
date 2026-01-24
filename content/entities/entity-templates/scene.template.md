---
name: scene
type: entity-template
description: "Template for defining scene entities with flexible entity references"
version: v1
---

# Scene Entity Template

## Purpose

Defines the structure and validation rules for scene entities that describe narrative moments, settings, and contexts for asset generation. Scenes can be standalone or reference other entities (characters, environments, styles).

## Required Fields

### Core Fields

- **name** (string): Unique identifier for the scene (kebab-case)
- **type** (string): Must be "scene"
- **description** (string): Brief summary of the scene
- **version** (string): Version identifier (e.g., v1, v2)

### Scene-Specific Fields

- **narrative** (string): What happens in this scene (action, event, or moment)
- **setting** (string): Where and when the scene takes place
- **mood** (string): Emotional tone or atmosphere

## Optional Fields

- **characters** (array[string]): Character entity names that appear in the scene (e.g., ["max", "rex"])
- **environment** (string): Environment entity name for the setting (e.g., "ancient-library")
- **style** (string): Style entity name for visual treatment (e.g., "cinematic-realism")
- **time_of_day** (string): Specific time context (e.g., "morning", "sunset", "midnight")
- **weather** (string): Weather conditions (e.g., "sunny", "rainy", "foggy")
- **tags** (array[string]): Additional categorization tags

## Validation Rules

### VR-SCENE-001: Name Format

- Name must use kebab-case (lowercase with hyphens)
- Only alphanumeric characters and hyphens allowed
- Must be unique within scenes directory

### VR-SCENE-002: Required Field Presence

- All core fields and scene-specific required fields must be present
- Empty strings not allowed for required fields

### VR-SCENE-003: Entity References Format

- Referenced entity names must use kebab-case
- References are optional but must be valid if present

## Quality Gates

### QG-SCENE-001: Narrative Defined (critical)

- **Check**: narrative field is non-empty and descriptive
- **Fix**: Describe the action, event, or moment happening
- **Why**: Narrative provides the core content of the scene

### QG-SCENE-002: Setting Established (critical)

- **Check**: setting field is non-empty
- **Fix**: Define where and when the scene occurs
- **Why**: Setting grounds the scene in space and time

### QG-SCENE-003: Mood Conveyed (warning)

- **Check**: mood field is non-empty
- **Fix**: Specify the emotional tone or atmosphere
- **Why**: Mood guides the aesthetic and emotional interpretation

### QG-SCENE-004: Entity References Valid (conditional)

- **Check**: If entity references present, they must exist or be valid names
- **Fix**: Verify referenced entities exist or remove invalid references
- **Why**: Broken references cause generation failures

## Dependency Patterns

### Standalone Scene

A scene with no entity references, fully self-contained:

```yaml
---
name: morning-walk
type: scene
description: "A peaceful walk through a quiet park at dawn"
version: v1
narrative: "A solitary figure walks along a tree-lined path as the sun rises"
setting: "urban park at dawn, dew on grass, empty benches"
mood: "peaceful, contemplative, fresh"
time_of_day: "early morning"
tags: ["park", "morning", "solitude"]
---

The first light of day filters through tree canopy, casting long shadows across
a winding path. Birds begin their morning chorus.
```

### Scene with Entity References

A scene that references other entities for consistency:

```yaml
---
name: park-morning
type: scene
description: "Max's morning routine at the neighborhood park"
version: v1
narrative: "Max plays fetch with his owner in the dewy morning grass"
setting: "local park at sunrise, scattered trees and open lawn"
mood: "joyful, energetic, fresh"
characters: ["max"]
environment: "neighborhood-park"
style: "warm-naturalistic"
time_of_day: "sunrise"
weather: "clear"
tags: ["park", "morning", "dog", "play"]
---

Golden morning light illuminates the park as Max bounds across the grass,
tail wagging enthusiastically during his favorite game.
```

## Quality Gate Results

**Standalone Example** (morning-walk):

- ✅ QG-SCENE-001: Narrative defined ("A solitary figure walks...")
- ✅ QG-SCENE-002: Setting established ("urban park at dawn...")
- ✅ QG-SCENE-003: Mood conveyed ("peaceful, contemplative, fresh")
- ✅ QG-SCENE-004: No entity references to validate

**Referenced Example** (park-morning):

- ✅ QG-SCENE-001: Narrative defined ("Max plays fetch...")
- ✅ QG-SCENE-002: Setting established ("local park at sunrise...")
- ✅ QG-SCENE-003: Mood conveyed ("joyful, energetic, fresh")
- ⚠️ QG-SCENE-004: References assume entities exist (max, neighborhood-park, warm-naturalistic)

## Usage Notes

Scenes can be created with or without entity references depending on workflow needs. Standalone scenes are useful for quick generation or when specific entities haven't been defined. Referenced scenes enable consistency across multiple assets and complex compositions.
