# Phased Implementation Pattern

**Purpose**: Break large implementations into reviewable, committable phases with interactive checkpoints.

## Problem

Large implementations that create 20+ files in a single commit are:

- Unmanageable for code review
- Risk losing work if errors occur mid-implementation
- Prevent incremental validation and feedback
- Make rollback difficult

## Solution: Phase Planning Files

Before starting each implementation phase, create a `phase-plan-NN.md` file **in the feature directory** (e.g., `specs/<feature-id>/phase-plan-01.md`) that specifies:

1. **Phase Goal**: What this phase accomplishes
2. **Files to Create/Modify**: Exact list with brief descriptions
3. **Required Inputs**: Parameters, credentials, decisions needed from user (ALL questions must be documented in the phase plan file itself, not asked separately in chat)
4. **Validation Steps**: How to verify phase completion
5. **Commit Strategy**: Suggested commit message(s)
6. **Next Phase**: What comes after (optional)

**Location**: Phase plans are stored in the feature directory alongside tasks.md, plan.md, and other spec files. This keeps all feature-related artifacts together and organized.

**Critical**: All user input questions MUST be written directly in the phase plan file under "Required User Inputs" section. Do not ask questions in chat - document them in the phase plan so users can review, answer, and track all inputs in one place.

## Workflow

### Step 1: Agent Creates Phase Plan

Agent analyzes tasks and creates `phase-plan-NN.md`:

