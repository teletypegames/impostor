# TIC-80 Lua Code Regularities

Based on the analysis of `impostor.lua`, the following regularities and conventions should be followed for future modifications and development within this project:

## General Structure & Lifecycle

1.  **TIC-80 Game Loop:** All primary game logic, updates, and rendering should be encapsulated within the `TIC()` function, which serves as the main entry point for each frame of the TIC-80 game cycle.
2.  **Initialization:** Game state variables and one-time setup should occur at the global scope or within a dedicated initialization function called once.

## Naming Conventions

3.  **Functions:** Custom function names should use `PascalCase` (e.g., `UpdatePlayer`, `DrawHUD`). Existing mathematical helper functions like `SQR()` are an exception.
4.  **Variables:** Variables should use `snake_case` (e.g., `player_x`, `game_state`), aligning with the existing `flip_x` variable.
5.  **Constants:** Constants should be named using `SCREAMING_SNAKE_CASE` (e.g., `MAX_SPEED`, `GRAVITY_STRENGTH`).

## Variable Handling & Grouping

6.  **Global Variables:** Major game state variables (e.g., position, velocity, animation frames) are typically defined at the global scope for easy access throughout the game loop.
7.  **Lua Tables for Grouping:** Collections of related data should be grouped into Lua tables for better organization and readability (e.g., `player = {x = 0, y = 0, speed = 1}`).
8.  **Table Formatting:** Tables with multiple elements or complex structures should always be defined with line breaks for each key-value pair, rather than inline, to improve readability.
    Example:
    ```lua
    my_table = {
      key1 = value1,
      key2 = value2,
    }
    ```
    instead of `my_table = {key1 = value1, key2 = value2}`.

## Functions

9.  **Helper Functions:** Reusable logic or common calculations should be extracted into separate, clearly named helper functions.

## Input Handling

10. **`btn()` for Input:** User input should be handled primarily through the TIC-80 `btn()` function, checking for specific button presses or states.

## Graphics & Rendering

11. **`spr()` for Sprites:** Individual sprites should be rendered using the `spr()` function.
12. **`map()` for Maps:** Tilemaps should be drawn using the `map()` function.
13. **`Print.text()` for Text:** Text display should utilize the `Print.text()` function.

## Code Style

14. **Indentation:** Use consistent indentation, likely 2 spaces, for code blocks to enhance readability.
15. **Comments:** Employ comments to explain complex logic, delineate code sections, or clarify non-obvious design choices.
16. **Code Sections:** Use comments (e.g., `--- INIT ---`, `--- UPDATE ---`, `--- DRAW ---`, `--- HELPERS ---`) to clearly delineate logical sections of the codebase.

---

## Agent Directives

- **Git Operations:** In the future, do not perform `git add` or `git commit` operations. This responsibility will be handled by the user.

---

# Impostor Minigames Documentation

This document provides comprehensive documentation for all three minigames implemented in the Impostor game: Button Mash, Rhythm, and DDR (Dance Dance Revolution).

## Table of Contents

- [Overview](#overview)
- [Button Mash Minigame](#button-mash-minigame)
- [Rhythm Minigame](#rhythm-minigame)
- [DDR Minigame](#ddr-minigame)
- [Integration Guide](#integration-guide)
- [Common Features](#common-features)

---

## Overview

The Impostor game includes three interactive minigames that can be triggered during gameplay. Each minigame presents a unique challenge that the player must complete to progress. All minigames feature:

- **Overlay rendering** - Minigames render over the current game window
- **Progress tracking** - Visual indicators show completion status
- **Return mechanism** - Automatic return to the calling window upon completion
- **Visual feedback** - Button presses and hits are visually indicated

---

## Button Mash Minigame

**File**: `inc/window/window.minigame.mash.lua`

### Description

A fast-paced minigame where the player must repeatedly press the Z button to fill a progress bar. The bar automatically degrades over time, and the degradation rate increases as the bar fills up, creating increasing difficulty.

### Gameplay Mechanics

- **Objective**: Fill the progress bar to 100% by pressing Z repeatedly
- **Challenge**: The bar degrades automatically, with degradation increasing as it fills
- **Win Condition**: Bar reaches 100%
- **No Fail State**: Player can keep trying until successful

### Visual Elements

#### Simple sketch
![button_mash.png](/button_mash.png)

```
Progress Bar (200x12px at 20,10):
┌────────────────────────────────────┐
│████████████████░░░░░░░░░░░░░░  45%│
└────────────────────────────────────┘

Button Indicator (Bottom):
╔═══╗
║ Z ║  ← Press repeatedly!
╚═══╝

Text: "MASH Z!"
```

#### Configuration Parameters

```lua
bar_fill = 0                    -- Current fill level (0-100)
max_fill = 100                  -- Target fill level
fill_per_press = 8              -- Points gained per button press
base_degradation = 0.15         -- Base degradation per frame
degradation_multiplier = 0.006  -- Increases degradation with bar fill
button_press_duration = 8       -- Visual feedback duration (frames)
```

#### Usage Example

```lua
-- Start button mash minigame
MinigameButtonMashWindow.start(WINDOW_GAME)

-- Or from any window
MinigameButtonMashWindow.start(WINDOW_POPUP)
```

#### Color Coding

- **Green**: Low fill (0-33%)
- **Medium (NPC color)**: Medium fill (34-66%)
- **Yellow (Item color)**: High fill (67-100%)

---

## Rhythm Minigame

**File**: `inc/window/window.minigame.rhythm.lua`

### Description

A timing-based minigame where the player must press Z when a moving line crosses a green target zone. The target zone shrinks with each successful hit, making the game progressively more challenging.

### Gameplay Mechanics

- **Objective**: Score 10 points by timing button presses correctly
