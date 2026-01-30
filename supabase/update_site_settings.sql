INSERT INTO site_settings (id, value, type, updated_at)
VALUES
  ('site_name', 'Slender Glow', 'string', NOW()),
  ('site_logo', '/logo.png', 'string', NOW()),
  ('hero_description', 'Slender Glow provides research-grade peptides engineered for precision, purity, and consistency.', 'string', NOW())
ON CONFLICT (id) DO UPDATE
SET
  value = EXCLUDED.value,
  updated_at = NOW();
