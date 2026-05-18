# Skills Registry — what we author, what we consume, where it lives

Single source of truth for every Claude Code skill pack used across the studio's apps. Maintained alongside `C:/code/ai/CLAUDE.md`. Last reviewed: **2026-05-17** (godogen grew to 23 skills — added `engine-export`, `skeleton-rig`, `ui-elements` alongside MVP-2 of noxdev-creative-studio).

## Authoring repos (sources)

Each row is a git repo whose primary purpose is producing one or more Claude Code skills. The `Skills Provided` column lists what each repo's `publish.sh` (or equivalent) installs into a target's `.claude/skills/`.

| Repo | Path | Skills Provided | Git Remote |
|------|------|----------------|------------|
| **gamegen** | `C:/code/ai/gamegen` | `gamegen` (engine-agnostic personas / commands / templates / rules) | github.com/NoxDevelopment/gamegen |
| **godogen** | `C:/code/ai/godogen` | `godogen`, `godot-task`, `image-pipeline`, `audio-pipeline`, `video-pipeline`, `3d-asset-pipeline`, `animation-pipeline`, `scene-art`, `character-sheet`, `skeleton-rig`, `shader-craft`, `ui-screens`, `ui-elements`, `narrative`, `playtest`, `input-handling`, `save-system`, `camera-rigs`, `asset-manifest`, `provider-preflight`, `engine-export`, `style-anchor`, `world-layout` (23 total — see *godogen skill catalog* below) | github.com/NoxDevelopment/godogen (origin) · htdt/godogen (upstream) |
| **godot-ui** | `C:/code/ai/godot-ui` | `godot-ui` (Godot UI specialist — Control nodes, StyleBox, Theme, common shapes) | github.com/NoxDevelopment/godot-ui |
| **unitygen** | `C:/code/ai/unitygen` | `unitygen`, `unity-task` | github.com/NoxDevelopment/unitygen |
| **unrealgen** | `C:/code/ai/unrealgen` | `unrealgen`, `unreal-task` | github.com/NoxDevelopment/unrealgen |
| **ui-ux-pro-max** | `C:/code/ai/ui-ux-pro-max` | `ui-ux-pro-max` (UI/UX design intelligence — 67 styles, 96 palettes, 13 stacks) | github.com/NoxDevelopment/ui-ux-pro-max |
| **noxdev-skill-registry** | `C:/code/ai/noxdev-skill-registry` | _(this registry)_ | github.com/NoxDevelopment/noxdev-skill-registry |

### Authoring repos — notes

- All authoring repos are now hosted under `github.com/NoxDevelopment/`. (godogen tracks `htdt/godogen` as `upstream` for pulling community improvements.)
- **godogen** now ships **23 skills** (was 2). The original orchestrator/executor pair (`godogen`, `godot-task`) is now joined by 19 implementation skills and 2 discipline skills — see the catalog below. The engine sibling repos (`unitygen`, `unrealgen`) still follow the orchestrator+executor split and have not been expanded.
- **godot-ui** is a sibling pack to `godogen` — it covers Godot UI mechanics. Project-specific style identity stays in the consumer (see `godot-ui/skills/godot-ui/style-overrides.md`).

### godogen skill catalog (23)

