# Outlaw Heists

> A 2D top-down multiplayer cops-and-robbers heist game — work-in-progress prototype built in Godot.

## Stack

- **Engine:** Godot 4.x
- **Language:** GDScript
- **Networking:** Godot high-level multiplayer over ENet (LAN, port `25565`)

## Description

Outlaw Heists is an in-progress prototype of a two-player heist game set in a small town. One
player is the thief and the other is the police; players move around town, interact, and the
thief can steal goods and sell them at the pawn shop, all under a running day/night cycle.

## Features (implemented in code)

- **LAN multiplayer** (`Multiplayer.gd`) — one player hosts a server, the other joins; roles are
  assigned on connect (first joiner = thief, second = police) via RPCs.
- **Player controllers** (`player_1.gd`, `player_2.gd`) — 4-directional movement with directional
  walk/idle/punch (or shoot) animations and a per-authority camera.
- **Day/night cycle** (`daynightcycle.gd`) — a `CanvasModulate` that samples a gradient over a
  simulated 1440-minute day and emits `time_tick(day, hour, minute)`.
- **Town, houses, farm, and pawn shop** scenes, collectible "getter" objects, and shared game
  state in a `Global` singleton (`global.gd`).

## Controls

| Action | Thief (player 1) | Police (player 2) |
|--------|------------------|-------------------|
| Move | `up` / `down` / `left` / `right` | `u` / `d` / `l` / `r` |
| Action | `interact` (or `ui_accept`) | `shoot` (or `ui_accept`) |

> These are the input-map action names the scripts expect — they must be defined in the Godot
> project's **Input Map** (see status below).

## Project status ⚠️

This repository currently contains **only the GDScript and scene files at the repo root**. It is
**not runnable as committed** — several things the project needs are missing from the repo:

- **No `project.godot`** — Godot can't import the folder as a project without it.
- **Missing `Assets/` folder** — the scenes reference art under `res://Assets/...` (character
  sprites, tilesets, `coin.png`, etc.) that isn't committed, so scenes can't fully load.
- **Folder-structure mismatch** — scripts/scenes reference `res://Scenes/...`, `res://Scripts/...`,
  and `res://Assets/...`, but all files were committed to the repo root. The intended layout was
  `Scenes/`, `Scripts/`, and `Assets/` sub-folders.
- **Missing `SceneManager` autoload** — `main_menu.gd`, `area2d.gd`, and `pawnarea2d.gd` call
  `SceneManager.change_scene(...)`, but no `scene_manager.gd` is committed.
- **Empty stub scripts** — `catch.gd`, `town.gd`, and `input_synchronizer.gd` are empty.

See the repository's Issues for the concrete steps to restore a runnable project.

## How to Build / Run (once restored)

1. Restore the missing `Assets/` folder and the `Scenes/` / `Scripts/` layout (or update the
   `res://Scenes/` / `res://Scripts/` / `res://Assets/` paths to match the current layout).
2. Add a `project.godot` that sets the main scene (`main_menu.tscn`), registers the `Global` and
   `SceneManager` autoloads, and defines the Input Map actions listed above.
3. Open the folder in **Godot 4.x** and press **Play**. One instance hosts; the other joins on
   `localhost:25565` (change the IP in `Multiplayer.gd` for play across machines).

## License

Released under the [MIT License](LICENSE).