```markdown
# Phase Plan: Foundation Setup

## Phase Goal
Create directory structure, bootstrap meta-template, and entity-creator agent.

## Files to Create (5)
1. `entities/entity-template/entity-template.template.md` - Bootstrap meta-template
2. `.github/agents/entity-creator.agent.md` - Entity creation workflow
3. `.env.example` - API credential template
4. `.gitignore` - Add GenAI-specific ignores
5. `README.md` - Update with system overview (MODIFY EXISTING)

## Required Inputs
- [ ] Confirm directory structure: `entities/{character,style,environment,scene,entity-template}`?
- [ ] Confirm GenAI providers: OpenAI (DALL-E), Stability AI, Anthropic?
- [ ] Default image resolution: `1024x1024` or `1792x1024`?

## Validation Steps
- [ ] Run `tree entities/` to verify structure
- [ ] Verify `.gitignore` excludes `.env` and `logs/*.log`
- [ ] Check README.md includes GenAI Asset System section

## Commit Message
```

feat(foundation): add entity templates and creator agent

- Create entity-template meta-template bootstrap
- Add entity-creator agent workflow
- Configure .env.example with API credentials
- Update .gitignore for GenAI assets
- Document system overview in README.md

```

## Next Phase
Phase 2: Entity Type Templates (character, style, environment, scene)
```

### Step 2: User Reviews & Provides Inputs

User reviews plan and:

- Answers required input questions by editing the phase plan file
- Asks for clarifications or changes
- Approves by saying "continue" or "proceed with Phase 1"

### Step 3: Agent Implements Phase

Agent:

- Reads user's answers from updated phase plan
- Creates/modifies exactly the files listed
- Runs validation steps
- Reports completion

### Step 4: User Commits

User reviews changes and commits:

```bash
git add entities/ .github/ .env.example .gitignore README.md
git commit -m "feat(foundation): add entity templates and creator agent"
```

### Step 5: Repeat for Next Phase

Agent creates `phase-plan-02.md` for next phase, cycle repeats.

### Step 6: Implementation Iterations (Refinement Cycles)

Complex phases often require multiple iterations before testing:

**Iteration Pattern**:

1. **Initial Implementation**: Agent creates files based on requirements
2. **User Review**: User examines output, identifies issues or improvements needed
3. **Iteration N**: Agent refines based on feedback
4. **Repeat**: Continue until user approves for testing

**Each Iteration Documents**:

- Status (🚧 IN PROGRESS / ✅ COMPLETE)
- Issues identified from previous iteration
- Changes made in this iteration
- Implementation tasks completed
- Summary of outcomes
- User feedback received

**Example**: Phase 2 had 4 implementation iterations addressing:

- Iteration 1: Initial design with issues identified
- Iteration 2: Complete architectural redesign (template-anchored → input-agnostic)
- Iteration 3: Refinements (update operations, remove auto-commit, clarify workspace scope)
- Iteration 4: Workspace and logging improvements (single workspace per operation, batch types)

### Step 7: Testing Iterations (When Applicable)

For phases involving agent workflows or complex logic:

1. **Testing Iterations** (5+): Execute validation tests to verify behavior
2. **Fix Iterations**: When tests reveal issues, create new iteration to apply fixes

Testing iteration workflow:

- Create tests in phase plan (documentation validation + execution validation)
- Execute tests one at a time with manual verification
- If test fails: Create fix iteration → Apply fixes → Clean artifacts → Retry test
- Document all test results with detailed execution logs
- Mark iteration as SUCCESS when all tests pass

## Testing Phases

### When to Include Testing

Phases that create agents, workflows, or complex logic should include:

1. **Documentation Validation**: Verify files exist, structure correct, no syntax errors
2. **Execution Validation**: Test actual behavior with real scenarios

### Test Execution Approach

**Recommended**: Manual execution one test at a time

- More reliable than automated scripts
- Allows verification of each checkpoint
- Easier to debug failures
- Better for interactive agent testing

**Test Execution Guidelines**:

1. **Execute One Test at a Time**: Complete current test, document results, get user feedback before proceeding
2. **Verify Against Checklist**: Check all verification items for each test
3. **Document Findings**: Update execution log and test result (✅ PASSED / ❌ FAILED + details)
4. **Progress Incrementally**: Wait for user approval after each test
5. **Track Progress**: Maintain test summary (e.g., "Completed: 3/6, Passed: 2, Failed: 1")

**Example Test Progression**:

```text
Test 0: Bootstrap prerequisite (e.g., create template using meta-template)
Test 1: Simple operation (baseline functionality - create single entity)
Test 2: Dependency handling (entity relationships, resolution options)
Test 3: Batch operations (multiple entities in one operation)
Test 4: Update operations (version increments, operation_type: "update")
Test 5: Error handling (conflict detection, abort with clear message)
```

### Iterative Testing Pattern

When tests reveal issues:

1. **Identify Issue**: Document what went wrong and why
2. **Create Fix Iteration**: Add new iteration section to phase plan
3. **Apply Fixes**: Make targeted changes to resolve root cause
4. **Clean Artifacts**: Delete test outputs from failed attempt
5. **Retry Test**: Re-run same test cleanly
6. **Verify Success**: Confirm all aspects now work correctly
7. **Document**: Update phase plan with iteration results
8. **Proceed**: Move to next test

**Example**: Phase 2 discovered workspace files not persisting to disk (Iteration 7 created to emphasize "MUST be written to disk and persisted").

### Workflow Enforcement

For agent-based workflows, add **MANDATORY WORKFLOW REQUIREMENTS** section:

```markdown
## ⚠️ MANDATORY WORKFLOW REQUIREMENTS

1. ✅ ALWAYS create workspace file
   - MUST be written to disk and persisted (not just in-memory)
   - NO conditional logic: Create regardless of operation complexity

2. ✅ ALWAYS wait for user 'continue' before creating outputs
   - User checkpoint for review and approval

3. ✅ ALWAYS create operation log
   - MUST be written to disk and persisted
   - Include operation_type, entities_created, status

4. ✅ NEVER auto-commit changes
   - User controls all git operations
```

This ensures agents don't skip critical steps even when operations seem "simple".

## Phase Sizing Guidelines

**Ideal phase size**: 3-8 files per phase, targeting ~300-800 lines total

**Phase boundaries**:

- Natural architectural layers (setup → templates → examples → workflows)
- Functional milestones (can be tested independently)
- Logical commit units (single feature or component)

**Too small**: Creating 1-2 files per phase (overhead > benefit)
**Too large**: 15+ files or 1500+ lines (review burden)

## Phase Status Lifecycle

Phases progress through distinct status states:

1. **🚧 IN PROGRESS** - Implementation iterations (1-4), refining based on user feedback
2. **🧪 TESTING** - Execution validation with test scenarios (iterations 5+)
3. **✅ COMPLETE** - All tests passed, ready for commit

**Status transitions** happen when:

- 🚧 → 🧪: User approves implementation, begins testing phase
- 🧪 → 🚧: Test failure requires returning to implementation fixes
- 🧪 → ✅: All tests pass, validation complete

## Phase Plan Template

```markdown
# Phase Plan: [Phase Name]

## Phase Goal
[One sentence describing what this phase accomplishes]

## Status
[Current state: 🚧 IN PROGRESS / 🧪 TESTING / ✅ COMPLETE]

## Iterations
[Count and type: e.g., "7 (4 implementation, 3 testing)"]

## Files to Create/Modify ([count])
1. `path/to/file.ext` - Brief description (CREATE NEW / MODIFY EXISTING)
2. ...

## Required Inputs
- [ ] Question 1 about configuration?
  - User answer: ___
- [ ] Question 2 about dependencies?
  - User answer: ___

## Validation Steps

### Documentation Validation
- [ ] Files exist with correct structure
- [ ] No syntax errors
- [ ] All required sections present

### Execution Validation (if applicable)
Test scenarios for agent/workflow behavior:
- [ ] Test 0: [Bootstrap or prerequisite]
- [ ] Test 1: [Simple baseline operation]
- [ ] Test 2: [Dependency handling]
- [ ] Test 3: [Batch operations]
- [ ] Test 4: [Update operations]
- [ ] Test 5: [Error handling]

## Commit Message
```

type(scope): brief description

- Bullet point change 1
- Bullet point change 2

```

## Dependencies
- Requires: [Previous phase name or prerequisite]
- Blocks: [Next phase name]

## Next Phase
[Brief description of what comes after]

---

## Iteration Log

### Iteration 1: [Brief description]
**Changes**: List of changes made
**Result**: SUCCESS / NEEDS_REVISION
**User Feedback**: [Quote or summary]

### Iteration N (Testing): [Test name]
**Test Execution**: [Date/time]
**Result**: ✅ PASSED / ❌ FAILED
**Details**: [Execution log with verification steps]
```

## Integration with speckit.implement

When running `/speckit.implement`, the agent should:

1. **Analyze task count**: If >15 tasks, create phased plan
2. **Group tasks into phases**:
   - Phase 1: Setup (T001-T007)
   - Phase 2: Templates (T008-T014)
   - Phase 3: Examples (T015-T021)
   - etc.
3. **Create phase plan for Phase 1**: Write `phase-plan-01.md`
4. **Wait for user input**: Halt and ask user to review/approve
5. **Execute Phase 1**: After user approval
6. **Repeat**: Create `phase-plan-02.md` and wait for approval

## Interactive Prompts

**When creating phase plan**:

```
Created phase-plan-01.md with 5 files for Foundation Setup.
Please review and answer the 3 required input questions.
Reply "continue" when ready to proceed.
```

**After phase completion**:

```
Phase 1 complete: 5 files created
Run validation steps in phase-plan-01.md, then commit:
  git add <files>
  git commit -m "feat(foundation): ..."

Reply "next phase" to create phase-plan-02.md
```

## Session Persistence

Phase plans are markdown files in the repository, so they persist across Copilot sessions:

- **Resume mid-phase**: "Continue with phase-plan-03.md"
- **Review previous phase**: "Show what was done in phase-plan-02.md"
- **Restart from checkpoint**: "Re-execute phase-plan-01.md"

## Benefits

1. **Reviewable increments**: Each phase is small enough to review thoroughly
2. **Testable checkpoints**: Validate before moving forward
3. **Rollback safety**: Can revert single phase without losing all work
4. **Clear progress tracking**: Phase plans show what's done vs pending
5. **Interactive collaboration**: User guides implementation with inputs
6. **Session-independent**: Phase plans survive Copilot session restarts
7. **Iterative refinement**: Testing iterations catch issues early
8. **Quality assurance**: Execution validation ensures agents work correctly
9. **Audit trail**: Detailed iteration logs document all decisions and fixes

## Example: Multi-Phase Implementation

```
phase-plan-01.md → Phase 1: Setup (T001-T007)
                   User reviews → commits → says "next"

phase-plan-02.md → Phase 2: Templates (T008-T014)
                   User reviews → commits → says "next"

phase-plan-03.md → Phase 3: Examples (T015-T021)
                   User reviews → commits → done
```

Total: 21 tasks across 3 phases with 3 commits instead of 1 massive commit.
