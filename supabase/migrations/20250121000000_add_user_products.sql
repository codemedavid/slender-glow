-- Migration: Add User Requested Products
-- Clears existing products and adds the specific list provided by the user

-- 1. Clear existing products to ensure clean slate
DELETE FROM product_variations;
DELETE FROM products;

-- 2. Insert Products
-- Categories: 'research' (Growth), 'cosmetic' (Anti-Aging), 'performance' (Athletic), 'healing' (Recovery), 'cognitive' (Brain)
-- Using 'research' for general supplies/accessories as they don't fit perfectly elsewhere, or 'healing' if appropriate.

INSERT INTO products (name, description, category, base_price, purity_percentage, available, featured, stock_quantity, storage_conditions) VALUES
-- Weight Management / GLP-1 (Research)
('Tirzepatide', 'GLP-1/GIP receptor agonist. Research use only.', 'research', 2500.00, 99.5, true, true, 100, 'Store at -20°C'),
('Semaglutide', 'GLP-1 receptor agonist. Research use only.', 'research', 2000.00, 99.0, true, true, 100, 'Store at -20°C'),
('Retatrutide (Reta)', 'Triple agonist (GLP-1, GIP, Glucagon). Research use only.', 'research', 3000.00, 99.0, true, true, 50, 'Store at -20°C'),
('Cagrilintide', 'Research compound typically studied with GLP-1 agonists.', 'research', 2800.00, 99.0, true, true, 50, 'Store at -20°C'),
('Mazdutide', 'GLP-1/Glucagon receptor dual agonist. Research use only.', 'research', 2900.00, 99.0, true, false, 40, 'Store at -20°C'),
('AOD-9604', 'Anti-Obesity Drug fragment of HGH residue 177-191.', 'performance', 1500.00, 99.0, true, false, 80, 'Store at -20°C'),
('5-Amino-1MQ', 'Membrane-permeable small molecule inhibitor of NNMT.', 'performance', 3500.00, 98.0, true, true, 30, 'Store at room temp'),
('Tesamorelin', 'GHRH analog. Research use only.', 'research', 2200.00, 99.0, true, false, 40, 'Store at -20°C'),

-- Cosmetic / Anti-Aging
('Lipo C B12', 'Lipotropic blend with Vitamin B12.', 'cosmetic', 1800.00, 98.0, true, true, 60, 'Store at room temp'),
('Lemon Bottle', 'Advanced solution for research applications.', 'cosmetic', 4500.00, 99.0, true, true, 100, 'Store at room temp'),
('Ghk-cu', 'Copper peptide complex.', 'cosmetic', 1200.00, 99.0, true, false, 75, 'Store at -20°C'),
('Epitalon', 'Synthetic tetrapeptide. Anti-aging research.', 'cosmetic', 1400.00, 99.0, true, false, 40, 'Store at -20°C'),
('Klow', 'Premium proprietary research blend.', 'cosmetic', 1600.00, 99.0, true, true, 50, 'Store at -20°C'),
('Glow Blend', 'Specialized research blend for aesthetic applications.', 'cosmetic', 1700.00, 99.0, true, true, 50, 'Store at -20°C'),
('Snap8', 'Octapeptide. Research use only.', 'cosmetic', 1100.00, 98.0, true, false, 40, 'Store at -20°C'),

-- Performance / Cellular Health
('NAD+', 'Nicotinamide Adenine Dinucleotide.', 'performance', 1600.00, 99.5, true, true, 80, 'Store at -20°C'),
('SS-31', 'Mitochondrial targeted peptide.', 'healing', 2400.00, 99.0, true, false, 30, 'Store at -20°C'),
('MOTS-c', 'Mitochondrial derived peptide.', 'performance', 1900.00, 98.5, true, false, 40, 'Store at -20°C'),
('GTT', 'Glucose Tolerance Test Solution / Research Compound.', 'research', 800.00, 99.0, true, false, 50, 'Store at room temp'),

