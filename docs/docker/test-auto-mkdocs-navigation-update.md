# Test auto MkDocs navigation update

## Situation

After updating `scripts/ai-generate-runbook.mjs`, verify that the AI workflow can create a new Markdown note and automatically add it to the correct `mkdocs.yml` navigation section.

## Error

```bash
This is a test issue only.
No production error happened.
```

## Root cause

This is a test issue used to validate the updated AI runbook generation flow, especially automatic `mkdocs.yml` navigation updates.

## Fix commands

```bash
echo "Testing AI runbook markdown generation"
echo "Testing automatic mkdocs.yml navigation update"
```

## Verification commands

```bash
grep -n "Test auto MkDocs navigation update" mkdocs.yml
python -m mkdocs serve
```

## Notes

- This issue is intended for workflow validation, not incident recovery.
- Expected result: GitHub Actions opens a PR containing a new Markdown file under `docs/docker/` and an updated `mkdocs.yml` entry under the Docker navigation section.
- Close the issue only after confirming the PR contains the expected documentation-only changes.

## Tags

`test`, `docker`, `mkdocs`, `navigation`, `ai-note`, `workflow`