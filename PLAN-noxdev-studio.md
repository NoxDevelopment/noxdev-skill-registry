# Plan: Noxdev Studio — unified AI game-asset workbench

**Status:** discovery + architecture proposal · awaiting user sign-off before any building.

**Goal:** ship one Noxdev product that does what **pixellab.ai** and **gamelabstudio.co** each do — and does it better. Backed entirely by our existing godogen skill stack so we're not rewriting generators.

## Why ONE project, not two

After auditing both, the overlap is ~70 % and the unique features are complementary, not contradictory:

| Capability | pixellab.ai | gamelabstudio.co | Our existing skill |
|---|---|---|---|
| Pixel-art image gen | ✅ (Pixflux ≤400×400) | ✅ multi-style | `image-pipeline` (ZIT, ≤1K, 21 LoRAs) |
| Character rotation (4/8 dir) | ✅ Pro | ⚠ via separate jobs | `character-sheet` (3×3 pose grid) |
| Skeleton animation | ✅ | ❌ | _(gap)_ |
| Walk cycle / phase animation | ✅ | via video→sheet | `animation-pipeline` |
| Wang tilesets | ✅ | ❌ | `scene-art` (tileset cmd) |
| Isometric tiles | ✅ | ⚠ generic | `scene-art` |
| Seamless textures | ✅ | ✅ | `scene-art` |
| UI element gen | ✅ | ❌ | _(gap, but ui-screens scaffolds work)_ |
| Inpaint / bg removal | ✅ | ✅ | partial in `image-pipeline` |
| Image → Video → Spritesheet | ❌ | ✅ | `video-pipeline` + `animation-pipeline` |
| Multi-style (cartoon, photoreal) | ❌ | ✅ | `image-pipeline` SDXL/Pony path |
| Audio | ❌ | ❌ | **`audio-pipeline` (ours alone)** |
| 3D mesh | ❌ | ❌ | **`3d-asset-pipeline` (ours alone)** |
| Engine export | ⚠ links/Aseprite ext | ⚠ guides | **`godot-task` / Unity/Unreal sidecars** |
| Project / asset management | ⚠ web only | ✅ projects + assets | **`asset-manifest` (durable, git-friendly)** |
| MCP server | ✅ (6 tools) | ✅ (10 tools) | _(would be new — easy because skills already exist)_ |
| Free + local | ❌ paid credits | ❌ subscription | **✅** |
| Resolution caps | hard 400×400 max | undisclosed | **none, full ZIT res** |

Building two projects would mean two web frontends, two MCP servers, two project managers, two auth flows — for products that are 70 % the same. One unified studio gives us all of pixellab's strengths *and* all of gamelab's strengths *and* the godogen-native advantages (audio, 3D, native engine scaffolds, no credits) **with one codebase to maintain**.

## Project name + location

- **Name:** `noxdev-studio` (working title)
- **Location:** `C:/code/ai/noxdev-studio/` — sibling to all the godogen authoring repos
- **Repo:** `github.com/NoxDevelopment/noxdev-studio` (new)
- **License:** to be decided — likely MIT to mirror godogen
- Relationship to existing `Noxdev-Studio` dir at `C:/code/ai/Noxdev-Studio/`: that one is the *studio OS shell* (per REGISTRY). `noxdev-studio` here is the *creative workbench app*. Different things — naming may need refinement.

## Architecture

Three components, each a separate subdir of the new repo:

```
noxdev-studio/
├── backend/        FastAPI app — REST + SSE, wraps godogen skills via subprocess
├── frontend/       SPA — project dashboard, asset browser, generator panels, editor
├── mcp-server/     MCP server — same toolset exposed to Cursor/Claude Code/Windsurf
└── docs/
```

### Backend (Python FastAPI)

- **Generators** are thin REST wrappers around our existing skill CLIs:
  - `POST /generate/image` → calls `image-pipeline/tools/asset_gen.py image …`
  - `POST /generate/character-sheet` → `character-sheet/tools/sheet_gen.py generate …`
  - `POST /generate/animation` → `animation-pipeline/tools/animation_gen.py cycle …`
  - `POST /generate/video-t2v` / `POST /generate/video-i2v` → `video-pipeline/tools/video_gen.py t2v|i2v …`
  - `POST /generate/audio-sfx|music|speech` → `audio-pipeline/tools/audio_gen.py …`
  - `POST /generate/mesh-3d` → `3d-asset-pipeline/tools/mesh_gen.py prop …`
  - `POST /generate/tileset|skybox|parallax` → `scene-art/tools/scene_gen.py …`
  - `POST /generate/shader` → `shader-craft/tools/shader_gen.py …`
