---
kind: action-skill
id: al-ui-page-dynamics-review
version: 1
title: AL UI page dynamics review
description: Reviews AL page files for dynamic Visible patterns and captionless wrapper-group usage on card and document pages.
inputs: [pr-diff, file-path]
outputs: [findings-report]
bc-version: [all]
technologies: [al]
countries: [w1]
application-area: [all]
---

# AL UI page dynamics review

Reviews AL page source changes against BCQuality UI knowledge about dynamic `Visible` behavior and captionless wrapper groups. This is a leaf action skill: it invokes no sub-skills.

The skill applies to `page`, `pageextension`, and `pagecustomization` files where visibility is driven by page variables and those variables may be assigned from record state in page triggers such as `OnAfterGetRecord` or `OnAfterGetCurrRecord`.

## Source

Read the BCQuality knowledge index once and take the entries whose `domain` is `ui` as the candidate set across enabled layers. Do not open article files at this step. Open full article bodies only after they enter the worklist.

## Relevance

Apply READ frontmatter matching against the task context:

- `bc-version` from the consuming app or orchestrator context
- `technologies` must include `al`
- `countries` from the app context
- `application-area` from the changed objects

Discard non-matching files. Retain conditionally applicable files only when the orchestrator permits them; cap their findings at `confidence: "medium"` and name the unknown dimension in the message.

## Worklist

Narrow the relevant files to the subset that applies to the changes under review.

- Return `outcome: "not-applicable"` when the diff contains no `page`, `pageextension`, or `pagecustomization` files.
- Prefer articles whose topic or keywords match dynamic page visibility and wrapper-group layout: `visible`, `group`, `field`, `onopenpage`, `oninit`, `onaftergetrecord`, `onaftergetcurrrecord`, `page-variable`, `showcaption`, `wrapper-group`, `captionless`, `accessibility`.
- Give highest priority to code that sets `Visible = <page variable>` on a `field()` and also assigns that variable from `Rec` in `OnAfterGetRecord` or `OnAfterGetCurrRecord`.
- Also load the wrapper-group clarification when the diff introduces or reviews a `group()` with `ShowCaption = false` around labeled child fields.

Once the candidate worklist is known, resolve layer precedence per READ and record suppressions.

When the post-conflict worklist is empty because no applicable UI knowledge exists, emit `outcome: "no-knowledge"`. When the worklist is empty because no relevant page-dynamics knowledge matches the diff, emit `outcome: "completed"` with an empty `findings` array.

## Action

For each worklist entry, evaluate the changed page code against the article's `## Best Practice` and `## Anti Pattern` sections.

- Emit a knowledge-backed finding when a `field()` binds `Visible` to a page variable whose value is assigned after page open from current-record state, for example in `OnAfterGetRecord` or `OnAfterGetCurrRecord`. Recommend moving the visibility condition to a wrapping `group()`.
- Do not emit a finding merely because a wrapper `group()` has `ShowCaption = false` when child fields retain their own captions.
- Severity is typically `minor`; raise to `major` only when the pattern clearly hides required editable input on a user-facing page.
- Set `confidence` to `high` when the trigger assignment and field-level `Visible` pattern are explicit in the changed file; otherwise use `medium`.

This leaf emits only knowledge-backed findings. Do not emit reference-less `agent:` findings in this domain.

When the fix is mechanical and local, populate `suggested-code` with a literal replacement for the affected lines. The primary mechanical fix in this skill is replacing a field-level `Visible = <page variable>` pattern with a captionless wrapper `group()` carrying the `Visible` property.

## Output

Output conforms to the DO output contract. Every finding this skill emits MUST set `findings[].domain` to `"Accessibility"`.
