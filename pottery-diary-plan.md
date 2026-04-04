# Pottery Diary — Project Plan

> Status: Draft (pending answers to open questions)
> Last updated: 2026-03-30

---

## Overview

A Flutter mobile app for potters to document each piece across three lifecycle stages — trimmed, bisque-fired, and glaze-fired — with photos, descriptions, and glaze combinations.

---

## Open Questions (blocking full plan)

| # | Question | Impact |
|---|----------|--------|
| 1 | iOS only, Android only, or both? | CI/CD, deployment |
| 2 | Single-user or multi-user with accounts? | Auth, data model |
| 3 | Local storage only or cloud sync? | Backend choice |
| 4 | If cloud — Firebase, Supabase, or custom? | M4+ architecture |
| 5 | Glazes: managed catalog or free-text per entry? | Data model complexity |
| 6 | Multiple glazes per piece? Per zone? | Glaze data model |
| 7 | Multiple photos per stage, or one? | Storage, UI |
| 8 | Record kiln settings (temp, cone, schedule)? | Data model |
| 9 | Search / filter by glaze, date, etc.? | M5 scope |
| 10 | Share or export (PDF, social)? | M6 scope |
| 11 | State management preference? (Riverpod / BLoC / Provider) | Architecture |

---

## Core Data Model (draft)

```
Piece
  ├── id
  ├── title
  ├── createdAt
  ├── glazes[]         → GlazeCombination
  └── stages[]
        ├── StageType  (trimmed | bisque | glaze_fired)
        ├── description
        ├── photos[]
        │     ├── url / local path
        │     └── caption
        └── recordedAt

GlazeCombination
  ├── id
  ├── name
  └── glazes[]         → Glaze (if catalog) or string (if free-text)

Glaze  (if catalog)
  ├── id
  ├── name
  ├── brand
  └── notes
```

---

## Milestones & Stages

### M1 — Foundation (Week 1–2)
> Goal: Project scaffolding, data model, local storage wired up.

- [ ] 1.1 Set up Flutter project, folder structure, linting rules
- [ ] 1.2 Choose and configure state management (pending Q11)
- [ ] 1.3 Define data models (`Piece`, `Stage`, `Photo`, `Glaze`)
- [ ] 1.4 Set up local database (SQLite via `drift` or `isar`)
- [ ] 1.5 Implement CRUD repository layer for `Piece`
- [ ] 1.6 Write unit tests for repository layer

---

### M2 — Piece Management UI (Week 2–3)
> Goal: Users can create, view, edit, and delete pottery pieces.

- [ ] 2.1 Home screen — piece list with thumbnail and status badge
- [ ] 2.2 Create piece flow — title, initial description
- [ ] 2.3 Piece detail screen — shows all 3 stages with status indicators
- [ ] 2.4 Edit / delete piece
- [ ] 2.5 Empty state and basic onboarding copy

---

### M3 — Stage Recording (Week 3–4)
> Goal: Users can fill in each of the 3 stages with description and track progress.

- [ ] 3.1 Stage entry form — description text input
- [ ] 3.2 Stage status logic (locked until previous stage complete, or free-form?)
- [ ] 3.3 Stage completion toggle / timestamp
- [ ] 3.4 Stage history view within piece detail

---

### M4 — Photo Upload (Week 4–5)
> Goal: Users can attach photos to each stage.

- [ ] 4.1 Camera capture integration (`image_picker`)
- [ ] 4.2 Photo gallery picker
- [ ] 4.3 Local photo storage and display
- [ ] 4.4 Photo caption input
- [ ] 4.5 Photo grid / carousel per stage
- [ ] 4.6 Delete photo

---

### M5 — Glaze Management (Week 5–6)
> Goal: Users can associate glazes with a piece (scope depends on Q5–Q6).

**Option A — Free-text (simpler)**
- [ ] 5A.1 Free-text glaze field on piece
- [ ] 5A.2 Multiple glaze tags with add/remove UI

**Option B — Catalog (richer)**
- [ ] 5B.1 Glaze catalog screen — create, edit, delete glazes
- [ ] 5B.2 Associate glazes from catalog to a piece
- [ ] 5B.3 View all pieces using a specific glaze

---

### M6 — Search & Filter (Week 6–7)
> Scope depends on Q9. Can be deferred post-MVP.

- [ ] 6.1 Full-text search on piece title and description
- [ ] 6.2 Filter by stage status (in-progress / complete)
- [ ] 6.3 Filter by glaze
- [ ] 6.4 Sort by date created / last updated

---

### M7 — Cloud Sync & Auth (Week 7–9)
> Scope depends on Q2–Q4. Can be deferred post-MVP.

- [ ] 7.1 Auth (email/password or Google Sign-In)
- [ ] 7.2 Remote database setup (Firebase / Supabase)
- [ ] 7.3 Sync local records to cloud on change
- [ ] 7.4 Conflict resolution strategy
- [ ] 7.5 Photo upload to cloud storage

---

### M8 — Polish & Release (Week 9–10)
> Goal: App store ready.

- [ ] 8.1 App icon, splash screen, theme
- [ ] 8.2 Onboarding flow (first-run walkthrough)
- [ ] 8.3 Error states, loading states, empty states audit
- [ ] 8.4 Accessibility pass (contrast, touch targets)
- [ ] 8.5 Performance profiling (image loading, list scroll)
- [ ] 8.6 App Store / Play Store submission prep
- [ ] 8.7 Beta testing (TestFlight / Firebase App Distribution)

---

## MVP Scope (recommended)

Ship M1 → M5 as v1.0. Everything else is v1.x or v2.

| Feature | MVP |
|---------|-----|
| 3-stage piece tracking | Yes |
| Photos per stage | Yes |
| Descriptions per stage | Yes |
| Glaze association (free-text) | Yes |
| Glaze catalog | No (v1.1) |
| Search & filter | No (v1.1) |
| Cloud sync | No (v2) |
| Export / share | No (v2) |

---

## Tech Stack (draft)

| Layer | Choice | Notes |
|-------|--------|-------|
| Framework | Flutter | Confirmed |
| State mgmt | TBD | Riverpod recommended |
| Local DB | Drift (SQLite) | Type-safe, tested |
| Photo storage | Local filesystem | `path_provider` |
| Cloud (if needed) | Firebase or Supabase | TBD |
| CI/CD | GitHub Actions | Fastlane for store delivery |

---

*Answers to open questions will trigger updates to M5–M7 scope and tech stack.*
