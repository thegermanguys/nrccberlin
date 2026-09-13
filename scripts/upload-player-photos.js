#!/usr/bin/env node
/**
 * One-off helper: uploads every image in lib/players/ to the
 * "player-photos" Supabase storage bucket, so you don't have to
 * drag-and-drop 30+ files by hand.
 *
 * Setup:
 *   1. npm install @supabase/supabase-js
 *   2. Get your PROJECT URL + service_role key from:
 *      Supabase Dashboard → Project Settings → API
 *      (service_role key — NOT the anon key — this script needs write access
 *      and must only ever be run locally, never shipped to the browser)
 *   3. Run:
 *      SUPABASE_URL=https://xxxx.supabase.co SUPABASE_SERVICE_ROLE_KEY=xxxx node scripts/upload-player-photos.js
 */
const fs = require('fs');
const path = require('path');
const { createClient } = require('@supabase/supabase-js');

const SUPABASE_URL = process.env.SUPABASE_URL;
const SUPABASE_SERVICE_ROLE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY;

if (!SUPABASE_URL || !SUPABASE_SERVICE_ROLE_KEY) {
  console.error('Set SUPABASE_URL and SUPABASE_SERVICE_ROLE_KEY environment variables first.');
  process.exit(1);
}

const supabase = createClient(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY);
const dir = path.join(__dirname, '..', 'lib', 'players');
const bucket = 'player-photos';

async function main() {
  const files = fs.readdirSync(dir).filter(f => /\.(png|jpe?g|webp)$/i.test(f));
  console.log(`Found ${files.length} images in lib/players/`);

  for (const file of files) {
    const filePath = path.join(dir, file);
    const fileBuffer = fs.readFileSync(filePath);
    const ext = path.extname(file).slice(1).toLowerCase();
    const contentType = ext === 'png' ? 'image/png' : ext === 'webp' ? 'image/webp' : 'image/jpeg';

    const { error } = await supabase.storage
      .from(bucket)
      .upload(file, fileBuffer, { contentType, upsert: true });

    if (error) console.error(`✗ ${file}:`, error.message);
    else console.log(`✓ ${file}`);
  }
  console.log('Done. Filenames uploaded match what\'s already in supabase/seed_players.sql,');
  console.log('so once you run that seed file the site will pick the photos up automatically.');
}

main();
