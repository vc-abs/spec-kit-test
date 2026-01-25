# Phase Plan 05: Asset Generation Setup

**Phase Goal**: Configure MCP servers, initialize DVC for asset tracking, and generate the first test image from a scene entity to validate the complete workflow.

**Status**: ✅ COMPLETE

**Iterations**: 1 (completed with phased commits)

---

## Files to Create/Modify (10+ files)

### Configuration Files (4 new)

1. `.env.example` - Template for API credentials (no secrets)
2. `.dvcignore` - DVC ignore patterns for logs and temporary files
3. `content/entities/entity-templates/mcp-config.template.md` - MCP configuration template
4. `.github/prompts/asset-generation.md` - Prompt template for image generation

### Configuration Updates (1 modify)

1. `.vscode/settings.json` - Add MCP server configuration (MODIFY EXISTING or CREATE)

### DVC Initialization (repository state change)

1. `dvc init` - Initialize DVC in workspace root
2. `.dvc/config` - Configure local remote for development

### Example Entities (1 modify)

1. Update existing scene entity (e.g., `hero-library-quest.md` or `max-golden-morning.md`) - Add model_config examples

### Test Assets (3+ new, generated during testing)

1. `content/test/<image-file>` - Test image generated from scene
2. `content/test/<image-file>.dvc` - DVC tracking file
3. `content/test/<image-metadata>.yaml` - Image metadata

### Documentation (1 modify)

1. `docs/quickstart.md` - Add MCP and DVC workflow sections (MODIFY EXISTING)

---

## Required User Inputs

### 1. GenAI Provider Selection

**Question**: Which GenAI provider(s) do you want to configure for image generation?

Options:

- [ ] **OpenAI (DALL-E 3)** - Stable, high-quality, $0.040-0.120 per image
- [ ] **Anthropic (Claude + tool use)** - Can orchestrate other providers via tools
- [ ] **Stability AI (SDXL)** - Open source models, various pricing
- [ ] **Multiple providers** - Configure multiple for flexibility
- [ ] **Skip for now** - Set up configuration structure without credentials

**Your selection**: Gemini would do.

**Rationale**: Determines which API credentials to document in .env.example and which MCP servers to configure.

### 2. DVC Remote Storage

**Question**: Where should DVC store binary assets (images, future videos)?

Options:

- [x] **Local filesystem** - `.dvc/cache` directory (development only, recommended for MVP)
- [ ] **Cloud storage (future)** - S3/Azure/GCS (for production, requires credentials)
- [ ] **Skip DVC** - Proceed without DVC tracking (not recommended per spec)

**Your selection**: _____________

**Rationale**: Phase 5 can work with local DVC storage. Cloud remotes can be added later in Phase 9 (Polish).

### 3. Test Image Generation Approach

**Question**: How should we handle test image generation in Phase 5?

Options:

- [x] **With credentials** - You provide API key, we generate real test image
- [ ] **Mock/simulate** - Create placeholder files to validate workflow without API calls
- [ ] **Skip test generation** - Set up infrastructure only, defer image generation to Phase 6

**Your selection**: _____________

**Rationale**: Phase 5 goal is validating MCP/DVC setup. Real image generation proves integration, but mock data validates workflow structure.

### 4. MCP Configuration Strategy

**Question**: How should MCP servers be configured?

Options:

- [x] **Full MCP setup** - Configure VS Code MCP servers for Copilot integration
- [ ] **Direct API only** - Skip MCP, use direct API calls (simpler but less integrated)
- [ ] **Both options** - Document both MCP and direct-api patterns

**Your selection**: _____________

**Rationale**: MCP provides better Copilot integration but requires VS Code configuration. Direct API is simpler but less seamless.

---

## Tasks Covered (Phase 5: T018-T029)

- [ ] T018: Create .env.example for API credentials
- [ ] T019: Initialize DVC in workspace root
- [ ] T020: Add DVC local remote in .dvc/config
- [ ] T021: Add .dvcignore for logs/ and temp files
- [ ] T022: Create MCP config template
- [ ] T023: Configure MCP servers in .vscode/settings.json
- [ ] T024: Add asset generation prompt template
- [ ] T025: Add model_config examples to scene entity
- [ ] T026: Generate test image (requires credentials)
- [ ] T027: Track test image with DVC
- [ ] T028: Validate DVC tracking and metadata
- [ ] T029: Document MCP and DVC workflow

