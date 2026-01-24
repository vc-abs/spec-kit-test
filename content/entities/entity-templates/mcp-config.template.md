---
name: mcp-config
type: entity-template
description: "Template for configuring MCP (Model Context Protocol) servers for GenAI asset generation"
version: v1
---

# MCP Configuration Template

## Purpose

Defines the structure for configuring MCP servers that enable Copilot to interact with GenAI providers for image generation, video creation, and other asset workflows.

## MCP Server Types

### 1. Image Generation Server

**Purpose**: Generate images from text prompts using GenAI models (Gemini Imagen, DALL-E, Stable Diffusion)

**Configuration**:

```json
{
  "mcpServers": {
    "gemini-imagen": {
      "command": "npx",
      "args": ["-y", "@google/generative-ai-mcp-server"],
      "env": {
        "GOOGLE_API_KEY": "${env:GOOGLE_API_KEY}",
        "MODEL_NAME": "imagen-3.0-generate-001"
      }
    }
  }
}
```

**Capabilities**:

- Generate images from text prompts
- Support various aspect ratios (1:1, 16:9, 9:16)
- Control image quality and style
- Safety filtering and content moderation

### 2. Asset Management Server (Future)

**Purpose**: Manage generated assets, track versions, coordinate DVC

**Configuration**: TBD in future phases

### 3. Workflow Orchestration Server (Future)

**Purpose**: Coordinate multi-step generation workflows (e.g., storyboard → images → video)

**Configuration**: TBD in future phases

## Required Fields

### Core Configuration

- **server_name** (string): Unique identifier for the MCP server
- **command** (string): Executable command to start the server
- **args** (array[string]): Command-line arguments
- **env** (object): Environment variables (API keys, model names)

### Optional Fields

- **description** (string): Human-readable server description
- **enabled** (boolean): Whether server is active (default: true)
- **timeout** (number): Server startup timeout in milliseconds
- **capabilities** (array[string]): List of supported operations

## Environment Variables Pattern

MCP servers should reference environment variables from `.env` file:

```json
"env": {
  "GOOGLE_API_KEY": "${env:GOOGLE_API_KEY}",
  "MODEL_NAME": "${env:GEMINI_IMAGE_MODEL}"
}
```

**Never hard-code API keys** in VS Code settings or MCP configurations.

## VS Code Settings Integration

MCP servers are configured in `.vscode/settings.json`:

```json
{
  "mcp": {
    "servers": {
      "gemini-imagen": {
        "command": "npx",
        "args": ["-y", "@google/generative-ai-mcp-server"],
        "env": {
          "GOOGLE_API_KEY": "${env:GOOGLE_API_KEY}"
        }
      }
    }
  }
}
```

## Model Config in Entity Files

Scene entities reference MCP servers via `model_config` field:

### MCP Variant

```yaml
model_config:
  type: mcp
  server: gemini-imagen
  model: imagen-3.0-generate-001
  parameters:
    aspect_ratio: "1:1"
    quality: "high"
    safety_filter: "medium"
```

### Direct API Variant

```yaml
model_config:
  type: direct-api
  provider: google
  model: imagen-3.0-generate-001
  api_key_env: GOOGLE_API_KEY
  parameters:
    aspect_ratio: "1:1"
    quality: "high"
```

## Validation Rules

### VR-MCP-001: Server Name Format

- Server name must use kebab-case
- Only alphanumeric characters and hyphens
- Must be unique across all MCP servers

### VR-MCP-002: Command Executable

- Command must be a valid executable (npx, node, python, etc.)
- Args array must contain valid command-line arguments

### VR-MCP-003: Environment Variables

- All API keys must be referenced via `${env:VAR_NAME}`
- Environment variables must be defined in `.env` file
- Never store secrets directly in configuration

### VR-MCP-004: Model Config Type

- `model_config.type` must be either "mcp" or "direct-api"
- MCP type requires `server` field matching MCP server name
- Direct API type requires `provider` and `api_key_env` fields

## Quality Gates

### QG-MCP-001: API Key Security (critical)

- **Check**: No hard-coded API keys in any configuration file
- **Fix**: Move all API keys to `.env` file, reference via `${env:VAR_NAME}`
- **Why**: Prevents credential leakage in version control

### QG-MCP-002: Server Configuration Valid (critical)

- **Check**: MCP server configuration is syntactically correct JSON
- **Fix**: Validate JSON syntax, fix malformed configuration
- **Why**: Invalid configuration prevents MCP server startup

### QG-MCP-003: Model Name Consistency (warning)

- **Check**: Model name in entity `model_config` matches MCP server model
- **Fix**: Update model name to match server configuration
- **Why**: Mismatched models cause generation failures

### QG-MCP-004: Environment Variables Defined (warning)

- **Check**: All referenced env vars exist in `.env.example`
- **Fix**: Add missing variables to `.env.example` with placeholder values
- **Why**: Missing env vars cause runtime errors

## Example: Gemini Imagen Configuration

**VS Code Settings** (`.vscode/settings.json`):

```json
{
  "mcp": {
    "servers": {
      "gemini-imagen": {
        "command": "npx",
        "args": ["-y", "@google/generative-ai-mcp-server"],
        "env": {
          "GOOGLE_API_KEY": "${env:GOOGLE_API_KEY}",
          "MODEL_NAME": "imagen-3.0-generate-001"
        }
      }
    }
  }
}
```

**Scene Entity** (`hero-library-quest.md`):

```yaml
---
name: hero-library-quest
type: scene
# ... other fields ...
model_config:
  type: mcp
  server: gemini-imagen
  model: imagen-3.0-generate-001
  parameters:
    aspect_ratio: "1:1"
    quality: "high"
    safety_filter: "medium"
    prompt_enhancement: true
---
```

**Environment File** (`.env`):

```bash
GOOGLE_API_KEY=your_actual_api_key_here
GEMINI_IMAGE_MODEL=imagen-3.0-generate-001
```

## Usage Notes

MCP configuration enables Copilot to generate assets directly through VS Code by:

1. Reading scene entity with `model_config` field
2. Resolving MCP server from `model_config.server` name
3. Starting MCP server with configured environment
4. Sending generation request with scene narrative and parameters
5. Receiving generated image and metadata
6. Tracking image with DVC and creating metadata YAML

This template supports both MCP-based (integrated) and direct-api (standalone) workflows for flexibility.
