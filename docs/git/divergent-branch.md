# Fix Git Divergent Branch

## Error

```bash
fatal: Need to specify how to reconcile divergent branches.
```

## Option 1: merge pull

```bash
git config pull.rebase false
git pull
```

## Option 2: rebase pull

```bash
git config pull.rebase true
git pull
```

## Option 3: fast-forward only

```bash
git config pull.ff only
git pull
```

## Set globally

```bash
git config --global pull.rebase false
```

## Tags

`git`, `pull`, `rebase`, `merge`, `divergent-branch`