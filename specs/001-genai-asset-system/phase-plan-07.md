# Phase Plan 07: Batch Image Generation

**Phase Goal**: Generate multiple image variations in sequence (up to 5 per batch) using entity-creator agent with different scene entities, each tracked and versioned.

**Status**: ✅ COMPLETE

**Iterations**: 1

---

## Overview

Phase 7 extends single image generation to batch processing. This enables generating multiple images from different scenes in a single workflow, with proper DVC tracking and metadata for each output.

**Key Capabilities**:

- Generate 3-5 images in sequence
- Each image tracked independently with DVC
- Batch operation log documenting all generations
- Support for different scenes or parameter variations

---

## Files to Create/Modify

### Prompt Templates (1 new)

1. `.github/prompts/batch-generation.md` - Batch generation workflow template

### Generated Assets (per batch)

1. `content/images/<scene-1>-<timestamp>.png` + metadata + .dvc
2. `content/images/<scene-2>-<timestamp>.png` + metadata + .dvc
3. `content/images/<scene-3>-<timestamp>.png` + metadata + .dvc

### Workspace Files (1 per batch)

1. `content/.workspace/batch-generate-<batch-id>-workspace.md` - Batch plan
2. `logs/batch-generate-<batch-id>-operation.log` - Batch operation log

### Documentation (1 modify)

1. `docs/quickstart.md` - Add Batch Generation section

---

## Tasks

### T034: Add Batch Generation Prompt Template

**Goal**: Create prompt template for batch image generation workflows.

**Steps**:

1. Create `.github/prompts/batch-generation.md`
2. Document batch workflow: scene selection → sequential generation → DVC tracking
3. Include examples for 3-image and 5-image batches
4. Define batch operation log format

**Acceptance Criteria**:

- Template includes batch workflow steps
- Examples for different batch sizes
- Operation log format specified

### T035: Generate Batch of Images

**Goal**: Generate 3 images from different scene entities in a single batch operation.

**Steps**:

1. Select 3 scenes (e.g., hero-library-quest, max-golden-morning, park-morning)
2. Create batch workspace file
3. Invoke entity-creator to generate all 3 images
4. Verify all images saved to content/images/
5. Verify metadata created for each

**Acceptance Criteria**:

- 3 images generated successfully
- Each has .dvc tracking file
- Each has metadata YAML
- Batch operation log created

### T036: Validate Batch Naming and DVC

**Goal**: Ensure batch-generated images follow naming conventions and DVC tracking.

**Steps**:

1. Verify all images use `<scene>-<timestamp>.png` format
2. Verify unique timestamps for each image
3. Check all .dvc files committed to git
4. Test DVC pull for batch

**Acceptance Criteria**:

- All images properly named
- No filename collisions
- DVC tracking functional for all
- .gitignore patterns correct

### T037: Validate Batch Commit Format

**Goal**: Ensure batch operations produce clear, structured commit messages.

**Steps**:

1. Review batch operation log
2. Verify log includes all generated assets
3. Check commit message format
4. Validate git status clean

**Acceptance Criteria**:

- Operation log lists all 3 images
- Commit message references batch operation
- All files properly staged

### T038: Document Batch Workflow

**Goal**: Update quickstart.md with batch generation examples.

**Steps**:

1. Add "Batch Image Generation" section
2. Document batch workflow
3. Include 3-image example
4. Add troubleshooting for batch operations

**Acceptance Criteria**:

- Clear batch workflow documentation
- Example batch invocation
- Troubleshooting section

---

## Validation Commands

### Batch Generation Check

```bash
# List all generated images
ls -lh content/images/*.png

# Count images
ls -1 content/images/*.png | wc -l
```

**Expected**: 3 PNG files in content/images/

### DVC Batch Tracking

```bash
# Check all .dvc files
ls -lh content/images/*.dvc

# Verify DVC status
dvc status
```

**Expected**: 3 .dvc files, DVC status clean

### Batch Operation Log

```bash
# View batch log
cat logs/batch-generate-*-operation.log
```

**Expected**: Log lists all 3 images with validation results

---

## Success Criteria

Phase 7 is complete when:

1. ✅ Batch generation prompt template created
2. ✅ 3 images generated from different scenes
3. ✅ All images have proper naming and DVC tracking
4. ✅ Batch operation log documents all generations
5. ✅ Batch workflow documented in quickstart.md
6. ✅ Tasks T034-T038 marked complete

---

## Notes

- Use existing scenes: hero-library-quest, max-golden-morning, park-morning
- Each image gets unique timestamp
- Batch operation log aggregates all validation results
- Sequential generation (not parallel) to avoid API rate limits
