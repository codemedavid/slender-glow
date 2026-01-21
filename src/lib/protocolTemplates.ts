// Protocol Templates Library
// Smart Protocol Generation based on Product Name detection

export interface ProtocolTemplate {
    dosage: string;
    frequency: string;
    duration: string;
    notes: string[];
    storage: string;
}

// 1. Specific Peptide Protocols (High Priority)
// Keys are matched against product names (case-insensitive)
const specificProtocols: Record<string, ProtocolTemplate> = {
    'tirzepatide': {
        dosage: 'Start: 2.5mg → Titrate up to 15mg',
        frequency: 'Once weekly (same day each week)',
        duration: '12-16 weeks per cycle typical',
        notes: [
            'Month 1: 2.5mg once weekly',
            'Month 2: 5.0mg once weekly (if well tolerated)',
            'Month 3: 7.5mg once weekly',
            'Increase by 2.5mg every 4 weeks to max 15mg',
            'Inject subcutaneously in abdomen, thigh, or upper arm',
            'Stay hydrated and prioritize protein'
        ],
        storage: 'Refrigerate at 2-8°C. Protect from light.'
    },
    'semaglutide': {
        dosage: 'Start: 0.25mg → Maintenance: 2.4mg',
        frequency: 'Once weekly',
        duration: 'Ongoing or as needed for weight goals',
        notes: [
            'Week 1-4: 0.25mg weekly',
            'Week 5-8: 0.50mg weekly',
            'Week 9-12: 1.0mg weekly',
            'Week 13-16: 1.7mg weekly',
            'Week 17+: 2.4mg weekly (Maintenance)',
            'Common side effects: nausea (usually transient)'
        ],
        storage: 'Refrigerate. Use within 56 days of opening.'
    },
    'retatrutide': {
        dosage: 'Start: 2mg → Titrate cautiously',
        frequency: 'Once weekly',
        duration: 'Research cycle duration varies',
        notes: [
            'Starting Dose: 2mg weekly for 4 weeks',
            'Step up: 4mg weekly for 4 weeks',
            'Step up: 6mg weekly (if tolerated)',
            'Triple agonist (GIP/GLP-1/Glucagon)',
            'Monitor heart rate and blood pressure'
        ],
        storage: 'Store at -20°C (powder). Refrigerate after reconstitution.'
    },
    'reta': { /* Alias for Retatrutide */
        dosage: 'Start: 2mg → Titrate cautiously',
        frequency: 'Once weekly',
        duration: 'Research cycle duration varies',
        notes: [
            'Starting Dose: 2mg weekly for 4 weeks',
            'Step up: 4mg weekly for 4 weeks',
            'Triple agonist (GIP/GLP-1/Glucagon)',
            'Monitor heart rate and blood pressure'
        ],
        storage: 'Store at -20°C (powder). Refrigerate after reconstitution.'
    },
    'cagrilintide': {
        dosage: '0.3mg - 4.8mg weekly',
        frequency: 'Once weekly',
        duration: '12+ weeks',
        notes: [
            'Often stacked with Semaglutide or Tirzepatide',
            'Start low (0.3mg) and titrate every 4 weeks',
            'Amylin analogue - promotes satiety',
            'Inject subcutaneously'
        ],
        storage: 'Refrigerate after reconstitution.'
    },
    'mazdutide': {
        dosage: 'Start: 1mg-2mg',
        frequency: 'Once weekly',
        duration: 'Research cycle',
        notes: [
            'Dual agonist (GLP-1/Glucagon)',
            'Start low to assess tolerance',
            'Strong metabolic effect',
            'For research purposes'
        ],
        storage: 'Store at -20°C. Refrigerate after reconstitution.'
    },
    'lemon bottle': {
        dosage: 'Varies by area (10ml-30ml per session)',
        frequency: 'Every 7-10 days',
        duration: '3-5 sessions recommended',
        notes: [
            'Abdomen: 30-40ml total',
            'Chin: 10-15ml total',
            'Arms: 10-15ml per arm',
            'Inject into fat layer (1.5-2cm grid pattern)',
            'Drink 2L water daily after treatment'
        ],
        storage: 'Room temp (unopened). Refrigerate after opening.'
    },
    'lipo c': {
        dosage: '1ml - 2ml injection',
        frequency: '1-3 times weekly',
        duration: '8-12 weeks',
        notes: [
            'Intramuscular (IM) injection preferred (glute/thigh)',
            'Enhances fat metabolism',
            'Boosts energy via B12',
            'Best combined with exercise'
        ],
        storage: 'Protect from light. Room temp or Refrigerate.'
    },
    'ghk-cu': {
        dosage: '1mg-2mg daily (Injectable) or Topical',
        frequency: 'Daily',
        duration: '4-6 week cycle, 1 week break',
        notes: [
            'Subcutaneous: 1mg-2mg daily',
            'Topical: Mix with serum (1-2% concentration)',
            'Can cause injection site pain (dilute well)',
            'Supports skin elasticity and collagen'
        ],
        storage: 'Refrigerate after reconstitution.'
    },
    'nad+': {
        dosage: '50mg - 100mg start',
        frequency: '2-3 times weekly',
        duration: 'Ongoing or cycled',
        notes: [
            'Start VERY low (25-50mg) to avoid "flush"',
            'Titrate up to 200-500mg as tolerated',
            'Subcutaneous or Intramuscular',
            'Supports cellular energy and DNA repair'
        ],
        storage: 'Refrigerate. Sensitive to light/heat.'
    },
    'bpc-157': {
        dosage: '250mcg - 500mcg',
        frequency: 'Daily or Twice Daily',
        duration: '4-6 weeks',
        notes: [
            'Systemic: Inject near navel',
            'Localized: Inject near injury site (if safe)',
            'Wound healing and gut health',
            'Synergistic with TB-500'
        ],
        storage: 'Refrigerate after reconstitution.'
    },
    'epitalon': {
        dosage: '5mg - 10mg daily',
        frequency: 'Daily',
        duration: '10-20 day course',
        notes: [
            'Use 2-3 times per year',
            'Anti-aging / Telomere support',
            'Best taken before bed',
            'Subcutaneous injection'
        ],
        storage: 'Refrigerate.'
    },
    'ss-31': {
        dosage: '4mg daily',
        frequency: 'Daily',
        duration: '4-8 weeks',
        notes: [
            'Mitochondrial health peptide',
            'Subcutaneous injection',
            'Supports cellular energy',
            'No known serious side effects'
        ],
        storage: 'Refrigerate.'
    },
    'mots-c': {
        dosage: '5mg - 10mg weekly',
        frequency: 'Once weekly or split dose',
        duration: '8 weeks',
        notes: [
            'Mitochondrial derived peptide',
            'Enhances metabolic function',
            'Best taken before exercise',
            'Inject Subcutaneously'
        ],
        storage: 'Refrigerate.'
    },
    '5-amino': {
        dosage: '50mg - 100mg daily (Oral)',
        frequency: 'Daily',
        duration: '8-12 weeks',
        notes: [
            'Take with food',
            'Supports fat metabolism',
            'Specifically targets white adipose tissue',
            'Stay consistent for best results'
        ],
        storage: 'Store in cool dry place.'
    },
    'aod': {
        dosage: '300mcg - 500mcg daily',
        frequency: 'Daily morning (fasted)',
        duration: '12 weeks',
        notes: [
            'Take on empty stomach upon waking',
            'Wait 30-60 mins before eating',
            'Fat burning fragment of HGH',
            'Subcutaneous injection'
        ],
        storage: 'Refrigerate after reconstitution.'
    },
    'tesamorilin': {
        dosage: '1mg - 2mg daily',
        frequency: 'Daily before bed',
        duration: '5 days on, 2 days off',
        notes: [
            'Take on empty stomach (2hrs after food)',
            'Stimulates natural GH production',
            'Targets visceral fat reduction',
            'Subcutaneous injection'
        ],
        storage: 'Refrigerate at 2-8°C.'
    },
    'thymosin alpha': {
        dosage: '1.6mg twice weekly',
        frequency: 'Twice weekly',
        duration: 'Usage varies by condition',
        notes: [
            'Immune system modulator',
            'Subcutaneous injection',
            'Supports T-cell function',
            'Generally well tolerated'
        ],
        storage: 'Refrigerate.'
    },
    'ara290': {
        dosage: '4mg daily',
        frequency: 'Daily',
        duration: '28 day cycle',
        notes: [
            'Neuropathy and inflammation',
            'Subcutaneous injection',
            'Tissue repair properties',
            'Short half-life, usage consistency matters'
        ],
        storage: 'Refrigerate.'
    },
    'snap8': {
        dosage: 'Topical application',
        frequency: 'Twice daily',
        duration: 'Ongoing',
        notes: [
            'Mix with serum or cream',
            '"Botox-like" effect for fine lines',
            'Apply to forehead and around eyes',
            'Consistent use required for results'
        ],
        storage: 'Cool, dark place.'
    },
    'kpv': {
        dosage: '200mcg - 500mcg daily',
        frequency: 'Daily',
        duration: 'As needed',
        notes: [
            'Potent anti-inflammatory',
            'Subcutaneous or Oral',
            'Can treat skin conditions / gut health',
            'Also has antimicrobial properties'
        ],
        storage: 'Refrigerate.'
    },
    'gtt': { /* Gooselane / GTT */
        dosage: 'Consult Protocol',
        frequency: 'Varies',
        duration: 'Varies',
        notes: [
            'Glucose Tolerance Test blend or specific peptide',
            'Follow specific provider instructions',
            'Monitor blood glucose'
        ],
        storage: 'Refrigerate.'
    }
};


