# Ubuntu Runbook

Personal DevOps Runbook for Ubuntu, Docker, Nginx, Cloudflare, SQL Server, Git, and common production issues.

This repository is used by the team to store reusable commands, troubleshooting steps, error fixes, and deployment notes in one searchable documentation site.

---

## Purpose

During daily development, deployment, and server operation, we often fix many repeated issues such as:

* Ubuntu permission errors
* Docker Compose issues
* Port mapping problems
* Nginx reverse proxy errors
* Cloudflare WARP / Tunnel setup
* SQL Server connection through private network
* Git branch or tag conflicts
* YAML indentation errors
* Service startup failures

Instead of keeping commands in chat messages, screenshots, notes, or personal files, this runbook keeps everything in one structured place.

---

## Documentation Website

After running MkDocs locally, open:

```txt
http://127.0.0.1:8000
```

If deployed to GitHub Pages, the site URL should be:

```txt
https://nguyenvuhoang.github.io/ubuntu-runbook/
```

---

## Repository Structure

```txt
ubuntu-runbook/
│
├── .github/
│   └── ISSUE_TEMPLATE/
│       └── runbook-note.yml
│
├── docs/
│   ├── index.md
│   │
│   ├── ubuntu/
│   │   ├── check-ram.md
│   │   ├── check-disk.md
│   │   ├── permission-denied.md
│   │   └── service-systemctl.md
│   │
│   ├── docker/
│   │   ├── docker-compose.md
│   │   ├── port-mapping.md
│   │   ├── docker-logs.md
│   │   └── redis-rabbitmq.md
│   │
│   ├── nginx/
│   │   ├── reverse-proxy.md
│   │   ├── fix-502.md
│   │   └── docker-nginx-html.md
│   │
│   ├── cloudflare/
│   │   ├── warp-private-network.md
│   │   ├── tunnel-to-nginx.md
│   │   └── sqlserver-private-cidr.md
│   │
│   ├── sqlserver/
│   │   ├── docker-sqlserver.md
│   │   ├── open-port-1433.md
│   │   └── connect-through-warp.md
│   │
│   ├── git/
│   │   ├── tag-would-clobber-existing-tag.md
│   │   └── divergent-branch.md
│   │
│   ├── errors/
│   │   ├── yaml-tab-character.md
│   │   ├── port-already-used.md
│   │   └── systemctl-service-not-found.md
│   │
│   ├── templates/
│   │   └── standard-fix-note.md
│   │
│   ├── assets/
│   │   └── background-anhben-universe.png
│   │
│   └── stylesheets/
│       └── extra.css
│
├── mkdocs.yml
├── README.md
└── scripts/
```

---

## Main Categories

| Category     | Purpose                                                     |
| ------------ | ----------------------------------------------------------- |
| `ubuntu`     | Ubuntu/Linux commands, system checks, permissions, services |
| `docker`     | Docker, Docker Compose, containers, images, logs, ports     |
| `nginx`      | Nginx config, reverse proxy, static HTML, 502 errors        |
| `cloudflare` | Cloudflare WARP, Tunnel, Zero Trust, private network        |
| `sqlserver`  | SQL Server on Docker/Linux, port 1433, remote connection    |
| `git`        | Git pull, fetch, tag, branch, merge issues                  |
| `errors`     | Common errors and quick fixes                               |
| `templates`  | Standard templates for new notes                            |

---

## How to Run Locally

### 1. Go to repository folder

```powershell
cd "D:\1.ENVIRONMENT\53.JITS\ubuntu-runbook"
```

### 2. Install MkDocs

```powershell
py -m pip install mkdocs mkdocs-material
```

### 3. Start local documentation site

```powershell
py -m mkdocs serve
```

### 4. Open in browser

```txt
http://127.0.0.1:8000
```

---

## Recommended Local Setup with Virtual Environment

This is the recommended way to avoid affecting global Python packages.

```powershell
cd "D:\1.ENVIRONMENT\53.JITS\ubuntu-runbook"

py -m venv .venv

Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass

.\.venv\Scripts\Activate.ps1

python -m pip install --upgrade pip

pip install mkdocs mkdocs-material

python -m mkdocs serve
```

---

## How Team Members Can Contribute

There are 3 recommended ways to contribute content.

---

## Method 1: Create a GitHub Issue

