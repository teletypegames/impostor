# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**Definitely not an Impostor** is a narrative-driven fantasy game built for [TIC-80](https://tic80.com/), a fantasy console. The game is written entirely in Lua. All source modules in `inc/` are concatenated at build time into a single `impostor.lua` file that TIC-80 loads.

## Build Commands

```bash
make build          # Concatenate inc/**/*.lua into impostor.lua (order from impostor.inc)
make minify         # Build then minify (downloads minify.lua if missing)
make lint           # Run luacheck with source mapping to original files
make watch          # Auto-rebuild on file changes in inc/
make export         # Export minified game to HTML and .tic formats
make import_assets  # Import PNG sprite/tile assets into the TIC-80 cartridge
make export_assets  # Extract TIC-80 asset sections into inc/meta/meta.assets.lua
make docs           # Generate documentation with ldoc
make clean          # Remove build artifacts
```

To run the game locally: `tic80 --fs=. impostor.lua`

VSCode tasks are available for "Run TIC80", "Build & Run TIC80", "Export assets", and "Make build".

There is no test framework — validation is done via `make lint` (luacheck).

## Important Workflow Note

**Do not run `git add` or `git commit`** — git operations are the user's responsibility.

## Code Conventions (from GEMINI.md)

- **Functions**: `PascalCase` (e.g., `UpdatePlayer`, `DrawHUD`)
- **Variables**: `snake_case` (e.g., `player_x`, `game_state`)
- **Constants**: `SCREAMING_SNAKE_CASE` (e.g., `MAX_SPEED`)
- **Indentation**: 2 spaces
- **Tables**: Always multi-line with one key-value pair per line
- **Code sections**: Delimited with `--- @section SectionName` comments
- **TIC-80 APIs**: Use `btn()` for input, `spr()` for sprites, `map()` for tilemaps, `Print.text()` for text

## Architecture

The game is a **state machine** driven by a window manager. The build order is defined in `impostor.inc` — 99 source files are concatenated in dependency order.

### Main Loop

`TIC()` in `inc/system/system.main.lua` is TIC-80's per-frame callback. It:
1. Initializes game state once on first call
2. Updates mouse/context timing
3. Delegates to the current active window handler
4. Updates meters, timers, triggers, and glitch effects
5. Draws UI overlays

### Window Manager (`inc/window/window.manager.lua`)

Central UI state machine. Windows register with `id`, `update()`, and `draw()` handlers. Only one window is active at a time. All windows are declared in `window.register.lua`.

| Window | Purpose |
|--------|---------|
| `intro_title` | Title screen |
| `intro_ttg` | "Thanks To Grandma" credits |
| `intro_brief` | Game briefing |
| `menu` | Main menu |
| `game` | Main gameplay (screens + decisions) |
| `popup` | General popup overlay |
| `discussion` | NPC dialogue/conversation |
| `minigame_button_mash` | Button Mash minigame |
| `minigame_rhythm` | Rhythm minigame |
| `minigame_ddr` | DDR minigame |
| `game_over` | Game over / restart screen |
| `end` | End game choice screen |
| `continued` | Day-continued notification |
| `credits` | Credits roll |
| `controls` | Control scheme display |
| `audiotest` | Audio testing utility |
| `player_name` | 3-character name entry before new game |
| `ascend_debug` | Debug utility: start at a specific ascension level |

### Screen & Decision System (`inc/screen/`, `inc/decision/`)

- **Screens** are gameplay scenes. Registered with `Screen.register({id, name, decisions[], background, init, update, draw, exit})`. They manage background maps and NPC sprite placement.
- **Decisions** are player choices available on a screen. Registered with `Decision.register({id, label, condition, handle})`. A `condition` function gates visibility; `handle` drives transitions (to new screens, dialogue, minigames).

Screens: `home`, `office`, `work`, `toilet`, `walking_to_office`, `walking_to_home`, `mysterious_man`, `manager`

Maps (`inc/map/`): `bedroom`, `office`, `street` — rendered via `map.manager.lua`.

### Game Logic (`inc/logic/`)