- **Project management** is `asset-manifest`-backed. One JSON file per project.
- **Job queue:** background tasks via `asyncio` (no Celery/Redis for MVP; revisit if multi-user).
- **SSE endpoint** (`GET /jobs/{id}/stream`) for live status updates to the frontend.
- **Preflight** before any long job — calls `provider-preflight/tools/preflight.py all`.
- **No auth for MVP** — single-user, localhost-only. Add cookie-session if we open it up.

### Frontend (SPA)

Two reasonable picks: **SvelteKit** or **Next.js (React)**.

- **Pages:**
  - `/` — dashboard (recent projects, recent assets, ComfyUI health, credit/budget status)
  - `/project/[id]` — project home; asset grid; per-asset detail panel
  - `/project/[id]/generate/<kind>` — generator panels for each kind, mirroring godogen skills
  - `/project/[id]/edit/[asset_id]` — in-browser raster editor (brush/eraser/fill/select/text/layers/blend modes — match gamelabstudio's offering, beat pixellab's "no editor" gap)
- **Components:**
  - Asset card (thumbnail, kind badge, provider badge, labels chips, "regenerate" button)
  - Generator panel (form fields per skill, "preview" + "queue" buttons)
  - Job status panel (live SSE feed, ETA, cancel)
  - Style picker (the 21 ZIT styles + SDXL fallbacks, with visual swatches)
- **Raster editor:** wrap `fabric.js` or `konva.js` — both are mature for canvas-tool stacks. Layers + blend modes + selection + text out of the box.

### MCP server

Standalone Node.js or Python MCP server that proxies into the backend. Exposes tools matching pixellab + gamelab MCPs *plus* our extras:

Image: `generate_image`, `generate_character_sheet`, `generate_pose_rotation`, `inpaint`, `remove_background`, `upscale`

Animation/Video: `generate_animation_cycle`, `generate_video_t2v`, `generate_video_i2v`, `generate_spritesheet_from_video`

Tiles/Scenes: `generate_tileset_wang`, `generate_isometric_tile`, `generate_seamless_texture`, `generate_parallax_backdrop`, `generate_skybox`

UI: `generate_ui_buttons`, `generate_ui_icons` _(gap — needs new ui-pipeline skill, or extend image-pipeline)_

Audio: `generate_sfx`, `generate_music`, `generate_speech` _(ours alone vs both competitors)_

3D: `generate_3d_prop` _(ours alone)_

Engine: `scaffold_godot_animation_player`, `scaffold_unity_animator`, `export_spritesheet_with_godot_tres` _(ours alone — actual engine integration)_

Project/asset: `list_projects`, `create_project`, `list_assets`, `find_asset`, `get_job_status`, `download_artifact`

## MVP scope (what we ship first)

Cut to **two slices**, each shippable independently:

**MVP-1 (backend + minimal UI):** ~2 weeks of focused work
- Backend with 5 generator endpoints: image, character-sheet, animation, video-t2v, audio-sfx
- Project management (CRUD + asset-manifest persistence)
- Job queue + SSE streaming
- Frontend dashboard + generator panels for those 5 kinds (forms only, no editor yet)
- ComfyUI health gauge + storage gauge

**MVP-2 (parity + MCP + editor):** ~3 more weeks
- Remaining generators (video-i2v, all audio kinds, scene-art kinds, 3d prop, shader)
- In-browser raster editor (layers, blend modes, basic tools)
- MCP server (Node.js) exposing the full tool set
- Engine-export tools (Godot tres, Unity prefab JSON)

**Beyond MVP:**
- Skeleton animation (the one pixellab feature we don't have a skill for; could become a new `skeleton-rig` skill in godogen)
- UI element gen (the other pixellab gap)
- Multi-user (auth + per-user projects)
- Cloud deploy option (Docker compose; user supplies their own ComfyUI instance)

## What this requires from the user before I start

- **Approve unified-project approach** (vs. two separate pixellab + gamelabstudio clones).
- **Pick frontend framework** — SvelteKit or Next.js? (Skill-team-fit and existing Noxdev conventions matter more than feature-fit; both work.)
- **Confirm `noxdev-studio` is OK as the working name** or pick another. The collision with `C:/code/ai/Noxdev-Studio/` needs resolving.
- **Sign off on MVP-1 scope** as the first deliverable. I'll plan MVP-2 in detail only after MVP-1 ships.

After sign-off, I'd open a tracking issue with the MVP-1 punch list and start scaffolding `noxdev-studio/backend/` and `noxdev-studio/frontend/`.

## What this does NOT include

- A new Noxdev MCP "ecosystem" beyond the one MCP server above.
- Re-authoring the godogen skills inside the studio. The skills stay where they are; the studio is a frontend over them.
- A pricing / billing system. It's free + local; if we ever monetize, that's a separate decision.
- Mobile / native desktop apps. Web SPA only.
