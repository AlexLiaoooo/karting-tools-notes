# karting-notes

Design documentation and UI screenshots for **Kart Data**, a local-first, mobile-first
trackside recorder for karting, and its **Track Map Notebook** feature module.

> **This repository contains no application code.**
> Kart Data lives in a separate, private repository and deploys from `main` to Vercel.
>
> **TODO:** record the Kart Data repository URL here. It is not written down in the vault
> or in this repo, so there is currently no pointer from the design notes to the code they
> describe.

This repo exists so the design work and reference screenshots are backed up and
reviewable in one place, independently of the app repository and of local machines.

## Contents

### `docs/` — design notes

| File | What it covers |
| --- | --- |
| [Track Map Notebook - Architecture.md](docs/Track%20Map%20Notebook%20-%20Architecture.md) | The confirmed design for Track Map Notebook: product model (Track → Layout → markers → visits), data model and TypeScript types, IndexedDB store layout and migration rules, marker types, image handling, backup/restore, MVP scope and later phases. |
| [Karting Tools - Idea Backlog.md](docs/Karting%20Tools%20-%20Idea%20Backlog.md) | The other twelve karting tool ideas that were considered, with value/difficulty notes, plus ideas explicitly ruled out and a suggested build order. |

These are mirrored from an Obsidian vault, which remains the source of truth.
See [Keeping the docs in sync](#keeping-the-docs-in-sync).

**Why these live here and not in the application repository.** The architecture note
describes a feature module inside Kart Data, so it could reasonably sit beside that code.
The idea backlog could not: it spans twelve separate tool concepts, most of which are not
Kart Data, plus adjacent non-karting tools. That is portfolio-level planning, not
application documentation. The two notes are also a linked pair, and separating them would
break the wikilinks in both directions. Both therefore stay here, and this repository is
the design and planning archive for the karting tools generally rather than for Kart Data
alone.

### Screenshots

**Track Map Notebook**

| File | What it shows |
| --- | --- |
| `pfi-default-map.png` | Reference map view. The built-in PF International schematic with sector colouring and dashed pit lane, zoom/reset controls, **Edit map**, **Replace map image**, and the OpenStreetMap ODbL attribution. |
| `track-map-session-mobile.png` | Session track notes on mobile. Corner marker `T1` with its permanent general/dry reference shown read-only above a session-specific observation field, Better/Same/Worse result, and a session summary saved separately from the permanent notes. Predates the schematic, so the map area is still a placeholder image. |

**Kart Data core**

| File | What it shows |
| --- | --- |
| `theme-dark-mobile.png` | Home screen, dark theme, empty state — "No events yet", with the local-first promise that records stay on the device and work without an account. |
| `theme-dark-modal-mobile.png` | Create event modal, dark theme. |
| `theme-light-modal-mobile.png` | Create event modal, light theme. |
| `ambient-temperature-mobile.png` | Create event modal with ambient temperature auto-filled from device location via Open-Meteo. |

## Status

The Track Map Notebook MVP was implemented on 2026-08-15 inside the Kart Data app:
Track and Layout management, the built-in PF International schematic with backfill for
existing records, multi-type permanent markers, zoom/pan, separate view and edit modes,
Event layout selection, session overlays, offline local persistence, and backup/restore
including map images.

Phase 2 (run-specific observations, next-run focus, promoting observations to permanent
knowledge) and Phase 3 (racing lines, GPS and telemetry overlays, sharing) are not started.

> The architecture note describes the design as of its last edit. If the app has moved on
> since, treat the app repository as authoritative and update the note in the vault.

## Keeping the docs in sync

The Obsidian vault is the source of truth. The copies in `docs/` are byte-identical
mirrors, and `.gitattributes` pins `*.md` to LF so `core.autocrlf` cannot rewrite them
to CRLF on checkout and break that.

After editing the notes in Obsidian, copy them across before committing:

```powershell
.\scripts\sync-docs.ps1
```

To check whether `docs/` has gone stale without changing anything (exits `1` if it has,
so it works as a pre-commit check):

```powershell
.\scripts\sync-docs.ps1 -Check
```

The script only ever copies vault → repo, never the reverse, and never commits. If the
vault moves, pass the new location with `-VaultPath '<folder>'`.

Exit codes: `0` up to date, `1` stale, `2` vault not found.

### Enforcing it

A tracked pre-commit hook in [`.githooks/pre-commit`](.githooks/pre-commit) runs that
check and refuses the commit while `docs/` is behind the vault, so the mirror cannot
drift by being forgotten. Enable it once per clone:

```powershell
git config core.hooksPath .githooks
```

The hook only blocks on exit code `1`. If the check cannot run at all — no vault on this
machine, no PowerShell, script missing — it is skipped with a warning and the commit
proceeds, because a check that is merely unavailable should never wedge the repository.
To bypass it deliberately:

```powershell
git commit --no-verify
```

Because the notes are mirrored verbatim, Obsidian wikilinks such as
`[[Karting Tools - Idea Backlog]]` render as literal text on GitHub rather than as links.
That is deliberate: it keeps the two copies identical and the sync a plain file copy.
