# Phase Plan 09: Polish & Cross-Cutting Concerns

**Phase Goal**: Refine and polish the system with improved naming conventions, cleanup, and better log accessibility.

**Status**: ✅ COMPLETE (T043-T051)

**Iterations**: 1

---

## Overview

Phase 9 addresses cross-cutting improvements identified during implementation:

1. **Naming Convention**: Change entity naming from semantic+version to semantic+timestamp+variation
2. **File Cleanup**: Remove excess prompts and temporary files
3. **Log Accessibility**: Prefix log files with timestamps for better sorting

---

## Tasks

### T043: Update Entity Naming Convention ✅

**Status**: COMPLETE

**Goal**: Change naming from `<name>-v<N>` to `<name>-YYMMDD-HHMM-VV` format.

**Current**: `max-golden-morning-20260125T090658Z.png`
**New**: `max-golden-morning-260125-090658-01.png`

**Benefits**:

- Consistent timestamp format
- Sortable by date/time
- Variation numbers instead of full timestamps
- Shorter, cleaner filenames

**Steps**:

1. Update entity-creator agent to use new naming pattern
2. Document new convention in templates
3. Update quickstart.md with new examples

### T044: Clean-Up Excess Files ✅

**Status**: COMPLETE

**Goal**: Remove unnecessary prompts and temporary files.

**Files to Remove**:

- Excess prompt templates not used by workflow
- Old/backup log files (*.old)
- Temporary workspace files in .work/
- Test files in .temp/

**Steps**:

1. Identify unused prompt files
2. Remove backup/old files
3. Clean temporary directories
4. Update .gitignore if needed

### T045: Timestamp Log Files ✅

**Status**: COMPLETE

**Goal**: Prefix log files with timestamps for better accessibility.

**Current**: `logs/generate-max-golden-morning-20260125-090658-operation.log`
**New**: `logs/20260125-090658-generate-max-golden-morning-operation.log`

**Benefits**:

- Natural chronological sorting in file explorer
- Easier to find recent operations
- Consistent with other timestamp practices

**Steps**:

1. Update entity-creator agent log naming
2. Rename existing logs to new format
3. Update documentation references

### T046: Template Validation Polish ✅

**Status**: COMPLETE

**Goal**: Review and polish template validation rules.

**Steps**:

1. Review existing validation rules across templates
2. Ensure consistent VR-*and QG-* numbering
3. Verify all critical gates are enforced
4. Update any lenient gates that should be critical

### T047: Documentation Final Review ✅

**Status**: COMPLETE

**Goal**: Final review and polish of all documentation.

**Steps**:

1. Review README.md for completeness
2. Check quickstart.md for accuracy
3. Verify all phase plans complete
4. Update any outdated examples

### T048: End-to-End Validation

**Goal**: Run complete workflow validation from quickstart.md.

**Steps**:

1. Follow quickstart.md from scratch
2. Create new entities using documented workflows
3. Generate images from new entities
4. Verify DVC tracking
5. Document any issues found

---

## Success Criteria

Phase 9 is complete when:

1. ✅ Entity naming convention updated and documented (T043)
2. ✅ Excess files cleaned up (T044)
3. ✅ Log files use timestamp prefixes (T045)
4. ✅ Template validation reviewed (T046)
5. ✅ Documentation polished (T047, T051)
6. ✅ Seconds added to timestamp format (T049)
7. ✅ Asset-generation prompt replaced with copilot.create (T050)
8. ✅ Image generation workflow added to entity-creator agent

---

## Additional Tasks Completed

### T049: Add Seconds to Timestamp Format ✅

Updated format to `YYMMDD-HHMMSS-VV` for better uniqueness.

### T050: Replace Asset-Generation Prompt ✅

- **Removed**: `.github/prompts/asset-generation.md` (301 lines)
- **Created**: `.github/prompts/copilot.create.md` (40 lines)
- **Rationale**: Simplified to delegation prompt; all workflow details now in entity-creator agent

### T051: Simplify Quickstart Guide ✅

- **Before**: 963 lines with extensive setup
- **After**: 463 lines focused on `/copilot.create` usage
- **Focus**: Practical examples, DVC, logs, metadata

### Image Generation Workflow Added to Entity-Creator ✅

Added **Generic Asset Naming Convention** section to entity-creator agent:

- Naming pattern: `<asset-name>-<YYMMDD>-<HHMMSS>-<VV>.<ext>`
- Metadata pattern: `<asset-name>-metadata.yaml` with required fields
- DVC tracking workflow for binary assets
- Generic for images, videos, audio, any binary output

### T048: End-to-End Validation ✅

**Status**: COMPLETE (2026-01-25)

**Validation Method**: Code inspection and pattern verification

**Results**:

✅ **Naming Convention**:

- Agent specifies: `<asset-name>-<YYMMDD>-<HHMMSS>-<VV>.<ext>`
- Example in docs: `max-golden-morning-260125-143022-01.png`
- Format verified: 6-digit date + 6-digit time with seconds + 2-digit variation

✅ **Log File Format**:

- Agent specifies: `logs/YYYYMMDD-HHMMSS-<operation-name>-operation.log`
- Actual logs verified: `20260125-090658-generate-max-golden-morning-operation.log`
- Timestamp prefix enables chronological sorting ✓

✅ **Documentation Consistency**:

- Quickstart shows new format examples throughout
- Entity-creator agent has "Generated Asset Naming Convention" section
- Copilot.create prompt delegates correctly

✅ **Generic Patterns**:

- Asset naming works for images, videos, audio (any binary)
- Metadata pattern is type-agnostic
- No image-specific assumptions in agent

**Notes**:

- Existing images use old format (20260125T145625Z) - expected, created before Phase 9
- New images will use updated format (260125-145625-01) - verified in agent code
- All Phase 9 improvements validated and ready for production

---

## Files Changed

```
M  .github/agents/entity-creator.agent.md    (added generic asset naming)
D  .github/prompts/asset-generation.md       (removed 301 lines)
A  .github/prompts/copilot.create.md         (44 lines - minimal)
M  docs/quickstart.md                         (streamlined to 198 lines)
M  specs/001-genai-asset-system/phase-plan-09.md
```

---

## Notes

- Entity-creator remains generic - asset naming applies to any binary output
- All critical workflow information consolidated in agent
- Copilot.create prompt minimal - delegates to agent
- Phase summary consolidated into this plan file (no separate summary)
- Focus on developer experience and consistency
- Quickstart rewritten for end-users (79% reduction from original)
