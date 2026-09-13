-- Seed data generated from the original hardcoded schedule.html array.
-- Dates assume the 2025 season mentioned in the page hero — adjust years in the
-- Supabase Table Editor afterwards if any of these should be a different year.
-- Run in Supabase SQL Editor AFTER schema.sql, once (re-running would duplicate rows).

insert into fixtures (match_date, home_team, away_team, venue, type, result, sort_order) values
  ('2025-05-01', 'NRCC Berlin', 'NSCA Hamburg', 'Hamburg', 'friendly', 'win', 1),
  ('2025-05-30', 'NRCC Berlin', 'NDCC', 'Ziegelbusch Cricket Ground Darmstadt', 'NRNA Tournament', 'loss', 2),
  ('2025-05-30', 'NRCC Berlin', 'NCT Giessen', 'Ziegelbusch Cricket Ground Darmstadt', 'NRNA Tournament', 'win', 3),
  ('2025-06-14', 'NRCC Berlin', 'Berlin Mavericks', 'Fussballplatz Borsigpark', 'friendly', 'loss', 4),
  ('2025-06-14', 'NRCC Berlin', 'Berlin Mavericks', 'Fussballplatz Borsigpark', 'friendly', 'win', 5),
  ('2025-06-14', 'NRCC Berlin', 'Berlin Mavericks', 'Fussballplatz Borsigpark', 'friendly', 'win', 6),
  ('2025-06-21', 'NRCC Berlin', 'Berlin Mavericks', 'Paracelsus bad', 'friendly', 'loss', 7),
  ('2025-07-12', 'NRCC Berlin', 'Berlin Mavericks', 'Rehberge', 'friendly', 'win', 8),
  ('2025-07-12', 'NRCC Berlin', 'Berlin Mavericks', 'Rehberge', 'friendly', 'win', 9),
  ('2025-07-12', 'NRCC Berlin', 'Berlin Mavericks', 'Rehberge', 'friendly', 'win', 10),
  ('2025-07-19', 'NRCC Berlin', 'NSNRW', 'Soest', 'Chanda Surya Cup 2.0', 'loss', 11);