// 2. Generic Category Templates (Fallback)
export const categoryTemplates: Record<string, ProtocolTemplate> = {
    'Weight Management': {
        dosage: 'Start low, titrate up weekly',
        frequency: 'Once weekly',
        duration: '12-16 weeks',
        notes: [
            'Start with lowest dose',
            'Increase slowly to avoid side effects',
            'Inject subcutaneously',
            'Drink plenty of water'
        ],
        storage: 'Refrigerate at 2-8°C.'
    },
    'Cosmetic': {
        dosage: 'As directed for treatment area',
        frequency: 'Weekly or as needed',
        duration: '4-6 sessions',
        notes: [
            'cleanse area thoroughly',
            'follow injection grid pattern',
            'massage if recommended',
            'stay hydrated'
        ],
        storage: 'Store cool and dry.'
    },
    'default': {
        dosage: 'Consult healthcare professional',
        frequency: 'As directed',
        duration: 'As directed',
        notes: [
            'Consult doctor before use',
            'Start with lowest dose',
            'Monitor for side effects'
        ],
        storage: 'Refrigerate after reconstitution.'
    }
};

// Function to get protocol template
// Now prioritizes Name Match -> then Category Match -> then Default
export const generateProtocolFromTemplate = (productName: string, category: string) => {
    const normalizedName = productName.toLowerCase();

    // 1. Check for specific peptide match in name
    // match 'tirzepatide' in 'Tirzepatide 15mg'
    let template = null;

    for (const [key, value] of Object.entries(specificProtocols)) {
        if (normalizedName.includes(key)) {
            template = value;
            console.log(`🎯 Smart Match: Found specific protocol for ${key}`);
            break;
        }
    }

    // 2. Fallback to category match if no name match
    if (!template) {
        template = categoryTemplates[category] || categoryTemplates['default'];
        console.log(`ℹ️ Category Fallback: Using template for ${category}`);
    }

    return {
        name: `${productName} Protocol`,
        category: category,
        dosage: template.dosage,
        frequency: template.frequency,
        duration: template.duration,
        notes: template.notes,
        storage: template.storage,
        sort_order: 0,
        active: true
    };
};
