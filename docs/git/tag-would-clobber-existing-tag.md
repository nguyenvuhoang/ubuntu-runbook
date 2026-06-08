# Fix Git Tag Would Clobber Existing Tag

## Error

```bash
! [rejected] v0.159.28 -> v0.159.28 (would clobber existing tag)
```

## Cause

A local tag has the same name as the remote tag but points to a different commit.

## Fix one tag

```bash
git tag -d v0.159.28
git fetch origin tag v0.159.28
```

## Fix all tags by refreshing from remote

```bash
git fetch --tags --force
```

## Verify

```bash
git tag -l | grep v0.159.28
```

## Tags

`git`, `tag`, `fetch`, `clobber`, `origin`