---
name: character
type: entity-template
description: "Template for defining character entities with comprehensive personality, appearance, and background"
version: v2
---

# Character Entity Template

## Purpose

Defines the structure and validation rules for character entities used in GenAI asset generation workflows. This template provides comprehensive structure for creating rich, multidimensional characters suitable for narrative and visual consistency.

## Required Fields

### Core Fields

- **name** (string): Unique identifier for the character (kebab-case)
- **type** (string): Must be "character"
- **description** (string): Brief character summary (1-2 sentences)
- **version** (string): Version identifier (e.g., v1, v2)

### Character-Specific Required Fields

- **species** (string): Character's species (e.g., "dog", "cat", "human", "dragon", "alien")
- **personality** (string): Core personality traits (comma-separated or descriptive)
- **appearance** (string): Physical description covering key visual elements

## Optional Fields

### Physical Attributes

- **breed** (string): Specific breed or sub-type if applicable
- **age** (string): Age description (e.g., "puppy", "young adult", "middle-aged", "elderly")
- **height** (string): Height description (e.g., "tall", "average", "short", "towering")
- **build** (string): Physical build (e.g., "athletic", "slender", "stocky", "muscular")
- **distinctive_features** (string): Unique physical traits (e.g., "scar over left eye", "three tails")

### Psychological Attributes

- **motivations** (string): What drives the character (goals, desires, fears)
- **flaws** (string): Character weaknesses or negative traits
- **strengths** (string): Character capabilities or positive traits
- **voice** (string): Speech patterns, tone, or communication style

### Contextual Attributes

- **backstory** (string): Character history and background
- **occupation** (string): Role, job, or primary activity
- **relationships** (array[string]): Related character names (e.g., ["max", "buddy"])
- **cultural_context** (string): Cultural, ethnic, or world-building context
- **emotional_state** (string): Default or current emotional baseline

### Categorization

- **archetype** (string): Character archetype (e.g., "hero", "mentor", "trickster", "guardian")
- **role** (string): Narrative role (e.g., "protagonist", "antagonist", "supporting")
- **tags** (array[string]): Additional categorization tags

## Validation Rules

### VR-CHAR-001: Name Format

- Name must use kebab-case (lowercase with hyphens)
- Only alphanumeric characters and hyphens allowed
- Must be unique within characters directory

### VR-CHAR-002: Required Field Presence

- All core fields and character-specific required fields must be present
- Empty strings not allowed for required fields
- Description must be 1-2 complete sentences

### VR-CHAR-003: Species Format

- Species should be lowercase, single word or hyphenated
- Common values: dog, cat, human, dragon, wolf, alien, robot, etc.

### VR-CHAR-004: Personality Trait Count

- Personality should contain at least 3 distinct traits or equivalent descriptive text
- Traits should be meaningful and non-redundant

### VR-CHAR-005: Appearance Completeness

- Appearance should cover multiple physical aspects (color, size, features)
- Should be sufficient for visual generation consistency

## Quality Gates

### QG-CHAR-001: Species Specified (critical)

- **Check**: species field is non-empty and valid
- **Fix**: Add species information using standard format
- **Why**: Species is essential for visual generation and establishes fundamental form

### QG-CHAR-002: Personality Defined (critical)

- **Check**: personality field has at least 3 distinct traits or rich descriptive text
- **Fix**: Add descriptive personality traits covering different dimensions
- **Why**: Personality guides behavioral and expressive characteristics

### QG-CHAR-003: Appearance Described (critical)

- **Check**: appearance field is present, non-empty, and covers multiple visual aspects
- **Fix**: Add comprehensive physical description
- **Why**: Appearance details are essential for visual consistency

### QG-CHAR-004: Motivations Present (warning)

- **Check**: motivations field is present and non-empty
- **Fix**: Define what drives the character (goals, desires, fears)
- **Why**: Motivations add depth and guide narrative decisions

### QG-CHAR-005: Age Specified (warning)

- **Check**: age field is non-empty and descriptive
- **Fix**: Specify age category or life stage
- **Why**: Age affects physical characteristics and behavior

### QG-CHAR-006: Backstory Provided (warning)

- **Check**: backstory field is present with meaningful content
- **Fix**: Add character history or origin
- **Why**: Backstory provides context and depth

### QG-CHAR-007: Voice Defined (info)

- **Check**: voice field describes speech or communication style
- **Fix**: Add voice/speech characteristics
- **Why**: Voice adds character dimension for dialogue and interaction

### QG-CHAR-008: Emotional State Described (info)

- **Check**: emotional_state field is present
- **Fix**: Define default emotional baseline
- **Why**: Emotional state guides expressive generation

