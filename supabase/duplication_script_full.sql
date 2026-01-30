-- ============================================================================
-- PEPTIDE PULSE / SLENDER GLOW - FULL PROJECT DUPLICATION SCRIPT
-- Generated: 2026-01-29
-- This script combines the Master Replication Script with subsequent migrations
-- to reproduce the latest state of the database schema and seed data.
-- ============================================================================

-- ============================================================================
-- PART 1: MASTER REPLICATION SCRIPT (Base Schema & Initial Data)
-- ============================================================================

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- TABLES

CREATE TABLE IF NOT EXISTS public.categories (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    name TEXT NOT NULL,
    icon TEXT,
    sort_order INTEGER DEFAULT 0,
    active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);
ALTER TABLE public.categories DISABLE ROW LEVEL SECURITY;
GRANT ALL ON TABLE public.categories TO anon, authenticated, service_role;

CREATE TABLE IF NOT EXISTS public.products (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    name TEXT NOT NULL,
    description TEXT,
    category TEXT DEFAULT 'Uncategorized',
    base_price DECIMAL(10, 2) NOT NULL DEFAULT 0,
    discount_price DECIMAL(10, 2),
    discount_start_date TIMESTAMP WITH TIME ZONE,
    discount_end_date TIMESTAMP WITH TIME ZONE,
    discount_active BOOLEAN DEFAULT false,
    purity_percentage DECIMAL(5, 2) DEFAULT 99.0,
    molecular_weight TEXT,
    cas_number TEXT,
    sequence TEXT,
    storage_conditions TEXT DEFAULT 'Store at -20°C',
    inclusions TEXT[],
    stock_quantity INTEGER DEFAULT 0,
    available BOOLEAN DEFAULT true,
    featured BOOLEAN DEFAULT false,
    image_url TEXT,
    safety_sheet_url TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);
ALTER TABLE public.products DISABLE ROW LEVEL SECURITY;
GRANT ALL ON TABLE public.products TO anon, authenticated, service_role;

