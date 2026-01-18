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
3. **Required Inputs**: Parameters, credentials, decisions needed from user
4. **Validation Steps**: How to verify phase completion
5. **Commit Strategy**: Suggested commit message(s)
6. **Next Phase**: What comes after (optional)

**Location**: Phase plans are stored in the feature directory alongside tasks.md, plan.md, and other spec files. This keeps all feature-related artifacts together and organized.

## Workflow

### Step 1: Agent Creates Phase Plan

Agent analyzes tasks and creates `.phase-plan.md`:

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

## Phase Sizing Guidelines

**Ideal phase size**: 3-8 files per phase, targeting ~300-800 lines total

**Phase boundaries**:

- Natural architectural layers (setup → templates → examples → workflows)
- Functional milestones (can be tested independently)
- Logical commit units (single feature or component)

**Too small**: Creating 1-2 files per phase (overhead > benefit)
**Too large**: 15+ files or 1500+ lines (review burden)

## Phase Plan Template

```markdown
# Phase Plan: [Phase Name]

## Phase Goal
[One sentence describing what this phase accomplishes]

## Files to Create/Modify ([count])
1. `path/to/file.ext` - Brief description (CREATE NEW / MODIFY EXISTING)
2. ...

## Required Inputs
- [ ] Question 1 about configuration?
  - User answer: ___
- [ ] Question 2 about dependencies?
  - User answer: ___

## Validation Steps
- [ ] Command or check to verify completion
- [ ] Another validation step

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