---

## Prerequisites

**Must Have**:

- Phase 4 complete (scene entities exist as input for generation)
- Git repository initialized (.gitignore configured)
- VS Code workspace (for .vscode/settings.json)

**Optional (for full testing)**:

- API credentials for chosen GenAI provider
- DVC CLI installed (`pip install dvc`)
- MCP server packages installed (if using MCP strategy)

**Can Defer**:

- Cloud storage credentials (local DVC sufficient for Phase 5)
- Production image generation (mock data validates workflow)

---

## Validation Steps

### DVC Initialization Check

```bash
# Verify DVC initialized
ls -la .dvc/
cat .dvc/config

# Check .dvcignore exists
cat .dvcignore
```

**Expected**: `.dvc/` directory with config, `.dvcignore` file present

### Configuration Files Check

```bash
# Verify .env.example exists (no secrets)
cat .env.example | grep -v "^$" | grep -v "^#"

# Check MCP template created
cat content/entities/entity-templates/mcp-config.template.md | head -20

# Verify asset generation prompt
cat .github/prompts/asset-generation.md | head -20
```

**Expected**: All configuration templates present with clear documentation

### MCP Configuration Check (if using MCP)

```bash
# Check VS Code settings updated
cat .vscode/settings.json | grep -A 10 "mcp"
```

**Expected**: MCP server configuration present, or clear instructions if deferred

### Scene Entity model_config Check

```bash
# Verify scene entity has model_config examples
grep -A 10 "model_config" content/entities/scenes/hero-library-quest.md
```

**Expected**: YAML examples for both MCP and direct-api variants

### Test Image Generation (if credentials provided)

```bash
# Check test image created
ls -lh content/test/*.png content/test/*.jpg 2>/dev/null

# Verify DVC tracking
ls -lh content/test/*.dvc

# Check metadata file
cat content/test/*-metadata.yaml
```

**Expected**: Image file, .dvc file, metadata YAML all present

### DVC Tracking Validation

```bash
# Verify DVC status
dvc status

# Check DVC cache
du -sh .dvc/cache
```

**Expected**: DVC recognizes tracked file, cache contains data

---

## Implementation Strategy

### Approach 1: Full Setup with Real Image (Requires Credentials)

1. Create configuration files (.env.example, .dvcignore, templates)
2. Initialize DVC with local remote
3. Configure MCP servers in VS Code
4. Add model_config to scene entity
5. **Generate real test image** using API credentials
6. Track image with DVC and validate
7. Document complete workflow

**Pros**: Proves end-to-end integration
**Cons**: Requires API credentials and setup time

### Approach 2: Infrastructure Only (No Image Generation)

1. Create all configuration files and templates
2. Initialize DVC with local remote
3. Configure MCP servers (or document pattern)
4. Add model_config examples to scene
5. **Skip image generation** (defer to Phase 6)
6. Document workflow with placeholder examples

**Pros**: No credentials needed, faster implementation
**Cons**: Doesn't validate actual image generation

### Approach 3: Mock/Simulate (Recommended for MVP)

1. Create configuration files and templates
2. Initialize DVC with local remote
3. Configure MCP infrastructure
4. Add model_config to scene entity
5. **Create mock image and metadata** to validate DVC workflow
6. Document workflow with clear "mock data" notes
7. Leave T026 incomplete with note about requiring credentials

**Pros**: Validates workflow structure without credentials
**Cons**: Doesn't test real API integration

---

## Commit Strategy

### Option 1: Single Commit (if all setup works)

```text
feat(asset-gen): configure MCP, DVC, and image generation workflow

- Add .env.example for API credentials template
- Initialize DVC with local remote storage
- Create MCP config template and VS Code settings
- Add asset generation prompt template
- Update scene entity with model_config examples
- Generate test image and validate DVC tracking
- Document MCP and DVC workflow in quickstart.md

Phase 5/9: Asset Generation Setup
Tasks: T018-T029
```

