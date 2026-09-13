// ============================================================
// NRCC Berlin — Supabase connection
// Fill these in from: Supabase Dashboard → Project Settings → API
// SUPABASE_URL   = "Project URL"
// SUPABASE_ANON_KEY = "anon public" key (safe to expose in client code —
//                      it can ONLY do what the RLS policies in schema.sql allow)
// ============================================================
const SUPABASE_URL = "sb_publishable_00jBmgY7osTCEIJ9TrjKug_Wh_Xem_I";
const SUPABASE_ANON_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZhaHlxeWZtZGtmcnZhcWV2aHljIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODkzMjE1NTAsImV4cCI6MjEwNDg5NzU1MH0.ANg84e53CZBkAO8_vXcCh0Pj6Ll0toS7VQNn-PZ8ENg";

const supabaseClient = window.supabase.createClient(SUPABASE_URL, SUPABASE_ANON_KEY);

// Helper: turn a storage filename into a public URL
function playerPhotoUrl(path) {
  if (!path) return null;
  return supabaseClient.storage.from('player-photos').getPublicUrl(path).data.publicUrl;
}
function galleryPhotoUrl(path) {
  if (!path) return null;
  return supabaseClient.storage.from('gallery-photos').getPublicUrl(path).data.publicUrl;
}
