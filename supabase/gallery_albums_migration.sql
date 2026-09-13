-- ============================================================
-- Gallery redesign: organize photos by tournament/album folder
-- instead of one database row per photo.
--
-- Run this in Supabase SQL Editor. Safe to run even though
-- gallery_photos currently has 0 rows.
-- ============================================================

drop table if exists gallery_photos;

create table if not exists gallery_albums (
  id uuid primary key default gen_random_uuid(),
  slug text not null unique,     -- must exactly match the folder name inside
                                  -- the "gallery-photos" storage bucket, e.g. "chanda-surya-cup-2025"
  title text not null,           -- shown on the site, e.g. "Chanda Surya Cup 2025"
  category text,                 -- optional label, e.g. "tournament" | "friendly" | "training"
  sort_order int not null default 0,
  created_at timestamptz not null default now()
);

alter table gallery_albums enable row level security;

create policy "Public can read gallery_albums" on gallery_albums
  for select using (true);

-- Example — after you've created a folder called "chanda-surya-cup-2025" in the
-- gallery-photos bucket and dropped photos into it, add ONE row for the whole album:
--
-- insert into gallery_albums (slug, title, category, sort_order) values
--   ('chanda-surya-cup-2025', 'Chanda Surya Cup 2025', 'tournament', 1);
