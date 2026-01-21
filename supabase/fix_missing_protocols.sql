-- Fix Missing Protocols Table (Final Comprehensive Version)
-- Run this to get DETAILED protocols for ALL products (Tesamorelin, Snap8, etc.)

-- 1. Create table structure (Drop and Recreate to ensure correct schema)
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
  image_url TEXT, -- Added for visual guides
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 2. Enable RLS
ALTER TABLE protocols ENABLE ROW LEVEL SECURITY;

-- 3. Create Policies
CREATE POLICY "Public can read active protocols" ON protocols
  FOR SELECT USING (active = true);

CREATE POLICY "Admins can manage protocols" ON protocols
  FOR ALL USING (true);


-- 4. Insert DETAILED protocols for EVERY item on your list
INSERT INTO protocols (name, category, dosage, frequency, duration, notes, storage, sort_order) VALUES
(
  'Tirzepatide',
  'Weight Management',
  'Start: 2.5mg → Titrate up to 15mg',
  'Once weekly (same day each week)',
  '12-16 weeks per cycle',
  ARRAY[
    'Month 1: 2.5mg once weekly',
    'Month 2: 5.0mg once weekly (if well tolerated)',
    'Month 3: 7.5mg once weekly',
    'Increase by 2.5mg every 4 weeks to max 15mg',
    'Inject subcutaneously in abdomen, thigh, or upper arm',
    'Stay hydrated and prioritize protein'
  ],
  'Refrigerate at 2-8°C. Protect from light.',
  1
),
(
  'Semaglutide',
  'Weight Management',
  'Start: 0.25mg → Maintenance: 2.4mg',
  'Once weekly',
  'Dependent on goals',
  ARRAY[
    'Week 1-4: 0.25mg weekly',
    'Week 5-8: 0.50mg weekly',
    'Week 9-12: 1.0mg weekly',
    'Week 13-16: 1.7mg weekly',
    'Week 17+: 2.4mg weekly (Maintenance)',
    'Common side effects: nausea (usually transient)'
  ],
  'Refrigerate. Use within 56 days of opening.',
  2
),
(
  'Retatrutide (Reta)',
  'Research / Weight Management',
  'Start: 2mg → Titrate cautiously',
  'Once weekly',
  'Research cycle duration varies',
  ARRAY[
    'Starting Dose: 2mg weekly for 4 weeks',
    'Step up: 4mg weekly for 4 weeks',
    'Step up: 6mg weekly (if needed/tolerated)',
    'Powerful GIP/GLP-1/Glucagon agonist - monitor closely',
    'Typically shows faster onset than Tirzepatide'
  ],
  'Store at -20°C (powder). Refrigerate after reconstitution.',
  3
),
(
  'Lemon Bottle',
  'Fat Dissolving (Cosmetic)',
  '10ml-30ml per session (Varies by area)',
  'Every 7-10 days',
  '3-5 sessions typically recommended',
  ARRAY[
    'Abdomen: 30-40ml total',
    'Love Handles: 15-20ml per side',
    'Chin: 10-15ml total',
    'Arms: 10-15ml per arm',
    'Thighs: 20-30ml per thigh',
    'Inject into fat layer (1.5-2cm grid pattern)',
    'Drink 2L+ water daily after treatment'
  ],
  'Room temp (unopened). Refrigerate after opening.',
  4
),
(
  'Tesamorelin',
  'Weight Management / GH',
  '1mg - 2mg daily',
  'Daily (before bed)',
  '5 days on, 2 days off',
  ARRAY[
    'Inject subcutaneously',
    'Take on empty stomach (at least 2hrs after food)',
    'Best taken right before sleep',
    'Specifically targets visceral belly fat',
    'Increases natural GH production'
  ],
  'Refrigerate at 2-8°C.',
  5
),
(
  'Snap8',
  'Beauty & Aesthetics',
  'Topical application (Anti-Wrinkle)',
  'Twice daily',
  'Ongoing',
  ARRAY[
    'Mix with carrier serum or cream',
    'Apply to forehead and around eyes',
    'Direct "Botox-like" effect on fine lines',
    'Consistent daily use required',
    'Can be combined with GHK-Cu'
  ],
  'Cool, dark place.',
  6
),
(
  'GHK-Cu (Copper Peptide)',
  'Skin & Anti-Aging',
  '1-2mg daily (Injectable) or Topical',
  'Daily',
  '30 day cycle',
  ARRAY[
    'Subcutaneous: 1mg-2mg daily',
    'Topical: Mix with serum (1-2% concentration)',
    'Can cause sting/pain at injection site - dilute well',
    'Promotes collagen and skin elasticity'
  ],
  'Store powder at -20°C. Reconstituted: refrigerate.',
  7
),
(
  'BPC-157',
  'Recovery & Healing',
  '250mcg - 500mcg',
  'Daily',
  '4-6 weeks typical cycle',
  ARRAY[
    'Systemic healing: Subcutaneous near navel',
    'Localized: Subcutaneous near injury site',
    'Gut health: Oral administration or systemic injection',
    'No known serious side effects'
  ],
  'Refrigerate after reconstitution.',
  8
),
(
  'Epitalon',
  'Longevity',
  '5mg - 10mg daily',
  'Daily',
  '10-20 day course',
  ARRAY[
    'Use 2-3 times per year',
    'Telomere support and circadian rhythm',
    'Best taken before bed',
    'Subcutaneous injection'
  ],
  'Refrigerate.',
  9
),
(
  'SS-31',
  'Mitochondrial Health',
  '4mg daily',
  'Daily',
  '4-8 weeks',
  ARRAY[
    'Target mitochondrial dysfunction',
    'Subcutaneous injection',
    'Supports cognitive and physical energy',
    'Generally well tolerated'
  ],
  'Refrigerate.',
  10
),
(
  'AOD 9604',
  'Fat Burning',
  '300mcg - 500mcg daily',
  'Daily morning (Fasted)',
  '12 weeks',
  ARRAY[
    'Take on empty stomach upon waking',
    'Wait 30-60 mins before eating',
    'Fat burning fragment of HGH',
    'Zero effect on blood sugar'
  ],
  'Refrigerate after reconstitution.',
  11
),
(
  '5-Amino-1MQ',
  'Metabolic Health',
  '50mg - 100mg daily (Oral)',
  'Daily',
  '8-12 weeks',
  ARRAY[
    'Take with food',
    'NNMT inhibitor - increases metabolic rate',
    'Supports muscle retention',
    'Capsule form typical'
  ],
  'Store in cool dry place.',
  12
),
(
  'Lipo-C (MIC + B12)',
  'Fat Burning',
  '1ml - 2ml injection',
  '1-3 times weekly',
  'Ongoing or cycled',
  ARRAY[
    'Deep IM injection (Glute or Thigh)',
    'Enhances fat metabolism in liver',
    'B12 provides energy boost',
    'Combine with exercise for best results'
  ],
  'Protect from light.',
  13
),
(
  'Thymosin Alpha-1',
  'Immunity',
  '1.6mg twice weekly',
  'Twice weekly',
  'Cycle varies',
  ARRAY[
    'Immune system modulator',
    'Subcutaneous injection',
    'Supports T-cell function',
    'Safe profile'
  ],
  'Refrigerate.',
  14
),
(
  'MOTS-c',
  'Metabolic Health',
  '5mg - 10mg weekly',
  'Once weekly',
  '8 weeks',
  ARRAY[
    'Enhances insulin sensitivity',
    'Mitochondrial derived peptide',
    'Best taken before exercise',
    'Inject Subcutaneously'
  ],
  'Refrigerate.',
  15
),
(
  'Cagrilintide',
  'Weight Management',
  '0.3mg - 4.8mg weekly',
  'Once weekly',
  '12+ weeks',
  ARRAY[
    'Amylin analogue - promotes satiety',
    'Start low (0.3mg) and titrate',
    'Often stacked with GLP-1s',
    'Subcutaneous injection'
  ],
  'Refrigerate.',
  16
),
(
  'Ara-290',
  'Neuropathy / Repair',
  '4mg daily',
  'Daily',
  '28 day cycle',
  ARRAY[
    'Reduced inflammation and neuropathic pain',
    'Tissue repair properties',
    'Subcutaneous injection',
    'Consistency is key'
  ],
  'Refrigerate.',
  17
),
(
  'Mazdutide',
  'Weight Management',
  'Start: 1mg-2mg',
  'Once weekly',
  'Research cycle',
  ARRAY[
    'Dual agonist (GLP-1/Glucagon)',
    'Strong metabolic effect',
    'Start low to assess tolerance',
    'For research purposes'
  ],
  'Store at -20°C. Refrigerate after reconstitution.',
  18
),
(
  'NAD+',
  'Longevity',
  '50mg - 100mg (Start Low)',
  '2-3 times weekly',
  'Ongoing',
  ARRAY[
    'Start VERY low (25-50mg) to avoid "flush"',
    'Titrate up slowly',
    'Subcutaneous or Intramuscular',
    'Deep cell energy support'
  ],
  'Refrigerate. Sensitive to Light.',
  19
),
(
  'KPV',
  'Anti-Inflammatory',
  '200mcg - 500mcg',
  'Daily',
  'As needed',
  ARRAY[
    'Potent anti-inflammatory',
    'Can be Oral or Subcutaneous',
    'Treats skin issues and gut inflammation',
    'Antimicrobial properties'
  ],
  'Refrigerate.',
  20
);
