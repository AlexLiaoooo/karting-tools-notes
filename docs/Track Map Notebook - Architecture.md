---
type: project-design
status: implemented-mvp
created: 2026-08-15
tags:
  - karting
  - product-idea
  - track-notes
  - web-app
---

# Track Map Notebook - Architecture

## Implementation status

The confirmed MVP was implemented inside the Kart Data website on 2026-08-15. The local implementation includes Track and Layout management, a built-in PF International owner-driver schematic plus uploaded map assets, multi-type permanent markers, zoom/pan, Event Layout selection, Session overlays, offline-compatible local persistence, and full backup/restore including map images. Existing PF International Full Layout records without a map are backfilled at startup; custom map assets are never overwritten.

Run-specific observations, racing-line drawing, GPS, telemetry, collaboration and AI remain later-phase work.

## Product summary

Track Map Notebook is a mobile-first visual notebook for building track knowledge. A driver uploads a circuit layout image, places notes directly on corners or important locations, and keeps permanent reference knowledge separate from observations made during a particular Event, Session or Run.

The first version should remain local-first, work without an account and continue working when circuit connectivity is poor.

Related ideas: [[Karting Tools - Idea Backlog]]

## Confirmed product decision

Build Track Map Notebook as an **independent feature module inside the existing Kart Data website**.

The user will continue to have one:

- Kart Data website and Home Screen app
- Event, Session and Run hierarchy
- Local database
- Backup and restore workflow
- GitHub repository and Vercel deployment

Reasons:

- Track notes are most valuable when they are connected to the Event and Session that produced them.
- The user should not need to create the same Track, Event and Session in two websites.
- Session notes can be reviewed alongside tyre, Setup and lap-time data without file exchange.
- Trackside use remains one PWA, one backup and one offline data set.
- Run-specific corner observations can be added later using the existing Run IDs and shared local database.

Integration does **not** mean placing all Track Map logic inside the existing `app/page.tsx`. The map feature must have its own components, types, database access and image-processing code. The user experience is integrated while the code remains modular.

The final product model is:

```text
Kart Data
├── Track Library
│   └── Track → Layout → permanent reference markers
└── Event
    └── Session
        └── Track Notes → Session-specific overlay
```

## Core user model

```text
Track
└── Layout
    ├── Map image
    ├── Reference markers
    │   ├── Corner 1
    │   ├── Braking point
    │   ├── Bump / hazard
    │   └── Overtaking point
    └── Visits
        └── Event
            ├── Session observation
            └── Run observation
```

### Track

A physical circuit, for example `PF International`.

### Layout

A particular configuration or direction at that circuit. A Track may eventually have more than one Layout.

Examples:

- Full circuit clockwise
- Short layout
- Wet-weather alternative layout

### Reference marker

Permanent knowledge that should remain useful across many visits:

- Corner name or number
- Braking reference
- Turn-in point
- Apex and exit intention
- Kerb use
- Bump or hazard
- Overtaking opportunity
- General, dry and wet notes

### Visit observation

What happened on a specific day or Run:

- Grip was lower than the previous visit
- Braking point moved because of a headwind
- A later apex worked in Practice 2
- The wet line had more grip away from the rubber
- The driver should focus on this corner in the next Run

Keeping reference markers and visit observations separate is a critical architectural rule. Temporary observations must not overwrite permanent track knowledge.

## Primary workflows

### 1. Create a Track and Layout

1. Open **Track Maps**.
2. Tap **New track**.
3. Enter the circuit and layout names.
4. For PF International Full Layout, start with the built-in schematic or replace it with an authorised circuit map. For other circuits, upload or photograph a circuit map.
5. Crop/rotate if necessary and save.

The PF International quick-start map is a project-generated schematic derived from OpenStreetMap raceway geometry. It is not an official promotional image; the UI displays OpenStreetMap attribution and the ODbL licence link. Other circuits still use user-supplied map images. Automatically downloading proprietary maps remains out of scope because of copyright, image-quality and CORS concerns.

### 2. Add reference markers

1. Enter **Edit map** mode.
2. Tap **Add marker**.
3. Tap the required position on the image.
4. Select a marker type and add a short instruction.
5. Optionally add detailed dry/wet notes.

Map editing and normal viewing must be separate modes. This avoids accidentally moving markers while using the phone at the circuit.

### 3. Prepare for a Session

1. Open the relevant Event and Layout.
2. Select up to three markers as **Next Run focus**.
3. Display a simplified focus card before going on track.

The focus view should deliberately limit the driver to a small number of instructions rather than showing every note on the map.

### 4. Debrief after a Run

1. Open the completed Run.
2. Tap a marker or select it from the focus list.
3. Record what happened and whether the change was better, the same or worse.
4. Decide whether the observation should remain event-specific or be promoted into permanent reference knowledge.