| Skill | Kind | Job |
|-------|------|-----|
| `godogen` | orchestrator | Persona modes (Chat/Plan/Code), loop guard, top-level routing. |
| `godot-task` | executor | Task-shaped operations on a Godot 4 project (file scaffolds, scene edits). |
| `image-pipeline` | tooled | ComfyUI dispatcher → Z-Image-Turbo, 21-style multi-LoRA stacking, 53 presets, face-detailer pass. **Primary image path; prefer over any other.** |
| `audio-pipeline` | tooled | SFX (DSP+ADSR), scale-aware procedural music, speech (Kokoro→Orpheus→EdgeTTS). All free + local. |
| `video-pipeline` | tooled | LTX 2.3 on **8 GB VRAM** via Deno's reference workflow (GGUF Q4 UNet + Gemma 3 12B FP4 text encoder + RIFE interp + RTX VSR, pass-split with RAMCleanup). Subcommands: `t2v`/`i2v`/`bundle`/`inject`/`run`/`models`/`presets`. Saved→API converter so the bundled workflow JSON submits via `/prompt`. |
| `3d-asset-pipeline` | tooled (paid) | Tripo3D PNG→GLB with quality presets, batch, and `prop` one-shot (image-pipeline → mesh → sidecar). Budget-gated. |
| `animation-pipeline` | tooled | Sprite cycles (idle/walk/run/attack/hurt/death/jump/cast) via shared-seed phase prompts → spritesheet/GIF. |
| `scene-art` | tooled | Parallax / skybox / tileset / wide environment generators with optional Godot-Unity sidecars. |
| `shader-craft` | tooled | Godot 4 `.gdshader` and Unity ShaderLab/HLSL for water/fog/dissolve/outline/pixel-dither. Text-only, no models. |
| `ui-screens` | tooled | Godot `.tscn` + Unity Canvas-prefab JSON scaffolds for title/menu/hud/inventory/dialog. |
| `character-sheet` | tooled | One ComfyUI/ZIT call produces a 3×3 pose grid for a single character; post-process magenta-keys the background, slices into cells, tight-crops, pads to aspect, saves 9 individual pose PNGs. 9× cheaper + perfect style consistency vs per-frame generation. |
| `skeleton-rig` | tooled | Stick-figure pose-image emission (OpenPose-style) — 24-pose built-in library plus custom-joint input. Pair with `image-pipeline --reference` for ControlNet-style pose conditioning. Pixellab parity, locally + free. |
| `ui-elements` | tooled | Curated `image-pipeline` wrappers for UI sprites: buttons (auto hover/pressed variants), icons, healthbars (matched frame+fill), 9-slice panels (with Godot patch_margin hints), cursors (with hotspots), decorative frames. Pixellab parity. |
| `engine-export` | tooled | Bridges finished assets into engine-native scaffolds. Subcommands: `sprite-frames` (Godot SpriteFrames .tres from spritesheet, with `--append` for multi-animation resources), `sprite-prefab` (Unity prefab JSON), `tileset-tres`, `audio-scene` (AudioStreamPlayer/3D .tscn), `video-scene` (VideoStreamPlayer scene). Closes the last-mile gap between PNG/WAV/MP4 outputs and engine usage. |
| `narrative` | tooled | Ink/Yarn/Dialogic dialogue → engine formats, quest schema validation, world-bible scaffolder, NPC voice batch. |
| `playtest` | tooled | Godot 4 headless runner + checkpoint autoload + markdown bug-surface reports. |
| `input-handling` | tooled | InputMap action templates (platformer / topdown / fps / rts / puzzle / fighting / racing), rebinding UI scaffold (Control tree + persistence autoload), linter for input foot-guns. |
| `save-system` | tooled | Typed `Resource` save model + slot manager (atomic .tmp+rename writes) + autosave timer + thumbnail capture. 6 presets (platformer / topdown / rpg / puzzle / racing / minimal) and a migration-chain pattern baked in. |
| `camera-rigs` | tooled | Drop-in `.tscn` + `.gd` rigs: platformer / topdown / sidescroller (2D); third-person / first-person / topdown-3d (3D); cinematic (2D or 3D dolly); plus screen-shake mixin and bounds-clamp helpers. |
| `asset-manifest` | tooled | Durable `assets/manifest.json` index of every generated asset — `asset_id` + sha + provider + labels + params + references. Find/list/verify/prune/export (Godot `.gd` or Unity JSON). The "have we already made this?" gate. |
| `provider-preflight` | tooled | Pre-batch health check: ComfyUI reachable (`/system_stats`), required LoRAs present, output dir writable + free space, paid-provider budget headroom, MCP server `--health`. JSON output + non-zero exit on errors. |
| `style-anchor` | discipline | `reference.png` is ground truth. ASSETS.md contract, palette extraction, batch-then-verify, drift decision tree. |
| `world-layout` | discipline | ASCII-first authored maps → `LAYOUT.md` → string-grid Godot transcribe. Defeats "streets everywhere" failure. |

The two discipline skills are intentionally tooling-free — their cardinal rules constrain agent behavior at prompt level rather than via Python helpers.

## Consumed-but-no-source skills

_All previously-orphaned skills now have authoring repos. This section tracks any new orphans as they appear._

(none currently)

## Consumer projects (where skills are published)

These are the runtime homes. Each `.claude/skills/<name>` directory under a consumer is the result of a `publish.sh` invocation from one of the authoring repos above.

| Project | Path | Installed Skills | Project-local overrides |
|---------|------|------------------|-------------------------|
| Cigs and Dreams | `C:/code/ai/game dev/cigs-and-dreams/.claude/skills/` | all 23 godogen + `godot-ui` + `godotsmith` | `godot-ui-overrides/style.md` (Shadowrun-SNES palette + project rules) |
| Deathwood | `C:/code/ai/game dev/deathwood/.claude/skills/` | all 23 godogen + `godotsmith` | — |
| New Excitebike | `C:/code/ai/game dev/new-excitebike/.claude/skills/` | all 23 godogen + `godotsmith` | — |
| Primordial | `C:/code/ai/game dev/primordial/.claude/skills/` | all 23 godogen + `godotsmith` | — |
| BMAD claude Windows | `C:/code/ai/BMAD claude Windows/.claude/skills/` | `ui-ux-pro-max` | — |
| localllm_poc / Companion AI | `C:/code/ai/localllm_poc/.claude/skills/` | `ui-ux-pro-max` | — |

The `godotsmith` skill installed in consumers is shipped *by* the godotsmith repo (`C:/code/ai/godotsmith`), which provides client integration with the godotsmith server (separate from the `godogen` orchestrator skill).

### Consumer republish

