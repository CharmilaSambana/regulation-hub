# Regulation Hub

A course-material portal where **faculty upload subject PDFs per academic regulation** and **students access exactly what applies to their batch** — with built-in view/download analytics and an admin overview of the whole system.

**Live app:** https://regulation-hub.lovable.app

## What it does

The app has three roles, each with its own dashboard:

### 🎓 Student
- Selects their regulation (`R25`, `R24`, `R23`, `R22`) — changeable any time
- Sees only the PDFs shared for that regulation, grouped by subject
- Searches materials by title, subject name, or subject code
- Views PDFs in an in-browser canvas viewer or downloads them
- Views/downloads are tracked per student so faculty can see reach

### 🧑‍🏫 Faculty
- Adds subjects they teach, each tied to a regulation and a required subject code
- Uploads PDFs (up to 20MB) against a subject, instantly visible to students on that regulation
- Sees a live bar chart of views and downloads per uploaded PDF, plus totals

### 🛡️ Admin
- Read-only dashboard restricted to the approved admin account
- Counts of registered students, registered faculty, PDFs uploaded, and students who engaged
- Searchable list of all materials with view/download counts
- Breakdown of PDFs uploaded per faculty member

### Auth
- Email/password sign-up and sign-in (Supabase Auth)
- Role selected at registration (student or faculty); admin access is restricted to a pre-approved email
- "Forgot password" flow that emails a reset link and lands on a dedicated reset-password page

## Tech stack

- **Framework:** TanStack Start (React 19 + TanStack Router, SSR)
- **Build tool:** Vite
- **Styling/UI:** Tailwind CSS v4, shadcn/ui (Radix primitives), lucide-react icons
- **Data & auth:** Supabase (Postgres, Auth, Storage, Row-Level Security)
- **State/data fetching:** TanStack Query
- **Forms/validation:** react-hook-form + Zod
- **Charts:** Recharts
- **PDF rendering:** pdfjs-dist (custom canvas viewer)
- **Package manager:** Bun

## Data model

Defined in `supabase/migrations/`:

- `profiles` — user profile (full name, selected regulation)
- `user_roles` — maps each user to `student` / `teacher` / `admin`
- `subjects` — subject name + code + regulation, owned by a faculty user
- `materials` — uploaded PDF metadata (title, storage path, subject, regulation, uploader)
- `material_events` — per-student view/download events, used for analytics

Row-Level Security policies scope what each role can read/write; PDF files live in Supabase Storage and are served through signed URLs plus a same-origin proxy route (`src/routes/api/public/material-proxy.ts`) for reliable in-browser rendering.

## Getting started

### Prerequisites
- [Bun](https://bun.sh) (or Node.js + npm)
- A [Supabase](https://supabase.com) project

### Setup

```sh
git clone https://github.com/rajeshmarrapu68/regulation-hub.git
cd regulation-hub
bun install
```

Create a `.env` file in the project root:

```
VITE_SUPABASE_URL=your-supabase-project-url
VITE_SUPABASE_PUBLISHABLE_KEY=your-supabase-anon-key
VITE_SUPABASE_PROJECT_ID=your-supabase-project-id
```

Apply the database schema by running the SQL files in `supabase/migrations/` against your Supabase project (via the Supabase SQL editor or the Supabase CLI).

### Run locally

```sh
bun run dev      # start the dev server
bun run build    # production build
bun run preview  # preview the production build
bun run lint      # lint
bun run format    # format with Prettier
```
