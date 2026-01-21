-- Migration: Cleanup and Consolidate Categories (Text ID Version)
-- FIXES: "invalid input syntax for type uuid" error
-- Actions:
-- 1. Drops old categories table (to switch from UUID to TEXT id if needed)
-- 2. Recreates it with readable IDs (research, cosmetic, etc)
-- 3. Updates products to match

-- 1. Drop existing table (Cascade to handle foreign keys temporarily)
DROP TABLE IF EXISTS categories CASCADE;

-- 2. Recreate with TEXT ID (slugs)
CREATE TABLE categories (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  icon TEXT, -- kept as column but will be NULL
  sort_order INTEGER DEFAULT 0,
  active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 3. Insert Clean Categories (No Icons)
INSERT INTO categories (id, name, sort_order, active, icon) VALUES
('research', 'Research & Weight Management', 1, true, NULL),
('cosmetic', 'Cosmetic & Anti-Aging', 2, true, NULL),
('performance', 'Performance & Longevity', 3, true, NULL),
('healing', 'Healing & Recovery', 4, true, NULL);

-- 4. Update existing products to map to new Categories
-- We need to ensure products table is loose enough or we update it first
-- If products.category was UUID, we might need to alter it too. 
-- Usually in Supabase 'products.category' is just a reference. 

-- Let's attempt to update the text values. 
-- If products.category is strictly UUID, this might fail, so let's ALTER it to TEXT first just in case.
ALTER TABLE products ALTER COLUMN category TYPE TEXT;

-- Update Mappings
UPDATE products SET category = 'research' WHERE category = 'weight-management' OR category = 'research';
UPDATE products SET category = 'research' WHERE name ILIKE '%Tirzepatide%';
UPDATE products SET category = 'research' WHERE name ILIKE '%Semaglutide%';
UPDATE products SET category = 'research' WHERE name ILIKE '%Retatrutide%';
UPDATE products SET category = 'research' WHERE name ILIKE '%Tesamorelin%';
UPDATE products SET category = 'research' WHERE name ILIKE '%Cagrilintide%';
UPDATE products SET category = 'research' WHERE name ILIKE '%Mazdutide%';

UPDATE products SET category = 'cosmetic' WHERE category = 'anti-aging';
UPDATE products SET category = 'cosmetic' WHERE name ILIKE '%Lemon Bottle%';
UPDATE products SET category = 'cosmetic' WHERE name ILIKE '%GHK-Cu%';
UPDATE products SET category = 'cosmetic' WHERE name ILIKE '%Snap8%';
UPDATE products SET category = 'cosmetic' WHERE name ILIKE '%Epitalon%';
UPDATE products SET category = 'cosmetic' WHERE name ILIKE '%Klow%';

UPDATE products SET category = 'performance' WHERE category = 'wellness';
UPDATE products SET category = 'performance' WHERE name ILIKE '%NAD+%';
UPDATE products SET category = 'performance' WHERE name ILIKE '%MOTS-c%';
UPDATE products SET category = 'performance' WHERE name ILIKE '%AOD%';
UPDATE products SET category = 'performance' WHERE name ILIKE '%SS-31%';

UPDATE products SET category = 'healing' WHERE category = 'recovery';
UPDATE products SET category = 'healing' WHERE name ILIKE '%BPC-157%';
UPDATE products SET category = 'healing' WHERE name ILIKE '%TB-500%';
UPDATE products SET category = 'healing' WHERE name ILIKE '%Thymosin%';
UPDATE products SET category = 'healing' WHERE name ILIKE '%ARA-290%';
UPDATE products SET category = 'healing' WHERE name ILIKE '%KPV%';


-- 5. Restore Foreign Key (Optional, but good for integrity)
-- Now that both sides are TEXT, we can link them.
ALTER TABLE products 
ADD CONSTRAINT fk_products_category 
FOREIGN KEY (category) 
REFERENCES categories(id) 
ON DELETE SET NULL;
