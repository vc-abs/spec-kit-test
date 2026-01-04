
<!--
Sync Impact Report
Version change: 1.0.0 → 1.1.0
List of modified principles:
  - Updated project name: ABS AI Scaffold → GenAI Asset Generator
  - Added Principle VI: Content Quality and Asset Management
  - Specified DVC for binary asset version control in Principle VI
  - Expanded Additional Constraints with GenAI-specific requirements (including DVC)
  - Enhanced Development Workflow with content generation and DVC integration
  - Added versioning guidance to Governance: versions increment only on commit
Added sections: Content Quality and Asset Management principle
Removed sections: None
Templates requiring updates:
  ✅ plan-template.md - reviewed, generic structure applies
  ✅ spec-template.md - reviewed, generic structure applies
  ✅ tasks-template.md - reviewed, generic structure applies
Follow-up TODOs:
  - Confirm original ratification date (currently marked as 2025-12-31)
  - Update README.md with project-specific description of GenAI asset generation workflow
  - Ensure DVC is initialized, configured, and documented in project setup
  - Configure DVC remote storage and document in README
  - Verify .gitignore excludes binary assets tracked by DVC
-->

# GenAI Asset Generator Constitution


## Core Principles

### I. Copilot-First Enablement
Every feature, workflow, and prompt MUST be designed for seamless GitHub Copilot integration. All code, documentation, and automation must be accessible, testable, and maintainable via Copilot's context model. No feature may require tools or agents not supported by Copilot.
*Rationale: Ensures consistent developer experience and avoids scope creep from unsupported tools.*

### II. Test-Driven Development (NON-NEGOTIABLE)
All new features and bugfixes MUST be developed using TDD. Tests are written and approved before implementation. Red-Green-Refactor cycle is strictly enforced. No code is merged without passing tests and clear test coverage.
*Rationale: Guarantees reliability, maintainability, and user trust in all deliverables.*

### III. CLI and Text Protocols
All libraries and features MUST expose functionality via a CLI interface. Input/output must use plain text or JSON over stdin/stdout, with errors to stderr. Human-readable and machine-readable formats are both required.
*Rationale: Maximizes composability, debuggability, and automation.*

### IV. Simplicity and Minimalism
Features and libraries MUST be as simple as possible. Avoid unnecessary abstractions, dependencies, or configuration. YAGNI (You Aren't Gonna Need It) is enforced. Complexity must be justified in the plan and reviewed.
*Rationale: Reduces maintenance burden and onboarding time.*

### V. Observability and Versioning
All outputs must be debuggable via structured logs or text. Versioning follows MAJOR.MINOR.PATCH. Breaking changes require a major version bump and migration plan.
*Rationale: Ensures traceability, safe upgrades, and operational confidence.*

### VI. Content Quality and Asset Management
All generated assets (images, videos, prompts) MUST be versioned, tracked, and organized in content directories with clear naming conventions. Binary assets (images, videos) MUST be version-controlled using DVC (Data Version Control), not git. Text-based artifacts (prompts, metadata) are tracked in git. Asset generation workflows MUST be reproducible with documented prompts, model versions, and parameters. Quality validation gates MUST verify asset integrity, format compliance, and metadata completeness before assets are committed.
*Rationale: Ensures auditability, reproducibility, and quality standards for GenAI-generated content while keeping git repository lightweight.*


## Additional Constraints
Technology stack is limited to those supported by Copilot and documented in the README. No use of unsupported agents, editors, or proprietary formats. All dependencies must be open source and compatible with project license.

GenAI-specific requirements:
- All GenAI model interactions MUST log prompts, parameters, and model versions
- Binary assets (images, videos) MUST be version-controlled via DVC
- Asset outputs MUST include metadata files (text-based, in git) documenting generation parameters
- Content directories MUST maintain organizational structure: prompts/, cards/, insta-prompts/
- Prompt templates MUST be version-controlled in git and reviewed for quality
- DVC configuration and remote storage MUST be documented in project setup


## Development Workflow
All code changes require review for principle compliance. Tests and documentation are mandatory for all features. Deployment and release processes must be documented and repeatable. Quality gates include passing all tests, constitution check, and reviewer approval.

Content generation workflow:
- Prompt templates reviewed before asset generation
- Generated assets validated for quality and format compliance
- Binary assets tracked via DVC; metadata files tracked via git
- Asset metadata captured and version-controlled alongside outputs
- DVC push/pull operations integrated into asset deployment workflow


## Governance
This constitution supersedes all other practices. Amendments require documentation, approval by project maintainers, and a migration plan for any breaking changes. All PRs and reviews must verify compliance with these principles. Complexity must be justified in the plan. Use README and runtime guidance for development reference.

**Versioning Policy**: All versioned content (constitution, specs, plans, generated assets, documentation) follows semantic versioning (MAJOR.MINOR.PATCH). Version increments occur only upon commit/merge, not during iterative refinement of uncommitted changes. Multiple related amendments in a single work session share the same version number until committed. This prevents version proliferation and maintains clear version history aligned with git commits.

**Version**: 1.1.0 | **Ratified**: 2025-12-31 | **Last Amended**: 2026-01-04
