---
bc-version: [all]
domain: ui
keywords: [group, show-caption, visible, wrapper-group, field-caption, accessibility, false-positive]
technologies: [al]
countries: [w1]
application-area: [all]
---

# ShowCaption false on a wrapper group preserves field labels

## Description

In a Card or Document page, setting `ShowCaption = false` on a wrapper `group()` does not remove captions from the fields inside that group. Each child field keeps its own label, so a captionless wrapper group is valid when it is used only for layout or for container-level properties such as dynamic `Visible`.

This matters when a group is introduced solely to solve a page-behaviour issue, for example to make dynamic visibility react to values assigned in `OnAfterGetRecord`. Do not flag the wrapper group itself as an accessibility problem if the editable child fields still show their own captions.

## Best Practice

Use `ShowCaption = false` on a wrapper group when the group has no user-facing heading and exists only to organize layout or carry container-level properties. Keep captions on the child fields unless one of the documented field-level exceptions applies.

## Anti Pattern

Treating a captionless wrapper `group()` as equivalent to `ShowCaption = false` on an editable field. The former hides only the group heading; the latter removes the field's visible label and can create an accessibility defect.