CREATE TABLE IF NOT EXISTS public.product_variations (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    product_id UUID REFERENCES public.products(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    quantity_mg DECIMAL(10, 2) NOT NULL DEFAULT 0,
    price DECIMAL(10, 2) NOT NULL DEFAULT 0,
    discount_price DECIMAL(10, 2),
    discount_active BOOLEAN DEFAULT false,
    stock_quantity INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);
ALTER TABLE public.product_variations DISABLE ROW LEVEL SECURITY;
GRANT ALL ON TABLE public.product_variations TO anon, authenticated, service_role;

CREATE TABLE IF NOT EXISTS public.site_settings (
    id TEXT PRIMARY KEY,
    value TEXT NOT NULL,
    type TEXT NOT NULL DEFAULT 'text',
    description TEXT,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
ALTER TABLE public.site_settings DISABLE ROW LEVEL SECURITY;
GRANT ALL ON TABLE public.site_settings TO anon, authenticated, service_role;

DROP TRIGGER IF EXISTS update_site_settings_updated_at ON public.site_settings;
CREATE TRIGGER update_site_settings_updated_at
    BEFORE UPDATE ON public.site_settings
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TABLE IF NOT EXISTS public.payment_methods (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    name TEXT NOT NULL,
    account_number TEXT,
    account_name TEXT,
    qr_code_url TEXT,
    active BOOLEAN DEFAULT true,
    sort_order INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);
ALTER TABLE public.payment_methods DISABLE ROW LEVEL SECURITY;
GRANT ALL ON TABLE public.payment_methods TO anon, authenticated, service_role;

CREATE TABLE IF NOT EXISTS public.shipping_locations (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    fee NUMERIC(10,2) NOT NULL DEFAULT 0,
    is_active BOOLEAN NOT NULL DEFAULT true,
    order_index INTEGER NOT NULL DEFAULT 1,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
ALTER TABLE public.shipping_locations DISABLE ROW LEVEL SECURITY;
GRANT ALL ON TABLE public.shipping_locations TO anon, authenticated, service_role;

CREATE TABLE IF NOT EXISTS public.couriers (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    code TEXT NOT NULL UNIQUE,
    name TEXT NOT NULL,
    tracking_url_template TEXT,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
ALTER TABLE public.couriers DISABLE ROW LEVEL SECURITY;
GRANT ALL ON TABLE public.couriers TO anon, authenticated, service_role;

CREATE TABLE IF NOT EXISTS public.promo_codes (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    code TEXT NOT NULL UNIQUE,
    discount_type TEXT NOT NULL CHECK (discount_type IN ('percentage', 'fixed')),
    discount_value DECIMAL(10, 2) NOT NULL,
    min_purchase_amount DECIMAL(10, 2) DEFAULT 0,
    max_discount_amount DECIMAL(10, 2),
    start_date TIMESTAMP WITH TIME ZONE,
    end_date TIMESTAMP WITH TIME ZONE,
    usage_limit INTEGER,
    usage_count INTEGER DEFAULT 0,
    active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
ALTER TABLE public.promo_codes DISABLE ROW LEVEL SECURITY;
GRANT ALL ON TABLE public.promo_codes TO anon, authenticated, service_role;

CREATE TABLE IF NOT EXISTS public.orders (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    customer_name TEXT NOT NULL,
    customer_email TEXT NOT NULL,
    customer_phone TEXT NOT NULL,
    contact_method TEXT DEFAULT 'phone',
    shipping_address TEXT NOT NULL,
    shipping_city TEXT,
    shipping_state TEXT,
    shipping_zip_code TEXT,
    shipping_country TEXT DEFAULT 'Philippines',
    shipping_barangay TEXT,
    shipping_region TEXT,
    shipping_location TEXT,
    courier_id UUID,
    shipping_fee DECIMAL(10, 2) DEFAULT 0,
    order_items JSONB NOT NULL,
    subtotal DECIMAL(10, 2),
    total_price DECIMAL(10, 2) NOT NULL,
    pricing_mode TEXT DEFAULT 'PHP',
    payment_method_id TEXT,
    payment_method_name TEXT,
    payment_status TEXT DEFAULT 'pending',
    payment_proof_url TEXT,
    promo_code_id UUID REFERENCES public.promo_codes(id),
    promo_code TEXT,
    discount_applied DECIMAL(10, 2) DEFAULT 0,
    order_status TEXT DEFAULT 'new',
    notes TEXT,
    admin_notes TEXT,
    tracking_number TEXT,
    tracking_courier TEXT,
    shipping_provider TEXT,
    shipping_note TEXT,
    shipped_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_orders_customer_email ON public.orders(customer_email);
CREATE INDEX IF NOT EXISTS idx_orders_customer_phone ON public.orders(customer_phone);
CREATE INDEX IF NOT EXISTS idx_orders_order_status ON public.orders(order_status);
CREATE INDEX IF NOT EXISTS idx_orders_created_at ON public.orders(created_at DESC);
ALTER TABLE public.orders DISABLE ROW LEVEL SECURITY;
GRANT ALL ON TABLE public.orders TO anon, authenticated, service_role;

DROP TRIGGER IF EXISTS update_orders_updated_at ON public.orders;
CREATE TRIGGER update_orders_updated_at
    BEFORE UPDATE ON public.orders
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TABLE IF NOT EXISTS public.coa_reports (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    product_name TEXT NOT NULL,
    batch TEXT,
    test_date DATE NOT NULL,
    purity_percentage DECIMAL(5,3) NOT NULL,
    quantity TEXT NOT NULL,
    task_number TEXT NOT NULL,
    verification_key TEXT NOT NULL,
    image_url TEXT NOT NULL,
    featured BOOLEAN DEFAULT false,
    manufacturer TEXT DEFAULT 'Peptide Pulse',
    laboratory TEXT DEFAULT 'Janoshik Analytical',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
ALTER TABLE public.coa_reports DISABLE ROW LEVEL SECURITY;
GRANT ALL ON TABLE public.coa_reports TO anon, authenticated, service_role;

CREATE TABLE IF NOT EXISTS public.faqs (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    question TEXT NOT NULL,
    answer TEXT NOT NULL,
    category TEXT NOT NULL DEFAULT 'GENERAL',
    order_index INTEGER NOT NULL DEFAULT 1,
    is_active BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
ALTER TABLE public.faqs DISABLE ROW LEVEL SECURITY;
GRANT ALL ON TABLE public.faqs TO anon, authenticated, service_role;

-- STORAGE BUCKETS
DO $$
BEGIN
    INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
    VALUES ('payment-proofs', 'payment-proofs', true, 10485760, ARRAY['image/jpeg', 'image/png', 'image/webp', 'image/gif'])
    ON CONFLICT (id) DO NOTHING;

    INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
    VALUES ('product-images', 'product-images', true, 5242880, ARRAY['image/jpeg', 'image/png', 'image/webp', 'image/gif'])
    ON CONFLICT (id) DO NOTHING;

    INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
    VALUES ('article-covers', 'article-covers', true, 5242880, ARRAY['image/jpeg', 'image/png', 'image/webp'])
    ON CONFLICT (id) DO NOTHING;

    INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
    VALUES ('menu-images', 'menu-images', true, 5242880, ARRAY['image/jpeg', 'image/png', 'image/webp'])
    ON CONFLICT (id) DO NOTHING;
END $$;

DROP POLICY IF EXISTS "Public Select" ON storage.objects;
CREATE POLICY "Public Select" ON storage.objects FOR SELECT TO public USING (true);
DROP POLICY IF EXISTS "Public Insert" ON storage.objects;
CREATE POLICY "Public Insert" ON storage.objects FOR INSERT TO public WITH CHECK (true);
DROP POLICY IF EXISTS "Public Update" ON storage.objects;
CREATE POLICY "Public Update" ON storage.objects FOR UPDATE TO public USING (true);


CREATE OR REPLACE FUNCTION get_order_details(p_order_id UUID)
RETURNS JSONB AS $$
DECLARE
    result JSONB;
BEGIN
    SELECT jsonb_build_object(
        'id', o.id,
        'customer_name', o.customer_name,
        'customer_email', o.customer_email,
        'customer_phone', o.customer_phone,
        'shipping_address', o.shipping_address,
        'shipping_city', o.shipping_city,
        'shipping_fee', o.shipping_fee,
        'total_price', o.total_price,
        'discount_applied', o.discount_applied,
        'promo_code', o.promo_code,
        'payment_status', o.payment_status,
        'order_status', o.order_status,
        'created_at', o.created_at,
        'items', o.order_items,
        'tracking_number', o.tracking_number,
        'shipping_provider', o.shipping_provider,
        'courier_code', c.code,
        'courier_name', c.name,
        'tracking_url_template', c.tracking_url_template
    ) INTO result
    FROM orders o
    LEFT JOIN couriers c ON o.courier_id = c.id
    WHERE o.id = p_order_id;

    RETURN result;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;


-- ============================================================================
-- PART 2: BETTER THAN BARE PRODUCTS (Updates 2026-01-12)
-- ============================================================================

DELETE FROM product_variations;
DELETE FROM products;
DELETE FROM categories;

INSERT INTO categories (id, name, icon, sort_order, active) VALUES
(gen_random_uuid(), 'All Products', 'Grid', 0, true),
(gen_random_uuid(), 'Weight Management', 'Scale', 1, true),
(gen_random_uuid(), 'Beauty & Anti-Aging', 'Sparkles', 2, true),
(gen_random_uuid(), 'Wellness & Vitality', 'Heart', 3, true),
(gen_random_uuid(), 'Cognitive', 'Brain', 4, true),
(gen_random_uuid(), 'Performance', 'Zap', 5, true);

DO $$
DECLARE
    weight_cat UUID;
    skin_cat UUID;
    wellness_cat UUID;
    cognitive_cat UUID;
    performance_cat UUID;
BEGIN
    SELECT id INTO weight_cat FROM categories WHERE name = 'Weight Management';
    SELECT id INTO skin_cat FROM categories WHERE name = 'Beauty & Anti-Aging';
    SELECT id INTO wellness_cat FROM categories WHERE name = 'Wellness & Vitality';
    SELECT id INTO cognitive_cat FROM categories WHERE name = 'Cognitive';
    SELECT id INTO performance_cat FROM categories WHERE name = 'Performance';

    -- Weight Management
    INSERT INTO products (name, description, category, base_price, purity_percentage, featured, available, stock_quantity) VALUES
    ('Tirz 15', 'Tirzepatide 15mg - Premium weight management peptide with dual GIP/GLP-1 action for effective results.', weight_cat, 3500.00, 99.5, true, true, 50),
    ('Tirz 20', 'Tirzepatide 20mg - Enhanced dosage for continued weight management support.', weight_cat, 4500.00, 99.5, true, true, 50),
    ('Tirz 30', 'Tirzepatide 30mg - Maximum strength formulation for optimal results.', weight_cat, 6000.00, 99.5, true, true, 50);

    -- Skin & Beauty
    INSERT INTO products (name, description, category, base_price, purity_percentage, featured, available, stock_quantity) VALUES
    ('GHK-CU 50', 'GHK-Cu 50mg - Copper peptide complex for skin rejuvenation, collagen synthesis, and anti-aging benefits.', skin_cat, 2800.00, 99.0, true, true, 40),
    ('KPV 10', 'KPV 10mg - Anti-inflammatory peptide supporting skin health and reducing redness.', skin_cat, 2200.00, 99.0, false, true, 35),
    ('GLOW', 'GLOW Complex - Premium beauty blend for radiant, healthy-looking skin.', skin_cat, 3000.00, 99.0, true, true, 45);

    -- Wellness & Vitality
    INSERT INTO products (name, description, category, base_price, purity_percentage, featured, available, stock_quantity) VALUES
    ('5-Amino 5mg', '5-Amino-1MQ 5mg - Metabolic support peptide for enhanced energy and wellness.', wellness_cat, 1800.00, 98.5, false, true, 60),
    ('MOTS-C 40mg', 'MOTS-C 40mg - Mitochondrial peptide for metabolic optimization and cellular health.', wellness_cat, 4200.00, 99.0, true, true, 30),
    ('NAD+ 500', 'NAD+ 500mg - Cellular energy and longevity support for overall vitality.', wellness_cat, 5500.00, 99.0, true, true, 25);

    -- Cognitive
    INSERT INTO products (name, description, category, base_price, purity_percentage, featured, available, stock_quantity) VALUES
    ('Semax 10mg', 'Semax 10mg - Nootropic peptide for enhanced cognitive function, focus, and mental clarity.', cognitive_cat, 1600.00, 99.0, false, true, 40),
    ('Selank 10mg', 'Selank 10mg - Anxiolytic nootropic for stress relief, mood enhancement, and mental calm.', cognitive_cat, 1600.00, 99.0, false, true, 40);

    -- Performance
    INSERT INTO products (name, description, category, base_price, purity_percentage, featured, available, stock_quantity) VALUES
    ('Cagri 5mg', 'Cagrilintide 5mg - Next-generation peptide for appetite regulation and metabolic support.', performance_cat, 3800.00, 99.0, false, true, 30),
    ('PT-141', 'PT-141 (Bremelanotide) - Melanocortin receptor agonist for enhanced performance and vitality.', performance_cat, 2000.00, 98.5, false, true, 35);
END $$;


-- ============================================================================
-- PART 3: UPDATE CATEGORIES TO TEXT IDS (Updates 2026-01-21)
-- ============================================================================

DROP TABLE IF EXISTS categories CASCADE;

CREATE TABLE categories (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  icon TEXT,
  sort_order INTEGER DEFAULT 0,
  active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

INSERT INTO categories (id, name, sort_order, active, icon) VALUES
('research', 'Research & Weight Management', 1, true, NULL),
('cosmetic', 'Cosmetic & Anti-Aging', 2, true, NULL),
('performance', 'Performance & Longevity', 3, true, NULL),
('healing', 'Healing & Recovery', 4, true, NULL),
('addons', 'supplies & Add-ons', 5, true, NULL);

ALTER TABLE products ALTER COLUMN category TYPE TEXT;

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
UPDATE products SET category = 'performance' WHERE name ILIKE '%5-amino%';
UPDATE products SET category = 'performance' WHERE name ILIKE '%SS-31%';

UPDATE products SET category = 'healing' WHERE category = 'recovery';
UPDATE products SET category = 'healing' WHERE name ILIKE '%BPC-157%';
UPDATE products SET category = 'healing' WHERE name ILIKE '%TB-500%';
UPDATE products SET category = 'healing' WHERE name ILIKE '%Thymosin%';
UPDATE products SET category = 'healing' WHERE name ILIKE '%ARA-290%';
UPDATE products SET category = 'healing' WHERE name ILIKE '%KPV%';

UPDATE products SET category = 'addons' WHERE name ILIKE '%Pen%'; 
UPDATE products SET category = 'addons' WHERE name ILIKE '%Cartridge%';
UPDATE products SET category = 'addons' WHERE name ILIKE '%Water%';
UPDATE products SET category = 'addons' WHERE name ILIKE '%V1%';
UPDATE products SET category = 'addons' WHERE name ILIKE '%Needle%';

ALTER TABLE products 
ADD CONSTRAINT fk_products_category 
FOREIGN KEY (category) 
REFERENCES categories(id) 
ON DELETE SET NULL;


-- ============================================================================
-- PART 4: FIX MISSING PROTOCOLS (Adds Protocols Table)
-- ============================================================================

DROP TABLE IF EXISTS protocols;

CREATE TABLE protocols (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  category TEXT NOT NULL,
  dosage TEXT NOT NULL,
  frequency TEXT NOT NULL,
  duration TEXT NOT NULL,
  notes TEXT[] DEFAULT '{}',
  storage TEXT NOT NULL,
  sort_order INTEGER DEFAULT 0,
  active BOOLEAN DEFAULT true,
  product_id UUID REFERENCES products(id) ON DELETE SET NULL,
  image_url TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE protocols ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Public can read active protocols" ON protocols
  FOR SELECT USING (active = true);

CREATE POLICY "Admins can manage protocols" ON protocols
  FOR ALL USING (true);

-- Insert DETAILED protocols (abbreviated here but references removed)
-- (Users should check fix_missing_protocols.sql for full seed if needed, but we include a basic one)
INSERT INTO protocols (name, category, dosage, frequency, duration, notes, storage, sort_order) VALUES
('Tirzepatide', 'Weight Management', 'Start: 2.5mg → Titrate up to 15mg', 'Once weekly', '12-16 weeks', ARRAY['Start low', 'Increase by 2.5mg every 4 weeks'], 'Refrigerate', 1);


-- ============================================================================
-- PART 5: AI PROTOCOL SUPPORT (Refine FK)
-- ============================================================================

ALTER TABLE protocols DROP CONSTRAINT IF EXISTS protocols_product_id_fkey;

ALTER TABLE protocols 
ADD CONSTRAINT protocols_product_id_fkey 
FOREIGN KEY (product_id) 
REFERENCES products(id) 
ON DELETE CASCADE;

CREATE INDEX IF NOT EXISTS idx_protocols_product_id ON protocols(product_id);