This is the easiest way for team members.

Use this method when:

* You found an issue but do not know where to put the document
* You want AI or the documentation owner to convert it into a clean runbook note
* You only want to submit error messages, commands, and results

### Steps

1. Open the GitHub repository.
2. Go to the **Issues** tab.
3. Click **New issue**.
4. Select **Runbook Note**.
5. Fill in the form:

   * Category
   * Topic title
   * Situation
   * Error message
   * Commands used to fix
   * Verification commands
   * Final result
   * Tags
6. Submit the issue.

Example issue content:

```txt
Category: docker

Topic title:
Fix Docker Compose YAML tab character

Situation:
When running docker compose up -d, Docker returned a YAML indentation error.

Error message:
yaml: while scanning a plain scalar
found a tab character that violates indentation

Commands used to fix:
grep -nP '\t' docker-compose.yml
sed -i 's/\t/  /g' docker-compose.yml
docker compose config

Verification commands:
docker compose up -d
docker ps

Final result:
Docker Compose started successfully.

Tags:
docker, yaml, compose, ubuntu
```

---

## Method 2: Create or Edit Markdown Files Directly

Use this method when you already know Markdown and GitHub.

### Steps

1. Choose the correct folder:

```txt
docs/ubuntu/
docs/docker/
docs/nginx/
docs/cloudflare/
docs/sqlserver/
docs/git/
docs/errors/
```

2. Create a new `.md` file.

Example:

```txt
docs/docker/fix-docker-compose-yaml-tab-character.md
```

3. Write the note using the standard structure.

4. Commit and create a Pull Request.

---

## Method 3: Create a Pull Request

Use this method when you want your changes reviewed before merging.

### Basic Git commands

```powershell
git checkout -b docs/add-new-runbook-note

git add .

git commit -m "docs: add new runbook note"

git push origin docs/add-new-runbook-note
```

Then open a Pull Request on GitHub.

---

## Standard Note Format

Every runbook note should follow this structure:

````md
# Title

## Situation

Describe when this issue happened.

## Error

```bash
Paste the exact error message here.
````

## Root cause

Explain the reason for the issue.

## Fix commands

```bash
Paste the commands used to fix the issue.
```

## Verification commands

```bash
Paste commands used to verify the fix.
```

## Notes

Add extra notes, warnings, environment details, or related information.

## Tags

`ubuntu`, `docker`, `nginx`, `cloudflare`, `sqlserver`, `git`

````

---

## Example Runbook Note

```md
# Fix Docker Compose YAML Tab Character

## Situation

Docker Compose failed when starting services.

## Error

```bash
yaml: while scanning a plain scalar
found a tab character that violates indentation
````

## Root cause

YAML files do not allow tab characters for indentation. Only spaces should be used.

## Fix commands

Find tab characters:

```bash
grep -nP '\t' docker-compose.yml
```

Replace tabs with two spaces:

```bash
sed -i 's/\t/  /g' docker-compose.yml
```

Validate Docker Compose file:

```bash
docker compose config
```

Start services again:

```bash
docker compose up -d
```

## Verification commands

```bash
docker ps
docker compose logs -f
```

## Tags

`docker`, `docker-compose`, `yaml`, `ubuntu`

````

---

## Writing Rules

Please follow these rules when adding new documentation:

1. Use clear titles.
2. Always include the exact error message if available.
3. Always include verification commands.
4. Do not store passwords, tokens, private keys, or secrets.
5. Do not expose production credentials.
6. Use English for technical comments inside code blocks.
7. Keep commands copy-paste friendly.
8. Add tags at the end of every note.
9. Keep one topic per file.
10. Use lowercase kebab-case for file names.

Good file name:

```txt
fix-docker-compose-yaml-tab-character.md
````

Bad file name:

```txt
Fix Docker Error.md
```

---

## Recommended File Naming

Use this format:

```txt
action-topic-error-or-purpose.md
```

Examples:

```txt
check-ram.md
check-disk.md
fix-nginx-502.md
open-port-1433.md
connect-sqlserver-through-warp.md
fix-git-existing-tag.md
docker-compose-port-mapping.md
```

---

## How to Add a New Page to Navigation

After creating a new Markdown file, add it to `mkdocs.yml`.

Example file:

```txt
docs/docker/fix-docker-compose-yaml-tab-character.md
```

