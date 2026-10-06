---
bc-version: [all]
domain: ui
keywords: [visible, field, group, onopenpage, onaftergetrecord, dynamic-visibility, page-variable, false-positive]
technologies: [al]
countries: [w1]
application-area: [all]
---

# Dynamic Visible on fields vs groups

## Description

On AL pages, dynamic `Visible` driven by a page Boolean variable is reliable for `group`, `part`, and `action` controls. For a `field`, a variable-backed `Visible` must be resolved in `OnInit` or `OnOpenPage`; if the value is derived later from the current record, for example in `OnAfterGetRecord`, the field can remain hidden even when the variable later becomes true.

This is a common review trap on Card and Document pages: a developer binds `Visible = SomePageVariable` directly on a field, but `SomePageVariable` is assigned from record data after page open. In that case, the correct pattern is to wrap the field in a captionless `group()` and set `Visible` on the group instead.

## Best Practice

If visibility depends on record state computed in `OnAfterGetRecord` or `OnAfterGetCurrRecord`, place the field inside a `group` with `ShowCaption = false` and bind the group's `Visible` property to the page variable. Use field-level `Visible` with a variable only when the value is known during `OnInit` or `OnOpenPage`.

See sample: [`dynamic-visible-on-fields-vs-groups.good.al`](dynamic-visible-on-fields-vs-groups.good.al).

## Anti Pattern

`Visible = IsSpecialRecord` directly on a field, where `IsSpecialRecord` is assigned from `Rec` in `OnAfterGetRecord`. The field looks correct in code review, but never becomes visible at runtime for records that should show it.

See sample: [`dynamic-visible-on-fields-vs-groups.bad.al`](dynamic-visible-on-fields-vs-groups.bad.al).
