# Connecting NRCC Berlin to Supabase

The site now pulls Squad, Schedule, and Gallery data live from Supabase instead
of hardcoded arrays in the HTML. The "Join the Rhinos" form also saves
applications into a Supabase table instead of just showing a fake success
message. This is what changed, and how to finish the setup.

## What changed in the code

| Page | Before | Now |
|---|---|---|
| `squad.html` | `const players = [...]` hardcoded array | fetches from the `players` table |
| `schedule.html` | `const fixtures = [...]` hardcoded array | fetches from the `fixtures` table |
| `gallery.html` | fake carousel + client-only "upload" (never saved) | fetches from the `gallery_photos` table |
| `index.html` | Join form just showed a success message | Join form inserts a row into `join_requests` |

New files:
- `js/supabase-config.js` — connection settings (you fill in 2 values)
- `supabase/schema.sql` — creates the 4 tables + security rules
- `supabase/seed_players.sql` — your existing 34 players, ready to import
- `supabase/seed_fixtures.sql` — your existing 11 fixtures, ready to import
- `supabase/seed_gallery.sql` — notes on adding your first gallery photos
- `scripts/upload-player-photos.js` — optional helper to bulk-upload `lib/players/*` photos

## Step 1 — Create the project

1. Go to [supabase.com/dashboard](https://supabase.com/dashboard) → **New project**
2. Name it `nrccberlin`, pick a region close to Berlin (e.g. `eu-central-1`), set a database password (save it somewhere).
3. Wait ~2 minutes for it to spin up.

## Step 2 — Create the tables

1. In the project, open **SQL Editor → New query**.
2. Paste in the contents of `supabase/schema.sql` and run it.
3. Then run `supabase/seed_players.sql` and `supabase/seed_fixtures.sql` the same way — this loads your current squad and match history so you don't have to retype anything.

## Step 3 — Create the storage buckets (for photos)

1. Go to **Storage** in the sidebar → **New bucket**
2. Create a bucket named exactly `player-photos` → toggle **Public bucket** ON → Create.
3. Create a second bucket named exactly `gallery-photos` → **Public bucket** ON → Create.

Then upload your existing player photos:
- Easiest: open the `player-photos` bucket in the dashboard and drag in all the files from `lib/players/` on your computer (skip the `README.md` in that folder).
- Or run the helper script from a terminal (uploads all of them in one go):
  ```
  npm install @supabase/supabase-js
  SUPABASE_URL=https://YOUR-PROJECT-REF.supabase.co SUPABASE_SERVICE_ROLE_KEY=your-service-role-key node scripts/upload-player-photos.js
  ```
  (Get the service role key from Project Settings → API. Only use it locally — never put it in the website's code.)

Since `seed_players.sql` already stores the same filenames (e.g. `awanish.png`) in each player's `photo_path`, the site will automatically show the right photo once the file exists in the bucket — no further steps needed.

## Step 4 — Connect the site to your project

1. In Supabase: **Project Settings → API**. Copy the **Project URL** and the **anon public** key.
2. Open `js/supabase-config.js` and replace the two placeholder values:
   ```js
   const SUPABASE_URL = "https://YOUR-PROJECT-REF.supabase.co";
   const SUPABASE_ANON_KEY = "YOUR-ANON-PUBLIC-KEY";
   ```
3. The anon key is safe to leave in the site's code — it can only do what the security rules in `schema.sql` allow (read squad/schedule/gallery, submit join applications). It cannot edit or delete anything.

## Step 5 — Redeploy

Commit and push the changed files, and redeploy on Vercel as usual (or drag-and-drop the folder if you're not using git). The site will now read live from Supabase.

## Day-to-day editing

Once it's connected, you make all updates in the Supabase dashboard — no code or redeploy needed, changes show up on refresh:

- **Squad** — Table Editor → `players`. Add a row for a new joiner, edit `role`/`captain`/`sort_order`, or delete a row when someone leaves. Upload their photo to the `player-photos` bucket and put the filename in `photo_path`.
- **Schedule** — Table Editor → `fixtures`. Add a row per match. Leave `result` empty for upcoming matches; set it to `win`/`loss`/`draw` afterwards.
- **Gallery** — organized by album/tournament, see below.
- **New joiners** — Table Editor → `join_requests`. Every submitted application appears here automatically (name, email, phone, role, message). Nobody but you can see this table — it's not exposed to the public site.

## About the gallery — organized by tournament/album

Instead of a database row per photo, the gallery groups photos by **album**
(usually one per tournament or event). Adding a batch of photos is two steps:

1. **Storage → gallery-photos** → create a folder named after the event
   (e.g. `chanda-surya-cup-2025`) and drop all the photos for it inside.
2. **Table Editor → gallery_albums** → add **one row**:
   - `slug` — must exactly match the folder name (e.g. `chanda-surya-cup-2025`)
   - `title` — what's shown on the site (e.g. "Chanda Surya Cup 2025")
   - `category` — optional label (e.g. `tournament`, `friendly`, `training`)
   - `sort_order` — controls ordering, lower shows first

Every photo inside that folder shows up automatically. Adding more photos to
an existing album later needs no database change — just drop more files into
the folder.

Run `supabase/gallery_albums_migration.sql` once to set this up (replaces the
earlier one-row-per-photo `gallery_photos` table, safe since it's still empty).


## About the public gallery "upload" button

The original gallery page had an upload button, but it never actually saved
anything anywhere — it just previewed the file in your own browser tab and
lost it on refresh. Since the site has no login system, I removed it rather
than leave something that looks functional but silently does nothing:
letting anonymous visitors write directly to your database/storage would
also mean anyone on the internet could add photos or spam the club's gallery.

If you'd like, I can build a simple password-protected admin page later so
you (specifically) can upload gallery photos and player photos directly from
the site instead of through the Supabase dashboard — just ask.
