---
kind: action-skill
id: al-code-review
version: 1
title: AL code review
description: Reviews AL source changes by composing the standard AL review leaf skills plus custom page-dynamics review.
inputs: [pr-diff, file-path]
outputs: [findings-report]
bc-version: [all]
technologies: [al]
countries: [w1]
application-area: [all]
sub-skills:
  - microsoft/skills/review/al-performance-review.md
  - microsoft/skills/review/al-security-review.md
  - microsoft/skills/review/al-privacy-review.md
  - microsoft/skills/review/al-upgrade-review.md
  - microsoft/skills/review/al-style-review.md
  - microsoft/skills/review/al-ui-review.md
  - custom/skills/al-ui-page-dynamics-review.md
  - microsoft/skills/review/al-error-handling-review.md
  - microsoft/skills/review/al-events-review.md
  - microsoft/skills/review/al-interfaces-review.md
  - microsoft/skills/review/al-breaking-changes-review.md
  - microsoft/skills/review/al-web-services-review.md
  - microsoft/skills/review/al-testing-review.md
  - microsoft/skills/review/al-data-modeling-review.md
  - microsoft/skills/review/al-query-review.md
  - microsoft/skills/review/al-appsource-review.md
  - microsoft/skills/review/al-telemetry-review.md
---

# AL code review

Reviews AL source changes by composing the leaf AL review skills. This custom-layer override keeps the standard review leaves and adds a custom UI page-dynamics leaf so record-driven visibility issues are surfaced during normal AL review.

## Source

The sub-skills invoked by this skill are those listed in frontmatter `sub-skills`. The skill does not discover sub-skills implicitly.

## Relevance

A sub-skill is relevant when both of the following hold:

- The orchestrator has supplied inputs that satisfy the sub-skill's declared `inputs`.
- The orchestrator has not disabled the sub-skill via configuration.

Do not pre-filter sub-skills by diff content. Each leaf decides its own applicability and may return `not-applicable` or `no-knowledge`.

## Worklist

The worklist is the list of relevant sub-skills. Invoke every sub-skill in the worklist one at a time.

## Action

For each sub-skill in the worklist:

1. Invoke the sub-skill with the orchestrator's inputs.
2. Append the complete findings-report to `sub-results`.
3. Exclude findings from any sub-skill whose `outcome` is `failed`.
4. Roll up non-failed findings into the top-level `findings[]`, preserving `references`, `domain`, and setting `from-sub-skill` to the producing `skill.id`.
5. Merge duplicates when they point to the same file and overlapping line or range and prescribe materially the same correction.

After all sub-skills complete, perform the normal super-skill self-review pass for cross-cutting concerns and validate any candidate against already loaded BCQuality knowledge before emitting it as an `agent:` finding.

Aggregate `summary.counts` and `summary.coverage` across invoked sub-skills whose `outcome` is not `failed`. Leave top-level `suppressed[]` empty; per-skill suppression remains in `sub-results`.

## Output

Output conforms to the DO output contract, extended with `sub-results` and `skipped-sub-skills`.
