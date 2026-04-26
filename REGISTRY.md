# Skills Registry — what we author, what we consume, where it lives

Single source of truth for every Claude Code skill pack used across the studio's apps. Maintained alongside `C:/code/ai/CLAUDE.md`. Last reviewed: **2026-04-25** (added `ui-ux-pro-max` and `godot-ui` as authoring repos after extraction).

## Authoring repos (sources)

Each row is a git repo whose primary purpose is producing one or more Claude Code skills. The `Skills Provided` column lists what each repo's `publish.sh` (or equivalent) installs into a target's `.claude/skills/`.

| Repo | Path | Skills Provided | Git Remote | Initial Commit |
|------|------|----------------|------------|----------------|
| **gamegen** | `C:/code/ai/gamegen` | `gamegen` (engine-agnostic personas / commands / templates / rules) | _local-only_ | `7fb32a2` |
| **godogen** | `C:/code/ai/godogen` | `godogen`, `godot-task` | github.com/htdt/godogen | `c2d5815` |
| **godot-ui** | `C:/code/ai/godot-ui` | `godot-ui` (Godot UI specialist — Control nodes, StyleBox, Theme, common shapes) | _local-only_ | `3b612d5` |
| **unitygen** | `C:/code/ai/unitygen` | `unitygen`, `unity-task` | _local-only_ | `03d5145` |
| **unrealgen** | `C:/code/ai/unrealgen` | `unrealgen`, `unreal-task` | _local-only_ | `f148834` |
| **ui-ux-pro-max** | `C:/code/ai/ui-ux-pro-max` | `ui-ux-pro-max` (UI/UX design intelligence — 67 styles, 96 palettes, 13 stacks) | _local-only_ | `071779e` |
| **noxdev-skill-registry** | `C:/code/ai/noxdev-skill-registry` | _(this registry)_ | _local-only_ | `be95152` |

### Authoring repos — what's missing

- **gamegen / unitygen / unrealgen / godot-ui / ui-ux-pro-max / noxdev-skill-registry** are local-only. Push to a NoxDevelopment GitHub org when ready (matches `godotsmith` / `noxdev-studio` / `OMNI-ORCHESTRA` / `companion-ai` pattern).
- **godogen** ships with two skills (`godogen`, `godot-task`); the engine sibling repos (`unitygen`, `unrealgen`) follow the same orchestrator+executor split.
- **godot-ui** is a sibling pack to `godogen` — it covers Godot UI mechanics. Project-specific style identity stays in the consumer (see `godot-ui/skills/godot-ui/style-overrides.md`).

## Consumed-but-no-source skills

_All previously-orphaned skills now have authoring repos. This section tracks any new orphans as they appear._

(none currently)

## Consumer projects (where skills are published)

These are the runtime homes. Each `.claude/skills/<name>` directory under a consumer is the result of a `publish.sh` invocation from one of the authoring repos above.

| Project | Path | Installed Skills | Project-local overrides |
|---------|------|------------------|-------------------------|
| Cigs and Dreams | `C:/code/ai/game dev/cigs-and-dreams/.claude/skills/` | `godot-task`, `godot-ui`, `godotsmith` | `godot-ui-overrides/style.md` (Shadowrun-SNES palette + project rules) |
| Deathwood | `C:/code/ai/game dev/deathwood/.claude/skills/` | `godot-task`, `godotsmith` | — |
| New Excitebike | `C:/code/ai/game dev/new-excitebike/.claude/skills/` | `godot-task`, `godotsmith` | — |
| Primordial | `C:/code/ai/game dev/primordial/.claude/skills/` | `godot-task`, `godotsmith` | — |
| BMAD claude Windows | `C:/code/ai/BMAD claude Windows/.claude/skills/` | `ui-ux-pro-max` | — |
| localllm_poc / Companion AI | `C:/code/ai/localllm_poc/.claude/skills/` | `ui-ux-pro-max` | — |