| Module | Purpose |
|--------|---------|
| `logic.meter.lua` | Tracks ISM/WPM/BM stats (0–1000), combo multipliers, daily decay (20/day) |
| `logic.day.lua` | Day counter; ascension triggers at day 3, game over at day 100 |
| `logic.timer.lua` | Event scheduling/delayed callbacks, one-shot and repeating |
| `logic.trigger.lua` | Conditional event handlers with start/stop callbacks |
| `logic.discussion.lua` | Dialogue parsing, branching answers, NPC portrait rendering |
| `logic.minigame.lua` | Config and win-overlay for Button Mash, Rhythm, and DDR |
| `logic.focus.lua` | Circular reveal/hide overlay transitions (expanding/shrinking circle) |
| `logic.glitch.lua` | Visual glitch effect (random vertical stripes), toggled via `Glitch.show()/hide()` |
| `logic.commute_glitch.lua` | 7-level glitch progression during ascension 7: corrupts sprite lists, remaps Norman to `norman_echo`, speeds up music, blocks/redirects decisions |
| `logic.codegenerator.lua` | Encodes player's 3-char name to a 6-char base-36 completion code shown on the end screen |

### Global State (`inc/init/`)

- `init.context.lua`: All runtime game state (current screen, meter values, progress flags). Persisted in memory bank 6. Key fields: `player_name` (3-char string), `commute_glitch_level` (0–7), `talked_to_norman_echo`, `talked_to_true_sumphore`, `have_been_to_office`, `have_done_work_today`.
- `init.config.lua`: Screen dimensions (240×136), palette colors, timing constants. Persisted in memory bank 7.
- `init.ascension.lua`: 9-level meta-progression system ("ASCENSION" letters progressively lit). Level 7 activates CommunteGlitch; level 9 unlocks the final "Break the cycle" decision.
- `init.context_debug.lua`: `Context.new_game_debug(level)` — starts a new game at a specific ascension level for testing.

### Audio (`inc/audio/`)

- `audio.manager.lua`: Music playback (no-restart if already playing). Named tracks: `room_work` (0), `activity_work` (1), `mystery` (2).
- `audio.generator.lua` / `audio.songs.lua`: Sound generation and song definitions.

### Sprites (`inc/sprite/`)

`sprite.manager.lua` handles registration. Supports single and composite sprites with offset layers.

NPCs: `norman`, `norman_echo` (palette-remapped glitch variant of Norman, shown at commute glitch level 7), `sumphore`, `pizza_vendor`, and 10 developer archetypes (`dev_boy`, `dev_buddy`, `dev_extrovert`, `dev_girl`, `dev_guard`, `dev_guru`, `dev_hr_girl`, `dev_introvert`, `dev_operator`, `dev_project_manager`). Matrix characters: `matrix_architect`, `matrix_neo`, `matrix_oraculum`, `matrix_trinity`.

### Discussions (`inc/discussion/`)

Branching dialogue files loaded by `logic.discussion.lua`. Each file defines one or more named dialogue trees (keyed strings with answer arrays that apply meter deltas).

| File | Dialogues |
|------|-----------|
| `discussion.sumphore.lua` | Sumphore conversations (glitch-aware variants at commute glitch level 7) |
| `discussion.coworker.lua` | Coworker coffee-chat variants per ascension level (`disc_0`, `disc_1`, `disc_asc_1`, `disc_2`, `disc_asc_2`, …) |
| `discussion.commute_glitch.lua` | 8 commute glitch encounter variants (`cg_0`–`cg_7`) + truth/Sumphore variant |
| `discussion.truth.lua` | Dialogue with the "truth" mysterious man |
| `discussion.pizza_vendor.lua` | Pizza vendor interaction |

### Input Utilities (`inc/system/`)

- `system.textinput.lua`: 3-character uppercase letter selector. Supports next/prev letter cycling (A↔Z wrapping) and cursor navigation. Used by `PlayerNameWindow`.

### Key Directories

```
inc/          Source modules (concatenated at build)
assets/       Game assets (sprites, tiles, SFX, music)
assets_src/   Source art (Aseprite files, PNGs for import)
docs/         Design documentation (mostly Hungarian)
tools/        Build utilities (musicator: MIDI→TIC-80 converter)
prompts/      Feature templates
```
