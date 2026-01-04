
<!--
Sync Impact Report
Version change: (none → 1.0.0)
List of modified principles: All placeholders filled (template → concrete)
Added sections: None
Removed sections: None
Templates requiring updates: None (all templates already generic and compatible)
Follow-up TODOs: TODO(RATIFICATION_DATE): Confirm if 2025-12-31 is correct for original ratification
-->

# ABS AI Scaffold Constitution


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


## Additional Constraints
Technology stack is limited to those supported by Copilot and documented in the README. No use of unsupported agents, editors, or proprietary formats. All dependencies must be open source and compatible with project license.


## Development Workflow
All code changes require review for principle compliance. Tests and documentation are mandatory for all features. Deployment and release processes must be documented and repeatable. Quality gates include passing all tests, constitution check, and reviewer approval.


## Governance
This constitution supersedes all other practices. Amendments require documentation, approval by project maintainers, and a migration plan for any breaking changes. All PRs and reviews must verify compliance with these principles. Complexity must be justified in the plan. Use README and runtime guidance for development reference.

**Version**: 1.0.0 | **Ratified**: TODO(RATIFICATION_DATE): Confirm if 2025-12-31 is correct for original ratification | **Last Amended**: 2025-12-31
