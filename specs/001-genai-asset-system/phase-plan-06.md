# Phase Plan 06: Production Image Generation

**Phase Goal**: Generate production-ready images from scene entities using the entity-creator agent with full metadata and DVC tracking.

**Status**: ✅ COMPLETE

**Iterations**: 1

---

## Overview

Phase 6 builds on Phase 5's infrastructure to generate actual production images. This phase validates the complete workflow: entity-creator agent → scene resolution → prompt construction → MCP invocation → image generation → metadata creation → DVC tracking.

**Key Difference from Phase 5**: Phase 5 was infrastructure setup and testing. Phase 6 focuses on production usage with proper entity-creator agent workflows and complete documentation.

---

## Files to Create/Modify (4-6 files)

### Production Images (generated)

1. `content/images/<scene-name>-<timestamp>.png` - Production image from scene entity
2. `content/images/<scene-name>-<timestamp>-metadata.yaml` - Image metadata with generation params
3. `content/images/<scene-name>-<timestamp>.png.dvc` - DVC tracking file

### Workspace Files (entity-creator workflow)

1. `content/.workspace/generate-<scene>-<operation-id>-workspace.md` - Workspace file for each generation
2. `logs/generate-<scene>-<operation-id>-operation.log` - Operation log in YAML format

### Documentation (1 modify)

1. `docs/quickstart.md` - Update Image Generation Workflow section with production examples

---

## Tasks

### T030: Generate Image from Scene Entity

**Goal**: Use entity-creator agent to generate a production image from an existing scene entity.

**Steps**:

1. Select a scene entity (e.g., `hero-library-quest` or `max-golden-morning`)
2. Create workspace file documenting the generation plan
3. Invoke entity-creator agent to execute workflow
4. Verify image saved to `content/images/`
5. Verify metadata YAML created with kebab-case attributes

**Acceptance Criteria**:

- Image file: `content/images/<scene>-<timestamp>.png`
- Metadata file: `content/images/<scene>-<timestamp>-metadata.yaml`
- Operation log: `logs/generate-<scene>-<operation-id>-operation.log`
- All files follow naming conventions

### T031: Validate Image Naming and DVC Tracking

**Goal**: Ensure images follow naming patterns and are properly tracked with DVC.

**Steps**:

1. Verify image filename format: `<scene-name>-<timestamp>.png`
2. Run `dvc add content/images/<image>.png`
3. Verify `.dvc` file created
4. Check `.gitignore` patterns (images ignored, .dvc files tracked)
5. Test `dvc pull` retrieves image

**Acceptance Criteria**:

- Image naming follows `<scene>-<timestamp>.png` pattern
- DVC tracking file created successfully
- `.gitignore` properly configured
- DVC pull/push workflow functional

### T032: Validate Image Metadata

**Goal**: Ensure metadata YAML includes all required generation parameters and references.

**Steps**:

1. Read generated metadata YAML
2. Verify required fields: `generated-at`, `source-scene`, `entities`, `generation-params`
3. Verify kebab-case attribute names
4. Verify entity references include name and version
5. Verify prompt strategy documented

**Acceptance Criteria**:

- Metadata includes scene reference
- All generation params in kebab-case
- Entity dependencies listed with versions
- File paths and sizes recorded

### T033: Document Production Workflow

**Goal**: Update quickstart.md with production image generation examples.

**Steps**:

1. Add section: "Production Image Generation"
2. Document entity-creator agent invocation pattern
3. Include example workspace file structure
4. Document DVC tracking workflow
5. Add troubleshooting section

**Acceptance Criteria**:

- Clear production workflow documentation
- Example commands and expected outputs
- DVC workflow explained
- Common issues addressed

---

## Validation Commands

### Image Generation Check

```bash
# List generated images
ls -lh content/images/*.png

# Check metadata files
ls -lh content/images/*-metadata.yaml

# Verify DVC tracking
ls -lh content/images/*.dvc
```

**Expected**: Images, metadata, and .dvc files all present in `content/images/`

### Metadata Validation

```bash
# Check metadata structure
cat content/images/<image>-metadata.yaml

# Verify kebab-case attributes
grep -E "(aspect-ratio|safety-filter|prompt-enhancement)" content/images/<image>-metadata.yaml
```

**Expected**: All attributes in kebab-case, scene reference present

### DVC Tracking Validation

```bash
# Check DVC status
dvc status

# Verify cache
ls -lh .dvc/cache/files/md5/

# Test pull
dvc pull content/images/<image>.png.dvc
```

**Expected**: DVC tracking functional, files in cache

---

## Success Criteria

Phase 6 is complete when:

1. ✅ Production image generated from scene entity using entity-creator agent
2. ✅ Image naming follows `<scene>-<timestamp>.png` pattern
3. ✅ DVC tracking configured and functional
4. ✅ Metadata YAML includes scene reference and generation params (kebab-case)
5. ✅ Operation logs created in YAML format
6. ✅ Documentation updated in quickstart.md
7. ✅ Tasks T030-T033 marked complete

---

## Dependencies

- **Phase 5**: MCP server, DVC init, mcp-config entities
- **Phase 4**: Scene entities to generate images from
- **Phase 3**: Entity templates for validation
- **API Credentials**: GOOGLE_API_KEY in .env file

---

## Notes

- Use existing scenes from Phase 4 (hero-library-quest, max-golden-morning)
- Save production images to `content/images/` (not `content/test/`)
- Follow entity-creator workflow: workspace file → user approval → execute → log
- DVC tracking is required for production images
- Metadata must reference source scene and resolved entities
