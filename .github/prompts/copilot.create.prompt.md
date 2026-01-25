---
name: copilot.create
description: Universal creation command that delegates to entity-creator agent
agent: entity-creator
---

# Create Command

**Usage**: `/copilot.create <what-to-create>`

**Purpose**: Create entities (characters, scenes, styles, environments) and generate assets (images) from scene entities.

**Agent**: Delegates to `entity-creator` agent for all operations.

## Examples

**Create a character**:

```text
/copilot.create a character named max, a friendly golden retriever
```

**Create a scene**:

```text
/copilot.create a scene with max running in the park at sunrise
```

**Generate an image**:

```text
/copilot.create an image from the max-golden-morning scene
```

**Batch generation**:

```text
/copilot.create 3 variations of the sunset park scene
```

## Related Documentation

- Entity Creator Agent: [../agents/entity-creator.agent.md](../agents/entity-creator.agent.md)
- Quickstart Guide: [../../docs/quickstart.md](../../docs/quickstart.md)