## Kart Data integration points

### Track Library

Add a Track Library entry from the Kart Data home or settings area. It owns reusable Tracks, Layouts, map images and permanent reference markers.

### Event

When creating or editing an Event, allow the existing Track text field to select an optional saved Layout. Preserve the current text field for backward compatibility and for circuits without a saved map.

Recommended compatible addition:

```ts
type EventRecord = {
  // Existing fields remain unchanged
  track: string;
  trackLayoutId?: string;
};
```

### Session

Add a **Track notes** button to each Session page. It opens the selected Layout with a Session-specific overlay.

Session overlays should be stored in the Track Map module and keyed by `sessionId`; the large map data does not need to be nested inside `SessionRecord`.

### Run

Run-specific observations are a later phase. When added, a Run can reference marker observations and a small **Next Run focus** list without copying the permanent map into the Run record.

## Screen architecture

### Track Library

- List of Tracks
- Layout thumbnail
- Number of markers
- Date of last visit
- Search
- New Track button

### Track Detail

- Track name and location
- Available Layouts
- Previous Events at the circuit
- Open map
- Edit Track

### Map Workspace

Three modes:

1. **Reference** - shows permanent knowledge.
2. **Event** - overlays observations from one Event/Session/Run.
3. **Focus** - shows only selected priorities for the next Run.

The map occupies most of the screen. Tapping a marker opens a bottom sheet rather than navigating away from the map.

### Marker Bottom Sheet

First-version fields:

- Label, such as `T4` or `Hairpin`
- Marker type
- Short instruction
- General note
- Dry note
- Wet note
- Priority / focus toggle
- Edit, move and delete actions

### Event Overlay

- Event and Session selector
- Weather and condition summary
- Marker observations
- Better / same / worse result
- Next Run focus selection

## Marker types for the first version

Keep the initial set small:

- Corner
- Braking
- Turn-in
- Apex
- Exit
- Kerb / bump / hazard
- Overtaking
- Focus

Colour and icon should both identify the type so that meaning does not rely only on colour.

## Data model

```ts
type Track = {
  id: string;
  name: string;
  location: string;
  notes: string;
  createdAt: string;
  updatedAt: string;
};

type TrackLayout = {
  id: string;
  trackId: string;
  name: string;
  direction: "Clockwise" | "Anti-clockwise" | "Unknown";
  mapAssetId: string;
  markers: TrackMarker[];
  createdAt: string;
  updatedAt: string;
};

type TrackMarker = {
  id: string;
  x: number; // Normalised from 0 to 1
  y: number; // Normalised from 0 to 1
  order: number;
  label: string;
  type: "Corner" | "Braking" | "Turn-in" | "Apex" | "Exit" | "Hazard" | "Overtaking" | "Focus";
  shortInstruction: string;
  generalNote: string;
  dryNote: string;
  wetNote: string;
  tags: string[];
  updatedAt: string;
};

type TrackVisit = {
  id: string;
  layoutId: string;
  eventId: string | null;
  date: string;
  condition: "Dry" | "Damp" | "Wet" | "Mixed";
  focusMarkerIds: string[];
  observations: MarkerObservation[];
  summary: string;
  createdAt: string;
  updatedAt: string;
};

type MarkerObservation = {
  id: string;
  markerId: string;
  sessionId: string | null;
  runId: string | null;
  note: string;
  result: "" | "Better" | "Same" | "Worse";
  promoteToReference: boolean;
  createdAt: string;
};
```

Marker positions must be stored as normalised values between `0` and `1`, not pixels. This keeps markers in the correct location when the image is displayed at different sizes on an iPhone, desktop or exported image.

## Storage architecture

Upgrade the existing Kart Data IndexedDB database without deleting or rewriting the current `app` store. Map images should remain separate from ordinary note records so that editing text or moving a marker does not repeatedly rewrite a large image payload.

Recommended IndexedDB structure:

```text
kart-data-recorder
├── app           Existing AppData, Events, Sessions, Runs and templates
├── tracks        Track records
├── trackLayouts  Layout records and permanent reference markers
├── trackVisits   Session and future Run observations
└── mapAssets     Resized map image Blobs
```

Implementation notes:

- Increase the IndexedDB schema version and create the new stores without deleting the existing `app` store.
- Store image `Blob` objects in `mapAssets`.
- Save a map record only when a marker edit finishes, not continuously during every pointer movement.
- Debounce ordinary text-note saving.
- Keep database access behind a small repository layer so UI components do not call IndexedDB directly.
- Use existing Event, Session and Run IDs as references rather than duplicating their data in Track Map records.
- A database migration failure must leave the current Kart Data records readable.

## Image handling

When a map is uploaded:

1. Read it in the browser.
2. Correct orientation where necessary.
3. Resize the longest side to approximately 1600 pixels.
4. Save an optimised WebP or JPEG Blob.
5. Record width, height, MIME type and file size.

The MVP does not need to retain the full-resolution original. A file-size warning should appear before storing an unusually large map.

## Backup and portability

Track Maps must be included in full backup and restore. A backup that excludes the map images would create incomplete records.

Recommended approach:

- Extend the existing versioned Kart Data JSON backup to include Tracks, Layouts, Visits and optimised map images.
- Show Track, Layout, Marker and image counts in the restore confirmation screen.
- Longer term: offer a ZIP bundle containing a JSON manifest and separate image files.
- Allow an individual Layout to be exported as a portable package independently of the full database.
- Offer a printable PNG or PDF export for track walks, coaching and offline reference.

## Code organisation

Suggested structure inside the existing Kart Data repository:

```text
components/
└── track-map/
    ├── TrackLibrary.tsx
    ├── TrackWorkspace.tsx
    ├── MapCanvas.tsx
    ├── MapMarker.tsx
    ├── MarkerSheet.tsx
    ├── SessionOverlay.tsx
    └── FocusCard.tsx

lib/
└── track-map/
    ├── types.ts
    ├── database.ts
    ├── image-processing.ts
    ├── backup.ts
    └── coordinates.ts
```

The existing in-app `Screen` navigation can initially add Track Library and Track Workspace screens. The implementation should first extract reusable Track Map components rather than making the existing page component larger. Actual URL routes can be introduced later if shareable internal links become important.

## MVP scope

The smallest useful first release should include:

- Use `PF International - Full Layout` as the first real test Layout.
- Create, edit and delete Tracks and Layouts.
- Load the built-in PF International Full Layout schematic, or upload and optimise one authorised map image per other Layout.
- Add, move, edit and delete multiple marker types, including Corner, Braking, Turn-in, Apex and Exit. A corner does not need to use every marker type.
- Zoom and pan the map on mobile and desktop.
- General, dry and wet reference notes.
- Select a saved Layout when creating or editing an Event.
- Open **Track notes** from a Session.
- Add and edit Session-specific marker observations without changing permanent notes.
- Provide a Track Library shortcut on the home screen and full Track Library management in settings.
- View/Edit mode protection.
- Automatic local saving.
- Light and dark mode compatibility.
- Offline use after the app has loaded once.
- Full backup and restore including map images.

Do **not** include Run-specific observations, racing-line drawing, GPS, telemetry, collaboration or AI in the first release. The data model should allow them later, but they would slow down the first usable version.

## Phase 2

- Create Run-specific observations.
- Select up to three Next Run focus markers.
- Promote a successful observation into permanent reference knowledge.
- Filter map markers by Dry/Wet and marker type.
- Export a shareable or printable map image.

## Phase 3 possibilities

- Draw racing lines and braking zones.
- Separate dry and wet racing-line layers.
- Link onboard video URLs and timestamps to markers.
- Overlay MyChron/Alfano GPS traces.
- Compare two Event overlays.
- Optional cloud sync and read-only sharing.
- Voice debrief converted into marker observations.

## Important design safeguards

- Normal view must not allow markers to move accidentally.
- Delete actions require confirmation.
- Marker meaning must not depend only on colour.
- Track notes must remain usable offline.
- The built-in PF International schematic must keep its OpenStreetMap attribution and ODbL link; copyright for any user-supplied replacement map remains the user's responsibility.
- A failed image save must not damage existing Tracks, Layouts or notes.
- Backups must clearly report how many Tracks, Layouts, Markers and map images they contain.

## Confirmed implementation decisions

1. Build Track Map Notebook as an independent feature module inside the existing Kart Data website.
2. Use the generated OpenStreetMap-based `PF International - Full Layout` schematic as the first real circuit map; allow authorised replacement images.
3. Use the multi-marker scheme: Corner, Braking, Turn-in, Apex and Exit markers are supported, but none is mandatory for every corner.
4. Include map zoom and pan in version 1.
5. Put a Track Library shortcut on the home screen and its full management interface in settings.
6. Version 1 includes permanent reference notes and Session overlays. Run-specific observations remain out of scope until Phase 2.

The MVP is implemented in the Kart Data repository and deployed through GitHub `main` → Vercel. Legacy PF International Full Layout records without a map are migrated at startup.

## MVP success test

The first version is successful if the user can:

1. Create `PF International - Full Layout`.
2. See the built-in PF International map on an iPhone, with the option to replace it with an authorised track image.
3. Add at least ten useful markers without accidental movement.
4. Select that Layout for an Event and open **Track notes** from a Session.
5. Add a Session observation without changing the permanent reference note.
6. Close and reopen the app offline and see the same map and notes.
7. Export a backup, clear the test data, restore it and recover the complete map and Session overlay.