All four Godot consumers were republished on **2026-05-17** to godogen commit `48c2d98` — they now carry the full 23-skill godogen catalog (most recent batch: `engine-export` + `skeleton-rig` + `ui-elements`). The publish.sh was updated in the same commit to sync per-skill (preserving sibling-repo skills like `godot-ui` and `godotsmith` instead of wiping them with a top-level `rsync --delete`).

To republish a consumer to the current godogen catalog:

```bash
bash C:/code/ai/godogen/publish.sh "C:/code/ai/game dev/<project>"
```

Per-skill sync semantics: each godogen skill subdir is replaced atomically; non-godogen skills (sibling-repo installs, project-local `*-overrides/` and `*.local/` dirs) are left untouched. An "unknown skills" warning prints if anything in the consumer can't be matched to godogen or a known sibling — flag for manual cleanup if it's a removed-from-godogen orphan.

## Studio apps (compose skills via API/subprocess rather than installing them)

These apps **consume** the godogen skill stack but don't install skills into a `.claude/skills/` dir — they wrap the CLIs at runtime.

| App | Path | Wraps | Status |
|-----|------|-------|--------|
| **Noxdev Creative Studio** | `C:/code/ai/noxdev-creative-studio` | **All 18 godogen content skills** via subprocess (image / character-sheet / skeleton-rig / animation / video-t2v+i2v / audio-sfx+music+speech / scene-parallax+skybox+tileset+environment / 3d-prop / shader / ui-screen / narrative-lore / ui-button+icon+healthbar+panel+cursor+frame); plus **5 engine-export targets** (Godot SpriteFrames/.tres + Unity prefab JSON + Godot TileSet/.tres + audio scene + video scene); project mgmt via asset-manifest. **Asset provenance graph** (chain endpoint + UI + MCP tool). **Noxdev-Studio Prisma write-through bridge** (optional, env-gated). | **MVP-3 + chain + module port phase A+B** complete 2026-05-17 (FastAPI backend with 55 routes + 23 SvelteKit panels incl. raster editor + chain view + **Node MCP server** w/ 43 tools). Embedded in Noxdev-Studio at `p/[slug]/creative/` (iframe). Generated assets auto-mirror into the lab's Asset+AssetProvenance tables when `NOXDEV_STUDIO_DB_PATH` is set + project links to a lab slug. Repo: github.com/NoxDevelopment/noxdev-creative-studio. |

## Studio apps (no skills installed)

These apps either don't host a Claude Code project yet, or they consume skills via different mechanisms.

| App | Path | Notes |
|-----|------|-------|
| Noxdev Studio | `C:/code/ai/Noxdev-Studio` | The studio OS shell (Next.js 15 + Prisma/SQLite + Phase B per its STATUS.md, ~53 modules). **Embeds `noxdev-creative-studio` natively** at `p/[slug]/creative/`: dashboard with 23 generator tiles + status cards + recent-assets grid (native React reading from Prisma); deeplink routes `p/[slug]/creative/generate/[kind]/` and `p/[slug]/creative/chain/` (focused per-panel iframes with lab-native breadcrumbs). Auto-provisions a creative-studio project per lab slug. Creative-studio assets mirror into Noxdev-Studio's `Asset` + `AssetProvenance` Prisma tables via the studio's bridge. |
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

- [x] **Create GitHub remotes** for `gamegen`, `unitygen`, `unrealgen`, `godot-ui`, `ui-ux-pro-max`, `noxdev-skill-registry`, `godogen` (NoxDev fork) under `github.com/NoxDevelopment/` and push. _(done 2026-04-26.)_
- [x] **Extract ui-ux-pro-max** to its own repo with `publish.sh`. _(done 2026-04-25 — both consumers republished from the new source.)_
- [x] **Promote godot-ui** to a reusable sibling pack. _(done 2026-04-25 — cigs-and-dreams republished + project-local override moved to `godot-ui-overrides/style.md`.)_
- [x] **Expand godogen catalog.** _(done 2026-05-07 → 2026-05-17 — added 21 skills total: image/audio/video/3d/animation/scene/character-sheet/skeleton-rig/shader/ui-screens/ui-elements/narrative/playtest pipelines + style-anchor and world-layout disciplines + input-handling/save-system/camera-rigs engineering scaffolds + asset-manifest/provider-preflight/engine-export cross-pipeline glue.)_
- [x] **Republish godogen consumers.** _(done 2026-05-17 — all four Godot consumers now have the full 20-skill godogen catalog. publish.sh was hardened in the same pass to sync per-skill instead of wiping the whole `.claude/skills/` tree, so sibling-repo skills like godot-ui + godotsmith now survive a republish.)_
- [ ] **Pull unitygen / unrealgen up to parity.** The godogen expansion (image-pipeline, audio-pipeline, etc.) is engine-agnostic in spirit but Godot-specific in emission. Decide whether to (a) port equivalents into unitygen/unrealgen, or (b) move the engine-agnostic generators (image, audio, 3d) up into `gamegen` and have all three engine packs depend on them.
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
