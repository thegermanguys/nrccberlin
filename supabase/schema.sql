-- ============================================================
-- NRCC Berlin — Supabase schema
-- Run this once in: Supabase Dashboard → SQL Editor → New query
-- Project: nrccberlin
-- ============================================================

-- Needed for gen_random_uuid()
create extension if not exists pgcrypto;

-- ---------- SQUAD ----------
create table if not exists players (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  role text not null check (role in ('Batsman','Bowler','All-Rounder','Wicketkeeper')),
  emoji text default '🏏',
  captain boolean not null default false,
  photo_path text,               -- filename inside the "player-photos" storage bucket, e.g. "awanish.png". Leave null for the emoji fallback.
  sort_order int not null default 0,
  created_at timestamptz not null default now()
);

-- ---------- SCHEDULE / FIXTURES ----------
create table if not exists fixtures (
  id uuid primary key default gen_random_uuid(),
  match_date date not null,
  match_time text,              -- free text, e.g. "14:00"
  home_team text not null default 'NRCC Berlin',
  away_team text not null,
  venue text,
  type text not null default 'friendly',   -- friendly | league | cup | tournament name
  result text check (result in ('win','loss','draw') or result is null),
  score text,
  sort_order int not null default 0,
  created_at timestamptz not null default now()
);

-- ---------- GALLERY ----------
create table if not exists gallery_photos (
  id uuid primary key default gen_random_uuid(),
  photo_path text not null,     -- filename inside the "gallery-photos" storage bucket, e.g. "final-2025.jpg"
  caption text,
  category text,                -- e.g. match | tournament | training | celebration | community
  sort_order int not null default 0,
  created_at timestamptz not null default now()
);

-- ---------- NEW JOINERS (Join Us form submissions) ----------
create table if not exists join_requests (
  id uuid primary key default gen_random_uuid(),
  first_name text not null,
  last_name text not null,
  email text not null,
  phone text,
  playing_role text,
  experience text,
  message text,
  status text not null default 'new',   -- new | contacted | joined | declined
  created_at timestamptz not null default now()
);

-- ============================================================
-- ROW LEVEL SECURITY
-- Public site: can READ players / fixtures / gallery_photos,
-- and can INSERT (only) into join_requests.
-- Everything else (edits, deletes, reading applications) is done
-- by you, signed in to the Supabase dashboard, which bypasses RLS.
-- ============================================================

alter table players enable row level security;
alter table fixtures enable row level security;
alter table gallery_photos enable row level security;
alter table join_requests enable row level security;

create policy "Public can read players" on players
  for select using (true);

create policy "Public can read fixtures" on fixtures
  for select using (true);

create policy "Public can read gallery_photos" on gallery_photos
  for select using (true);

create policy "Public can submit join requests" on join_requests
  for insert with check (true);

-- No select/update/delete policies are created for anon on any table above,
-- so the public site cannot edit data or read join_requests — only you can,
-- via the Supabase dashboard (Table Editor / SQL Editor).
