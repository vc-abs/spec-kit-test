---
name: mcp-config
type: entity-template
description: "Template for MCP configuration entities used in GenAI asset generation workflows"
version: v2
entity-type: mcp-config
applies-to: ["content/entities/mcp-configs/*.md"]
---

# MCP Config Entity Template

## Purpose

Defines standalone MCP configuration entities that specify how to invoke GenAI providers for asset generation. These entities are resolved by the entity creator and referenced during image/video generation workflows.

## Entity Structure

```yaml
---
name: <config-name>
type: mcp-config
description: "<human-readable description of configuration>"
version: v1
provider: <provider-name>  # google, openai, stability, anthropic
model: <model-identifier>  # e.g., imagen-3.0-generate-001
server: <mcp-server-name>  # Must match .vscode/settings.json MCP server
parameters:
  aspect-ratio: <ratio>  # "1:1", "16:9", "9:16", "4:3"
  quality: <quality>     # "standard", "high", "premium"
  safety-filter: <level> # "none", "low", "medium", "high"
  prompt-enhancement: <boolean>  # true/false
  # Additional provider-specific parameters
tags: [<tag1>, <tag2>]
---

# <Config Name>

<Description of when to use this configuration>

## Use Cases

- <Use case 1>
- <Use case 2>

## Parameters

- **aspect_ratio**: <explanation>
- **quality**: <explanation>
- **safety_filter**: <explanation>

## Notes

<Any additional context or limitations>
```

## Required Fields

- **name** (string): Unique identifier in kebab-case
- **type** (string): Must be "mcp-config"
- **description** (string): Human-readable description
- **version** (string): Version identifier (e.g., v1, v2)
- **provider** (string): GenAI provider name (google, openai, stability, anthropic)
- **model** (string): Specific model identifier
- **server** (string): MCP server name matching `.vscode/settings.json`
- **parameters** (object): Generation parameters

## Optional Fields

- **tags** (array[string]): Categorization tags
- **enabled** (boolean): Whether configuration is active (default: true)
- **cost-tier** (string): Relative cost indicator (low, medium, high)

## Parameter Fields

Common parameters across providers:

- **aspect-ratio** (string): Image dimensions ratio
- **quality** (string): Generation quality level
- **safety-filter** (string): Content moderation level
- **prompt-enhancement** (boolean): Enable automatic prompt improvements

Provider-specific parameters should be documented in entity description.

## Validation Rules

### VR-MCP-001: Server Name Match

- MCP config `server` field must reference an existing MCP server in `.vscode/settings.json`
- Server name must use kebab-case

### VR-MCP-002: Provider Model Consistency

- Model identifier must be valid for the specified provider
- Example: `imagen-3.0-generate-001` valid for `provider: google`

### VR-MCP-003: Parameter Schema

- Required parameters: aspect_ratio, quality, safety_filter
- Values must be from documented options
- Additional provider-specific parameters allowed

### VR-MCP-004: Version Format

- Version must follow pattern: v\d+ (e.g., v1, v2, v10)

## Quality Gates

### QG-MCP-001: Server Configuration Exists (critical)

- **Check**: Referenced MCP server exists in `.vscode/settings.json`
- **Fix**: Add server configuration or update entity `server` field
- **Why**: Missing server prevents asset generation

### QG-MCP-002: Model Compatibility (critical)

- **Check**: Model identifier valid for provider
- **Fix**: Update model to match provider capabilities
- **Why**: Invalid model causes API errors

### QG-MCP-003: Parameter Values Valid (warning)

- **Check**: Parameter values within documented ranges
- **Fix**: Adjust to valid options or add documentation
- **Why**: Invalid parameters may be ignored or cause errors

### QG-MCP-004: Cost Awareness (info)

- **Check**: High-cost configurations marked with cost_tier
- **Fix**: Add cost_tier field to expensive configurations
- **Why**: Helps users make informed decisions

## Entity Resolution

During asset generation, the entity creator resolves MCP configs:

1. **From Prompt**: User specifies config by name (e.g., "use gemini-high-quality")
2. **From Scene**: Scene references config via tags or inference
3. **Default**: Falls back to provider default configuration

Example prompt usage:

```
@entity-creator generate image for hero-library-quest using gemini-high-quality config
```

## Integration with Asset Generation

MCP config entities are used in the asset generation workflow:

1. Entity creator reads scene entity
2. Resolves appropriate MCP config (from prompt or inference)
3. Loads MCP server configuration from `.vscode/settings.json`
4. Constructs generation request combining scene narrative + MCP parameters
5. Invokes MCP server to generate asset
6. Saves output and tracks with DVC