-- Healing / Recovery
('Thymosin Alpha-1', 'Peptide fragment. Immune system research.', 'healing', 1800.00, 99.0, true, false, 40, 'Store at -20°C'),
('ARA-290', 'Erythropoietin derivative. Research use only.', 'healing', 2100.00, 99.0, true, false, 30, 'Store at -20°C'),
('KPV', 'C-terminal fragment of alpha-MSH.', 'healing', 1300.00, 99.0, true, false, 40, 'Store at -20°C'),

-- Supplies / Accessories (Mapped to applicable categories)
('Disposable Pen', 'Injector pen for research administration.', 'research', 500.00, 100.0, true, true, 200, 'Store at room temp'),
('Cartridge Sterilized', 'Empty sterilized cartridge.', 'research', 150.00, 100.0, true, true, 500, 'Store at room temp'),
('Pen Needles', 'Sterile pen needles.', 'research', 50.00, 100.0, true, true, 1000, 'Store at room temp'),
('Cartridge Purger Tray', 'Accessory for cartridge preparation.', 'research', 300.00, 100.0, true, false, 50, 'Store at room temp'),
('Candy Pen', 'Specialized research pen.', 'research', 600.00, 100.0, true, true, 50, 'Store at room temp'),
('V1', 'Premium research accessory.', 'research', 700.00, 100.0, true, false, 30, 'Store at room temp'),
('Hospital Grade Water USP 10ml', 'Sterile water for injection/reconstitution.', 'research', 200.00, 100.0, true, true, 300, 'Store at room temp');


-- 3. Insert Product Variations (Sizes/Dosages)

-- Tirzepatide (15mg, 20mg, 30mg)
INSERT INTO product_variations (product_id, name, quantity_mg, price, stock_quantity)
SELECT id, '15mg', 15.0, 2500.00, 50 FROM products WHERE name = 'Tirzepatide'
UNION ALL
SELECT id, '20mg', 20.0, 3200.00, 50 FROM products WHERE name = 'Tirzepatide'
UNION ALL
SELECT id, '30mg', 30.0, 4500.00, 50 FROM products WHERE name = 'Tirzepatide';

-- Semaglutide (15mg, 30mg)
INSERT INTO product_variations (product_id, name, quantity_mg, price, stock_quantity)
SELECT id, '15mg', 15.0, 2000.00, 50 FROM products WHERE name = 'Semaglutide'
UNION ALL
SELECT id, '30mg', 30.0, 3500.00, 50 FROM products WHERE name = 'Semaglutide';

-- Retatrutide (15mg, 30mg)
INSERT INTO product_variations (product_id, name, quantity_mg, price, stock_quantity)
SELECT id, '15mg', 15.0, 3000.00, 40 FROM products WHERE name = 'Retatrutide (Reta)'
UNION ALL
SELECT id, '30mg', 30.0, 5500.00, 40 FROM products WHERE name = 'Retatrutide (Reta)';

-- NAD+ (100mg, 500mg)
INSERT INTO product_variations (product_id, name, quantity_mg, price, stock_quantity)
SELECT id, '100mg', 100.0, 1600.00, 50 FROM products WHERE name = 'NAD+'
UNION ALL
SELECT id, '500mg', 500.0, 3000.00, 50 FROM products WHERE name = 'NAD+';

-- GHK-Cu (50mg, 100mg)
INSERT INTO product_variations (product_id, name, quantity_mg, price, stock_quantity)
SELECT id, '50mg', 50.0, 1200.00, 50 FROM products WHERE name = 'Ghk-cu'
UNION ALL
SELECT id, '100mg', 100.0, 2000.00, 50 FROM products WHERE name = 'Ghk-cu';

-- AOD (5mg) - Add single variation to match user request "AOD 5mg"
INSERT INTO product_variations (product_id, name, quantity_mg, price, stock_quantity)
SELECT id, '5mg', 5.0, 1500.00, 50 FROM products WHERE name = 'AOD-9604';

-- No specific variations for others listed without multiple sizes in prompt, 
-- but base item exists.
