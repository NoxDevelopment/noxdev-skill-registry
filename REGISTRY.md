# Skills Registry — what we author, what we consume, where it lives

Single source of truth for every Claude Code skill pack used across the studio's apps. Maintained alongside `C:/code/ai/CLAUDE.md`. Last reviewed: **2026-04-25**.

## Authoring repos (sources)

Each row is a git repo whose primary purpose is producing one or more Claude Code skills. The `Skills Provided` column lists what each repo's `publish.sh` (or equivalent) installs into a target's `.claude/skills/`.

| Repo | Path | Skills Provided | Git Remote | Initial Commit |
|------|------|----------------|------------|----------------|
| **gamegen** | `C:/code/ai/gamegen` | `gamegen` (engine-agnostic personas / commands / templates / rules) | _local-only_ | `7fb32a2` |
| **godogen** | `C:/code/ai/godogen` | `godogen`, `godot-task` | github.com/htdt/godogen | `c2d5815` |
| **unitygen** | `C:/code/ai/unitygen` | `unitygen`, `unity-task` | _local-only_ | `03d5145` |
| **unrealgen** | `C:/code/ai/unrealgen` | `unrealgen`, `unreal-task` | _local-only_ | `f148834` |

### Authoring repos — what's missing

- **gamegen / unitygen / unrealgen** are local-only. Push to a NoxDevelopment GitHub org when ready (matches `godotsmith` / `noxdev-studio` / `OMNI-ORCHESTRA` / `companion-ai` pattern).
- **godogen** ships with two skills (`godogen`, `godot-task`); the new sibling repos follow the same orchestrator+executor split.

## Consumed-but-no-source skills

Skills that exist in consumer projects but have no authoritative authoring repo we own. Each is a candidate for extraction into its own pack.

| Skill | Found in (consumers) | Notes |
|-------|----------------------|-------|
| `ui-ux-pro-max` | `BMAD claude Windows`, `localllm_poc` | 33 files, identical copies. Third-party? Should live in one source repo with `publish.sh`. |
| `godot-ui` | `game dev/cigs-and-dreams` | Single file (`godot-ui-expert.md`). Project-local custom skill — author of cigs-and-dreams's Shadowrun-SNES UI guide. Decide: keep project-local or promote to a `godogen-ui` sibling. |

## Consumer projects (where skills are published)

These are the runtime homes. Each `.claude/skills/<name>` directory under a consumer is the result of a `publish.sh` invocation from one of the authoring repos above.

| Project | Path | Installed Skills |
|---------|------|------------------|
| Cigs and Dreams | `C:/code/ai/game dev/cigs-and-dreams/.claude/skills/` | `godot-task`, `godot-ui`, `godotsmith` |
| Deathwood | `C:/code/ai/game dev/deathwood/.claude/skills/` | `godot-task`, `godotsmith` |
| New Excitebike | `C:/code/ai/game dev/new-excitebike/.claude/skills/` | `godot-task`, `godotsmith` |
| Primordial | `C:/code/ai/game dev/primordial/.claude/skills/` | `godot-task`, `godotsmith` |
| BMAD claude Windows | `C:/code/ai/BMAD claude Windows/.claude/skills/` | `ui-ux-pro-max` |
| localllm_poc / Companion AI | `C:/code/ai/localllm_poc/.claude/skills/` | `ui-ux-pro-max` |

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
Godot project    : gamegen + godogen + godot-task
Unity project    : gamegen + unitygen + unity-task
Unreal project   : gamegen + unrealgen + unreal-task
Engine-agnostic  : gamegen alone (rare)
```

Each engine pack ships an orchestrator (`<engine>gen`) + executor (`<engine>-task`). `gamegen` provides the cross-engine layer (personas, commands, templates, path-scoped rules).

## Action items

- [ ] **Create GitHub remotes** for `gamegen`, `unitygen`, `unrealgen` under `github.com/NoxDevelopment/` and push initial commits.
- [ ] **Decide ui-ux-pro-max ownership**: extract to its own repo (sibling of gamegen) with a `publish.sh`, or recognize it as third-party and pin a vendored version + license. Currently shipping two divergent-able copies.
- [ ] **Decide godot-ui future**: leave project-local in cigs-and-dreams, or promote to a reusable `godot-ui` sibling pack for stylized UI authoring across Godot projects.
- [ ] **Audit consumers periodically.** Run a discovery pass quarterly (or after a `publish.sh` change to any source pack) to make sure consumers haven't drifted.

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