The `godotsmith` skill installed in consumers is shipped *by* the godotsmith repo (`C:/code/ai/godotsmith`), which provides client integration with the godotsmith server (separate from the `godogen` orchestrator skill).

## Studio apps (no skills installed)

These apps either don't host a Claude Code project yet, or they consume skills via different mechanisms.

| App | Path | Notes |
|-----|------|-------|
| Noxdev Studio | `C:/code/ai/Noxdev-Studio` | The studio OS; `.claude/` exists for repo-level config but no published skills. Future home for studio-internal automation skills. |
| godotsmith server | `C:/code/ai/godotsmith` | Headless Godot server. Authoring repo for the `godotsmith` consumer skill. |
| ArtStation | `C:/code/ai/ArtStation` | Reference / prototype workspace. |
| betterhomeschool | `C:/code/ai/betterhomeschool` | Side project. |
| candle | `C:/code/ai/candle` | Rust ML framework upstream. |
| DevBuddy | `C:/code/ai/DevBuddy` | Tooling experiment. |
| orpheus-tts | `C:/code/ai/orpheus-tts` | TTS backend. |

## Compositions (which skill packs co-install)

Per `gamegen/INTEGRATION.md` (mirrored to unitygen + unrealgen), packs are composable:

```
Godot project (UI-heavy) : gamegen + godogen + godot-task + godot-ui
Godot project (basic)    : gamegen + godogen + godot-task
Unity project            : gamegen + unitygen + unity-task
Unreal project           : gamegen + unrealgen + unreal-task
Web/UI-only project      : ui-ux-pro-max  (alone, or with relevant frameworks)
Studio internal apps     : ui-ux-pro-max + project-specific local overrides
```

Each engine pack ships an orchestrator (`<engine>gen`) + executor (`<engine>-task`). `gamegen` provides the cross-engine layer (personas, commands, templates, path-scoped rules). `godot-ui` and `ui-ux-pro-max` are UI-discipline specialists, orthogonal to the engine packs.

## Action items

- [ ] **Create GitHub remotes** for `gamegen`, `unitygen`, `unrealgen`, `godot-ui`, `ui-ux-pro-max`, `noxdev-skill-registry` under `github.com/NoxDevelopment/` and push initial commits.
- [x] **Extract ui-ux-pro-max** to its own repo with `publish.sh`. _(done 2026-04-25 — `C:/code/ai/ui-ux-pro-max`, both consumers republished from the new source.)_
- [x] **Promote godot-ui** to a reusable sibling pack. _(done 2026-04-25 — `C:/code/ai/godot-ui`, cigs-and-dreams republished + project-local override moved to `godot-ui-overrides/style.md`.)_
- [ ] **Audit consumers periodically.** Run `scripts/discover.sh` and `scripts/audit.sh` quarterly (or after a `publish.sh` change to any source pack) to make sure consumers haven't drifted.

## Discovery commands

```bash
# Find all skill installation points across the studio
find C:/code/ai -maxdepth 6 -type d -name "skills" 2>/dev/null \
  | grep -vE "node_modules|\.godot|companion_ai_core|otium_reborn"

# List skills published into a specific consumer
ls "C:/code/ai/game dev/cigs-and-dreams/.claude/skills/"

# Verify the publish source of an installed skill (compare file counts)
diff -r "C:/code/ai/godogen/skills/godot-task/" \
        "C:/code/ai/game dev/cigs-and-dreams/.claude/skills/godot-task/"

# Check git origin of an authoring repo
git -C C:/code/ai/<repo> remote -v
```

## Maintenance protocol

When you add a new skill to an authoring repo:

1. Update the source repo's SKILL.md `Files` index.
2. Republish to active consumers: `<repo>/publish.sh <consumer>`.
3. Update this registry (Authoring or Consumer table as needed).
4. Update the date at the top of this file.

When you add a new consumer:

1. Run the relevant authoring repo's `publish.sh <consumer>`.
2. Add the consumer to the Consumer Projects table.
3. Update this registry.