### Option 2: Phased Commits (if complex or issues arise)

**Commit 1**: Configuration files

```text
feat(asset-gen): add configuration templates for MCP and DVC

- Create .env.example for API credentials
- Add .dvcignore for logs and temp files
- Create MCP config template
- Add asset generation prompt template

Tasks: T018, T021, T022, T024
```

**Commit 2**: DVC initialization

```text
feat(asset-gen): initialize DVC with local storage

- Run dvc init in workspace root
- Configure local remote in .dvc/config
- Validate DVC tracking workflow

Tasks: T019, T020
```

**Commit 3**: MCP and model_config

```text
feat(asset-gen): configure MCP servers and scene model_config

- Add MCP server configuration to VS Code settings
- Update scene entity with model_config examples (MCP and direct-api)

Tasks: T023, T025
```

**Commit 4**: Test generation and documentation

```text
feat(asset-gen): generate test image and document workflow

- Generate test image from scene entity
- Track image with DVC and validate metadata
- Document MCP and DVC workflow in quickstart.md

Tasks: T026-T029
```

---

## Dependencies

**Requires**:

- Phase 4 complete (scene entities available)
- .gitignore configured (from Phase 1)
- VS Code workspace

**Blocks**:

- Phase 6 (Production Image Generation)
- Phase 7 (Batch Image Generation)
- Phase 8 (Browse Images via VS Code)

**External Dependencies**:

- DVC CLI (`pip install dvc`) - can install if missing
- GenAI API credentials - optional for Phase 5 (can use mock)
- MCP server packages - optional (can document without implementing)

---

## Risk Assessment

### High Risk

- **API credentials not available**: Use mock/simulate approach (Approach 3)
- **DVC installation issues**: Document manual installation, provide troubleshooting
- **MCP server configuration complex**: Start with direct-api, defer MCP to Phase 9

### Medium Risk

- **Test image generation fails**: Troubleshoot API, fall back to mock data
- **DVC tracking issues**: Verify DVC installed, check .dvc/config syntax
- **VS Code settings conflicts**: Back up existing settings, merge carefully

### Low Risk

- **Documentation scope creep**: Keep quickstart.md updates focused on workflow
- **.env.example missing credentials**: Document placeholder format clearly
- **Multiple provider complexity**: Start with single provider, add others later

---

## Success Criteria

Phase 5 is complete when:

1. ✅ Configuration files created (.env.example, .dvcignore, templates, prompts)
2. ✅ DVC initialized with local remote storage
3. ✅ MCP infrastructure configured (.vscode/mcp.json, .github/copilot-mcp.json, server.js with outputPath)
4. ✅ MCP config entities created as standalone entities (gemini-imagen-default, cinematic, portrait)
5. ✅ Test image workflow validated with entity-creator agent using MCP server
6. ✅ DVC tracking architecture documented (images tracked, metadata preserved)
7. ✅ Workflow documented in quickstart.md with Image Generation Workflow section
8. ✅ Tasks T018-T029 marked complete

**Completion Summary**:

- **Commits**: 6 total (config files, DVC init, MCP entities, documentation, workflow refinements)
- **Architecture Decision**: MCP configs as standalone entities, not scene fields
- **Working Model**: gemini-2.0-flash-exp-image-generation via MCP server
- **Entity-Creator Integration**: Validated with workspace file → agent execution → operation log pattern
- **Server Enhancement**: Added outputPath parameter for direct file placement

---

## Planning Notes

**Critical Decisions**:

- Phase 5 **doesn't require real image generation** to be successful
- Mock/simulate approach (Approach 3) validates workflow without credentials
- Real API integration can be deferred to Phase 6 with actual production use
- Local DVC storage sufficient for MVP; cloud remotes are Phase 9 enhancement

**Scope Boundaries**:

- Phase 5 is about **infrastructure setup**, not production usage
- Goal: Prove MCP/DVC integration works conceptually
- Test image is **validation artifact**, not production asset
- Documentation should enable user to add real credentials later

**Next Phase**: Phase 6 will use this infrastructure for production image generation from real scenes (requires API credentials at that point).