### QG-CHAR-009: Archetype Assigned (info)

- **Check**: archetype field uses recognized character archetype
- **Fix**: Assign appropriate archetype (hero, mentor, trickster, etc.)
- **Why**: Archetypes provide narrative framework

### QG-CHAR-010: Role Specified (info)

- **Check**: role field defines narrative function
- **Fix**: Specify role (protagonist, antagonist, supporting)
- **Why**: Role clarifies character's narrative importance

## Self-Validation Examples

### Example 1: Minimal Character (Required Fields Only)

```yaml
---
name: luna
type: character
description: "Graceful calico cat with independent spirit and sharp intelligence"
version: v1
species: cat
personality: "independent, intelligent, observant"
appearance: "calico coat with orange, black, and white patches, bright green eyes, sleek build"
---

Luna is a calico cat who watches the world with keen eyes and moves through
spaces with quiet confidence.
```

**Validation Results**:

- ✅ QG-CHAR-001: Species specified ("cat")
- ✅ QG-CHAR-002: Personality defined (3 traits)
- ✅ QG-CHAR-003: Appearance described (coat, eyes, build)
- ⚠️ QG-CHAR-004: Motivations not provided
- ⚠️ QG-CHAR-005: Age not specified
- ⚠️ QG-CHAR-006: Backstory not provided
- ℹ️ QG-CHAR-007-010: Optional attributes not provided

### Example 2: Comprehensive Character

```yaml
---
name: aria-stormrider
type: character
description: "Battle-hardened sky pirate captain seeking redemption for past betrayals"
version: v1
species: human
age: "mid-thirties"
height: "tall"
build: "athletic and weathered"
personality: "bold, charismatic, haunted by guilt, fiercely protective of crew"
appearance: "sun-weathered skin, short dark hair with silver streak, piercing blue eyes, visible scars on arms"
distinctive_features: "mechanical left hand (brass and copper), lightning-bolt tattoo on neck"
motivations: "Seeks to undo a past betrayal that cost innocent lives, protect her crew from her enemies"
flaws: "Reckless when protecting others, struggles with trust, drinks to cope with guilt"
strengths: "Expert pilot, natural leader, quick tactical thinking, unshakeable in crisis"
voice: "gravelly and commanding, with occasional warmth for trusted allies"
backstory: "Former naval officer turned pirate after refusing an immoral order. Lost her hand defending civilians during a raid. Now captains the airship 'Tempest's Fury' while seeking redemption."
occupation: "sky pirate captain"
relationships: ["first-mate-kael", "rival-captain-vex"]
cultural_context: "steampunk sky-kingdoms, matriarchal pirate culture"
emotional_state: "determined but burdened, masks pain with bravado"
archetype: "fallen hero"
role: "protagonist"
tags: ["pirate", "captain", "human", "steampunk", "redemption-arc"]
---

Captain Aria Stormrider stands at the helm of her airship with the confidence of
someone who has cheated death more times than she can count. The silver streak in
her dark hair and the mechanical hand that grips the wheel tell stories of battles
won and prices paid. Her blue eyes scan the horizon with the intensity of someone
always watching for threats—or opportunities for redemption.

Behind her commanding presence lies a woman haunted by choices made years ago,
choices that cost innocent lives. Every daring raid, every impossible rescue, is
her attempt to balance the scales. Her crew follows her not just for the treasure,
but because they've seen her sacrifice everything to protect them.

The brass and copper mechanics of her left hand click softly as she adjusts
course—a constant reminder of the day she chose to defend civilians rather than
follow orders. That choice cost her hand, her commission, and her old life. But
it gave her something more valuable: a purpose beyond herself.
```

**Validation Results**:

- ✅ QG-CHAR-001: Species specified ("human")
- ✅ QG-CHAR-002: Personality defined (4 distinct traits)
- ✅ QG-CHAR-003: Appearance comprehensive (multiple visual elements)
- ✅ QG-CHAR-004: Motivations present and detailed
- ✅ QG-CHAR-005: Age specified ("mid-thirties")
- ✅ QG-CHAR-006: Backstory provided with depth
- ✅ QG-CHAR-007: Voice defined ("gravelly and commanding...")
- ✅ QG-CHAR-008: Emotional state described ("determined but burdened...")
- ✅ QG-CHAR-009: Archetype assigned ("fallen hero")
- ✅ QG-CHAR-010: Role specified ("protagonist")

## Usage Notes

Character entities serve as the foundation for consistent character representation across multiple generated assets, ensuring personality and visual coherence. This template supports both minimal character definitions (required fields only) and comprehensive character development (with optional psychological, contextual, and narrative attributes). Choose the level of detail appropriate for your project needs.
