# noxdev-skill-registry

Single source of truth for every Claude Code skill pack used across the NoxDevelopment studio's apps.

## What's here

- **`REGISTRY.md`** — the inventory: authoring repos, consumer projects, compositions, action items.
- **`scripts/discover.sh`** — re-scans the filesystem for every `.claude/skills/` and `skills/` folder under `C:/code/ai/`, prints what's installed where. Run after publishing a skill or onboarding a new project.
- **`scripts/audit.sh`** — checks each authoring repo in REGISTRY.md is a git repo with at least one commit; flags drift between consumers.

## Why a separate repo

The registry was a markdown file at the top of `C:/code/ai/` until 2026-04-25. Promoting it to its own repo gives:

- A single git URL projects (or CI) can clone for the canonical inventory.
- A discovery script that detects drift instead of you remembering to update the doc.
- A licensing / version surface for the registry itself, separate from any one app.

## Updating the registry

After any of these events, re-run `scripts/discover.sh` and update `REGISTRY.md`:

- New authoring repo created (e.g., `ui-ux-pro-max` extracted from a consumer).
- New consumer project initialized (a `publish.sh` invocation).
- A skill was renamed, deleted, or moved.

The registry is human-curated metadata layered on top of the discovery script's output — discovery answers "what exists," registry answers "what's the source of truth, who owns it, and what's the status."

## Conventions

- **Authoring repo** = a git repo whose primary purpose is producing one or more skills, with a `publish.sh` (or equivalent) that copies into a target's `.claude/skills/`.
- **Consumer project** = a project whose `.claude/skills/` directory is populated by one or more authoring repos.
- **Authoring + consumer in one repo** is allowed (e.g., `cigs-and-dreams` authored its own `godot-ui` skill before promotion); call it out in the registry.

## License

MIT — see `LICENSE.md`.