Add this to `mkdocs.yml`:

```yml
nav:
  - Docker:
      - Fix Docker Compose YAML Tab: docker/fix-docker-compose-yaml-tab-character.md
```

Then restart MkDocs:

```powershell
py -m mkdocs serve
```

---

## How to Search

Use the search box at the top of the documentation site.

Recommended keywords:

```txt
yaml tab
docker port
cloudflare tunnel
sqlserver 1433
nginx 502
permission denied
systemctl service not found
git tag clobber
warp private network
```

---

## AI-Assisted Contribution Flow

This repository can support an AI-assisted workflow.

Recommended process:

```txt
Team creates GitHub Issue
        ↓
Issue has label: ai-note
        ↓
GitHub Action reads issue content
        ↓
OpenAI converts issue into Markdown runbook note
        ↓
GitHub Action creates Pull Request
        ↓
Team reviews the generated note
        ↓
Maintainer merges Pull Request
        ↓
MkDocs site updates
```

Important rule:

```txt
AI should create Pull Requests only.
AI should not auto-merge directly into main.
```

This keeps documentation quality under team control.

---

## GitHub Issue Template Location

The issue template file is located at:

```txt
.github/ISSUE_TEMPLATE/runbook-note.yml
```

Full Windows path:

```txt
D:\1.ENVIRONMENT\53.JITS\ubuntu-runbook\.github\ISSUE_TEMPLATE\runbook-note.yml
```

After this file is pushed to GitHub, team members can create structured issues from:

```txt
GitHub Repository → Issues → New issue → Runbook Note
```

---

## Build Static Site

To build the static HTML site:

```powershell
py -m mkdocs build
```

The output will be generated in:

```txt
site/
```

---

## Deploy to GitHub Pages

To deploy manually:

```powershell
py -m mkdocs gh-deploy
```

The generated site will be published to the `gh-pages` branch.

---

## Common Commands

### Start local site

```powershell
py -m mkdocs serve
```

### Build site

```powershell
py -m mkdocs build
```

### Deploy to GitHub Pages

```powershell
py -m mkdocs gh-deploy
```

### Check Git status

```powershell
git status
```

### Commit changes

```powershell
git add .
git commit -m "docs: update runbook"
git push
```

---

## Security Guidelines

Never commit the following information:

```txt
Passwords
API keys
Private keys
Access tokens
Production secrets
Database credentials
Customer information
Internal confidential data
```

If a command contains sensitive values, replace them with placeholders.

Example:

```bash
sqlcmd -S <SERVER_HOST> -U <USERNAME> -P <PASSWORD>
```

Do not write:

```bash
sqlcmd -S 10.10.10.10 -U sa -P RealPassword123
```

---

## Roles

| Role         | Responsibility                                      |
| ------------ | --------------------------------------------------- |
| Team Member  | Submit issues, add notes, propose fixes             |
| Reviewer     | Check accuracy, safety, and formatting              |
| Maintainer   | Merge Pull Requests and manage structure            |
| AI Assistant | Convert raw issue content into clean Markdown draft |

---

## Review Checklist

Before merging a new note, check:

* [ ] Title is clear
* [ ] Correct category folder
* [ ] Error message is included
* [ ] Root cause is explained
* [ ] Fix commands are included
* [ ] Verification commands are included
* [ ] No secrets or credentials are exposed
* [ ] Tags are added
* [ ] Navigation in `mkdocs.yml` is updated if needed

---

## Maintainer Notes

Recommended contribution flow:

```txt
Issue first → AI/Manual Markdown → Pull Request → Review → Merge
```

Recommended branch naming:

```txt
docs/add-docker-note
docs/fix-nginx-502
docs/update-cloudflare-warp
ai/runbook-note-issue-number
```

Recommended commit messages:

```txt
docs: add docker compose yaml fix
docs: update nginx reverse proxy note
docs: add cloudflare warp sqlserver guide
chore: update mkdocs navigation
style: update documentation theme
```

---

## Project Owner

Maintainer:

```txt
BEN / AnhBen
```

GitHub:

```txt
https://github.com/nguyenvuhoang
```

---

## Summary

This runbook is the team's shared DevOps memory.

Every useful command, repeated issue, and verified fix should be saved here so that the team can search and reuse it quickly in the future.
