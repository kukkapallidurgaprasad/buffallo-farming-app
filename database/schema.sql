-- Buffalo Farming Database Schema
-- PostgreSQL Database Setup

-- Drop existing tables if they exist
DROP TABLE IF EXISTS marketplace_listings CASCADE;
DROP TABLE IF EXISTS success_stories CASCADE;
DROP TABLE IF EXISTS government_schemes CASCADE;
DROP TABLE IF EXISTS disease_medicines CASCADE;
DROP TABLE IF EXISTS diseases CASCADE;
DROP TABLE IF EXISTS feeding_categories CASCADE;
DROP TABLE IF EXISTS breeds CASCADE;
DROP TABLE IF EXISTS users CASCADE;

-- Users Table
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(100) UNIQUE NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    phone VARCHAR(20),
    location VARCHAR(200),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Buffalo Breeds Table
CREATE TABLE breeds (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    state VARCHAR(200),
    color VARCHAR(100),
    milk_yield VARCHAR(50),
    fat_content VARCHAR(20),
    weight VARCHAR(50),
    features TEXT,
    nickname VARCHAR(100),
    best_for VARCHAR(200),
    price_range VARCHAR(50),
    image_url VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Diseases Table
CREATE TABLE diseases (
    id SERIAL PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    type VARCHAR(50),
    severity VARCHAR(50),
    symptoms TEXT[],
    treatment TEXT[],
    prevention TEXT[],
    cost_range VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Disease Medicines Junction Table
CREATE TABLE disease_medicines (
    id SERIAL PRIMARY KEY,
    disease_id INTEGER REFERENCES diseases(id) ON DELETE CASCADE,
    medicine_name VARCHAR(150) NOT NULL,
    dosage VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Feeding Categories Table
CREATE TABLE feeding_categories (
    id SERIAL PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    items TEXT[],
    quantity VARCHAR(100),
    cost VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Government Schemes Table
CREATE TABLE government_schemes (
    id SERIAL PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    benefit TEXT,
    eligibility TEXT,
    subsidy_amount VARCHAR(100),
    how_to_apply TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Success Stories Table
CREATE TABLE success_stories (
    id SERIAL PRIMARY KEY,
    farmer_name VARCHAR(100) NOT NULL,
    location VARCHAR(150),
    scale VARCHAR(100),
    investment VARCHAR(50),
    monthly_income VARCHAR(50),
    story TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Marketplace Listings Table
CREATE TABLE marketplace_listings (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    listing_type VARCHAR(20) NOT NULL, -- 'sell' or 'buy'
    breed VARCHAR(100),
    age VARCHAR(50),
    milk_yield VARCHAR(50),
    price VARCHAR(50),
    budget VARCHAR(50),
    requirement TEXT,
    location VARCHAR(200),
    contact VARCHAR(50),
    verified BOOLEAN DEFAULT FALSE,
    status VARCHAR(20) DEFAULT 'active', -- 'active', 'sold', 'inactive'
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert Sample Breeds Data
INSERT INTO breeds (name, state, color, milk_yield, fat_content, weight, features, nickname, best_for, price_range, image_url) VALUES
('Murrah', 'Haryana, Punjab', 'Jet black', '15-20 liters/day', '7-8%', '450-550 kg', 'Highest milk yield, curved horns, well-developed udder', 'Black Gold of India', 'Commercial dairy farming', '₹70,000 - ₹1,00,000', '🐃'),
('Jaffarabadi', 'Gujarat', 'Jet black', '12-15 liters/day', '8-10%', '600-800 kg', 'Largest Indian breed, massive build, curved drooping horns', 'Giant of Gujarat', 'Dual purpose (milk + draft)', '₹80,000 - ₹1,20,000', '🐃'),
('Nili-Ravi', 'Punjab', 'Dark brown to black', '12-18 liters/day', '6-7%', '400-500 kg', 'White markings on legs and forehead, calm temperament', 'Panch Kalyani', 'High milk production', '₹65,000 - ₹95,000', '🐃'),
('Mehsana', 'Gujarat', 'Black', '10-14 liters/day', '6-7%', '450-550 kg', 'Cross of Murrah and Surti, heat tolerant, medium size', 'Best of Both', 'Hot climate regions', '₹60,000 - ₹85,000', '🐃'),
('Bhadawari', 'Uttar Pradesh, Madhya Pradesh', 'Copper brown', '6-8 liters/day', '10-13%', '350-450 kg', 'Highest butterfat content, ideal for ghee production', 'Ghee Champion', 'Ghee and dairy products', '₹40,000 - ₹60,000', '🐃'),
('Surti', 'Gujarat', 'Rusty brown to silver-grey', '8-12 liters/day', '7-8%', '400-600 kg', 'Small, active, two white collars, excellent feed efficiency', 'Efficient Producer', 'Small-scale farming', '₹50,000 - ₹75,000', '🐃'),
('Nagpuri', 'Maharashtra', 'Black with white patches', '6-10 liters/day', '7-8%', '425-525 kg', 'Hardy, drought-resistant, sword-shaped horns, dual-purpose', 'Vidarbha Special', 'Drought-prone areas', '₹45,000 - ₹70,000', '🐃'),
('Pandharpuri', 'Maharashtra', 'Black', '5-8 liters/day', '7-8%', '350-450 kg', 'Small compact body, suitable for backyard farming, low maintenance', 'Compact Powerhouse', 'Backyard farming', '₹35,000 - ₹55,000', '🐃'),
('Toda', 'Tamil Nadu (Nilgiri Hills)', 'Reddish brown to fawn', '3-5 liters/day', '8-10%', '300-400 kg', 'Smallest Indian breed, adapted to hilly terrain, rare breed', 'Hill Buffalo', 'Mountain regions', '₹30,000 - ₹50,000', '🐃'),
('Kalahandi', 'Odisha', 'Grey to black', '4-6 liters/day', '7-9%', '350-450 kg', 'Heat and disease resistant, suitable for tribal areas, low input requirements', 'Tribal Favorite', 'Low-input farming', '₹32,000 - ₹52,000', '🐃'),
('Chilika', 'Odisha (Coastal)', 'Greyish black', '5-7 liters/day', '6-8%', '400-500 kg', 'Well adapted to coastal wetlands, good for marshy areas', 'Coastal Warrior', 'Wetland farming', '₹38,000 - ₹58,000', '🐃'),
('Manda', 'Odisha', 'Grey', '4-6 liters/day', '7-8%', '350-450 kg', 'Draught breed primarily used for field work, strong and sturdy', 'Field Worker', 'Agricultural work', '₹35,000 - ₹55,000', '🐃'),
('Jerangi', 'Odisha', 'Light grey to black', '5-7 liters/day', '6-7%', '380-480 kg', 'Good for ploughing and transport, medium milk yield', 'Dual Performer', 'Mixed farming', '₹40,000 - ₹62,000', '🐃'),
('Marathwadi', 'Maharashtra, Karnataka', 'Black with grey patches', '4-7 liters/day', '7-8%', '400-500 kg', 'Hardy breed, drought tolerant, less feed requirement', 'Drought Fighter', 'Dry regions', '₹38,000 - ₹60,000', '🐃'),
('Chhattisgarhi', 'Chhattisgarh', 'Greyish to black', '5-8 liters/day', '6-7%', '380-480 kg', 'Adapted to rain-fed areas, good temperament, disease resistant', 'Rain-fed Special', 'Rain-dependent areas', '₹40,000 - ₹65,000', '🐃'),
('South Kanara', 'Karnataka (Coastal)', 'Ash grey to black', '4-6 liters/day', '7-9%', '350-450 kg', 'Small sized, suited for coastal climate, good for small farms', 'Coastal Compact', 'Small coastal farms', '₹35,000 - ₹58,000', '🐃'),
('Godavari', 'Andhra Pradesh (Godavari Delta)', 'Black to greyish black', '7-10 liters/day', '7-8%', '400-550 kg', 'Well adapted to delta regions, good milk yield, heat tolerant, thrives in coastal climate', 'Delta Pride', 'Delta and coastal farming', '₹45,000 - ₹72,000', '🐃'),
('Nellore', 'Andhra Pradesh (Nellore, Prakasam)', 'Dark grey to black', '5-8 liters/day', '6-8%', '380-480 kg', 'Hardy breed, drought resistant, suitable for semi-arid regions, low maintenance', 'Rayalaseema Special', 'Semi-arid regions', '₹38,000 - ₹62,000', '🐃'),
('Krishna Valley', 'Andhra Pradesh (Krishna District)', 'Greyish to black', '6-9 liters/day', '7-8%', '420-520 kg', 'Medium sized, good for mixed farming, adapted to Krishna river basin, disease resistant', 'River Basin Buffalo', 'River valley farming', '₹42,000 - ₹68,000', '🐃'),
('Visakhapatnam', 'Andhra Pradesh (Visakhapatnam, Vizianagaram)', 'Black with white patches', '5-7 liters/day', '7-9%', '360-460 kg', 'Coastal breed, salt-tolerant, good for beachside farming, compact size', 'Coastal Diamond', 'Coastal areas near sea', '₹40,000 - ₹65,000', '🐃'),
('Chittoor', 'Andhra Pradesh (Chittoor, Tirupati)', 'Brown to black', '6-9 liters/day', '7-8%', '400-500 kg', 'Multi-purpose breed, good milk and draught power, suited for red soil regions', 'Temple Town Buffalo', 'Hilly and plain regions', '₹43,000 - ₹70,000', '🐃');

-- Insert Sample Diseases Data
INSERT INTO diseases (name, type, severity, symptoms, treatment, prevention, cost_range) VALUES
('Foot and Mouth Disease (FMD)', 'Viral', 'High', 
    ARRAY['High fever (104-106°F)', 'Excessive salivation', 'Vesicular lesions on lips, tongue, gums', 'Lesions on hooves and teats', 'Loss of appetite', 'Decreased milk production', 'Lameness'],
    ARRAY['No specific cure - supportive care', 'Isolate infected animals immediately', 'Anti-inflammatory drugs', 'Antibiotic ointments for secondary infections', 'Proper nursing and nutrition'],
    ARRAY['Regular FMD vaccination every 6 months', 'Quarantine new animals for 21 days', 'Biosecurity measures', 'Avoid contact with infected herds'],
    '₹500-2,000 per animal'),
    
('Mastitis', 'Bacterial', 'Medium-High',
    ARRAY['Swollen, hot, and painful udder', 'Abnormal milk (watery, clotted, blood-tinged)', 'Reduced milk yield', 'Fever in acute cases', 'Loss of appetite', 'Hardening of udder quarters'],
    ARRAY['Frequent milk removal from affected quarter', 'Intramammary antibiotic infusion', 'Systemic antibiotics (Penicillin, Gentamicin)', 'Anti-inflammatory drugs', 'Cold/hot fomentation', 'California Mastitis Test (CMT) for diagnosis'],
    ARRAY['Clean and dry milking area', 'Pre and post-milking teat dipping', 'CMT every 15 days during lactation', 'Proper milking hygiene', 'Dry period therapy'],
    '₹300-1,500 per treatment'),
    
('Hemorrhagic Septicemia (HS)', 'Bacterial', 'Very High',
    ARRAY['Sudden high fever (105-107°F)', 'Swelling of throat and neck', 'Difficulty breathing', 'Profuse salivation', 'Nasal discharge', 'Death within 24-48 hours if untreated'],
    ARRAY['Early IV antibiotics critical', 'Sulfonamides, Tetracyclines', 'Penicillin, Gentamicin', 'Enrofloxacin, Ceftiofur', 'Supportive fluid therapy', 'Treatment often unsuccessful if delayed'],
    ARRAY['Vaccination twice yearly (before monsoon and winter)', 'Immediate isolation of sick animals', 'Quarantine during outbreaks', 'Avoid grazing in waterlogged areas'],
    '₹800-3,000 per animal'),
    
('Black Quarter (Blackleg)', 'Bacterial', 'High',
    ARRAY['High fever (106-108°F)', 'Severe lameness', 'Swelling on hip, shoulder, or back', 'Swelling initially hot and painful, later cold', 'Crepitation (crackling) on touching swelling', 'Loss of appetite and depression', 'Death within 12-48 hours'],
    ARRAY['Early antibiotic treatment essential', 'High dose Penicillin IV', 'Surgical incision of swelling', 'Hydrogen peroxide in wound', 'Supportive care'],
    ARRAY['Annual vaccination', 'Especially for young animals 6-24 months', 'Avoid grazing in endemic areas during monsoon'],
    '₹1,000-4,000 per animal'),
    
('Buffalopox', 'Viral', 'Medium',
    ARRAY['Pox lesions on udder, teats, and limbs', 'Reduced milk yield (30-35%)', 'Mastitis due to secondary infection', 'Lesions around ears and hindquarters', 'Fever and loss of appetite'],
    ARRAY['No specific antiviral treatment', 'Antiseptic wash of affected areas', 'Antibiotic ointment for secondary infections', 'Gentle milking or hand milking', 'Supportive care and nutrition'],
    ARRAY['Hygiene during milking', 'Isolate infected animals', 'Control flies and midges', 'Vaccination (where available)'],
    '₹200-800 per animal'),
    
('Tuberculosis (TB)', 'Bacterial', 'High',
    ARRAY['Chronic cough', 'Progressive weight loss', 'Decreased milk production', 'Enlarged lymph nodes', 'Difficulty breathing', 'Loss of appetite'],
    ARRAY['No effective treatment (disease control)', 'Test and segregate positive animals', 'Slaughter policy in many countries', 'Zoonotic risk - affects humans'],
    ARRAY['Regular tuberculin testing', 'Segregation of infected animals', 'Biosecurity measures', 'Avoid contact with infected cattle'],
    'No approved treatment');

-- Insert Disease Medicines
INSERT INTO disease_medicines (disease_id, medicine_name, dosage) VALUES
(1, 'NSAIDs (Meloxicam, Flunixin)', 'As per vet prescription'),
(1, 'Antibiotic ointments', 'Topical application'),
(1, 'Multivitamins', 'Daily supplement'),
(2, 'Gentamicin', '5-10 mg/kg body weight'),
(2, 'Penicillin', 'Intramammary infusion'),
(2, 'Ceftiofur', '1-2 mg/kg body weight'),
(2, 'Meloxicam', '0.5 mg/kg body weight'),
(2, 'Intramammary tubes', 'One tube per quarter'),
(3, 'Oxytetracycline', '10-20 mg/kg IV'),
(3, 'Penicillin-Streptomycin', 'Combined therapy'),
(3, 'Enrofloxacin', '5 mg/kg body weight'),
(3, 'Ceftiofur', '1-2 mg/kg body weight'),
(4, 'Penicillin (high dose)', '20,000-40,000 IU/kg'),
(4, 'Oxytetracycline', '10 mg/kg IV'),
(4, 'Hydrogen peroxide', 'Wound irrigation'),
(5, 'Antiseptic solutions', 'External application'),
(5, 'Antibiotic ointments', 'For secondary infections'),
(5, 'Multivitamins', 'Supportive care');

-- Insert Feeding Categories
INSERT INTO feeding_categories (title, items, quantity, cost) VALUES
('Green Fodder', 
    ARRAY['Berseem (Lucerne) - Rich in protein', 'Maize fodder - High energy', 'Jowar (Sorghum) - Good bulk', 'Napier grass - Year-round availability', 'Cowpea - Protein supplement'],
    '40-50 kg/day for lactating buffalo',
    '₹2-3 per kg (₹80-150/day)'),
    
('Dry Fodder',
    ARRAY['Wheat straw', 'Paddy straw', 'Jowar straw', 'Groundnut haulms', 'Mixed grass hay'],
    '5-8 kg/day',
    '₹3-5 per kg (₹15-40/day)'),
    
('Concentrate Feed',
    ARRAY['Cotton seed cake - 30%', 'Wheat bran - 25%', 'Maize grain - 20%', 'Rice bran - 15%', 'Mineral mixture - 2%', 'Salt - 1%'],
    '1 kg per 2.5 liters milk production',
    '₹25-30 per kg (₹150-180/day for 15L milk)'),
    
('Minerals & Supplements',
    ARRAY['Calcium - 10-12 grams/day', 'Phosphorus - 8-10 grams/day', 'Common salt - 30-50 grams/day', 'Vitamin A & D supplements', 'Trace minerals (Cu, Co, Zn, Mn)'],
    'As per nutritionist recommendation',
    'Included in mineral mixture cost'),
    
('Daily Cost Summary',
    ARRAY['Green fodder: ₹100', 'Dry fodder: ₹30', 'Concentrate: ₹170', 'Total: ₹300/buffalo/day'],
    'For 15L milk production',
    '₹9,000/buffalo/month');

-- Insert Government Schemes
INSERT INTO government_schemes (name, benefit, eligibility, subsidy_amount, how_to_apply) VALUES
('National Livestock Mission (NLM)', 
    '50% subsidy on shed construction', 
    'Small & marginal farmers', 
    'Up to ₹1.60 lakh for 10 animals',
    'Apply through District Animal Husbandry Office'),
    
('Dairy Entrepreneurship Development Scheme (DEDS)',
    '25-33.33% capital subsidy',
    'Individual entrepreneurs, SHGs, cooperatives',
    'Up to ₹13.20 lakh for 10 animals',
    'Apply through NABARD or local bank'),
    
('Bank Loans for Dairy Farming',
    'Loan up to ₹1.60 lakh per animal',
    'Any farmer with land',
    '4% interest subvention under NLM',
    'Apply at nationalized banks with project report'),
    
('NABARD Subsidy Scheme',
    '25% subsidy (33.33% for SC/ST)',
    'Farmers, cooperatives, companies',
    'For units of 10+ animals',
    'Submit detailed project to NABARD office'),
    
('Kisan Credit Card (KCC)',
    'Working capital loan at 7% interest',
    'Farmers with dairy animals',
    '3% interest subvention (effective 4%)',
    'Any bank with land documents'),
    
('Free Artificial Insemination',
    'Free AI services',
    'All dairy farmers',
    '100% free in government centers',
    'Visit nearest government AI center');

-- Insert Success Stories
INSERT INTO success_stories (farmer_name, location, scale, investment, monthly_income, story) VALUES
('Ramesh Kumar', 'Karnal, Haryana', '8 Murrah Buffaloes', '₹7 lakhs', '₹1.5 lakhs',
    'Started with 3 buffaloes using bank loan. Now expanded to 8 and earning well. Key: bought good quality Murrah and maintained proper feeding schedule.'),
    
('Sita Devi', 'Anand, Gujarat', '5 Mehsana Buffaloes', '₹4 lakhs', '₹90,000',
    'Woman entrepreneur who started small dairy farm. Sells milk directly to 50 households at premium price. Earning more than her husband''s salary!'),
    
('Prakash Patil', 'Pune, Maharashtra', '15 Mixed Breed', '₹12 lakhs', '₹2.8 lakhs',
    'Ex-IT professional turned dairy farmer. Uses modern techniques and apps for record keeping. Supplies to 3 local sweet shops and 2 hotels.'),
    
('Manjula Reddy', 'Warangal, Telangana', '6 Murrah Buffaloes', '₹5 lakhs', '₹1.1 lakhs',
    'Started during COVID lockdown with government subsidy. Now successfully running dairy with family. Planning to expand to 10 buffaloes next year.');

-- Insert Sample Marketplace Listings
INSERT INTO marketplace_listings (user_id, listing_type, breed, age, milk_yield, price, location, contact, verified, status) VALUES
(NULL, 'sell', 'Murrah', '3 years', '18 L/day', '₹85,000', 'Karnal, Haryana', '+91-98XXX-XXXXX', TRUE, 'active'),
(NULL, 'sell', 'Jaffarabadi', '4 years', '14 L/day', '₹95,000', 'Rajkot, Gujarat', '+91-97XXX-XXXXX', TRUE, 'active'),
(NULL, 'buy', 'Murrah', NULL, NULL, NULL, 'Hisar, Haryana', '+91-96XXX-XXXXX', FALSE, 'active'),
(NULL, 'sell', 'Nili-Ravi', '2.5 years', '15 L/day', '₹75,000', 'Ludhiana, Punjab', '+91-98XXX-XXXXX', TRUE, 'active'),
(NULL, 'sell', 'Mehsana', '3.5 years', '12 L/day', '₹65,000', 'Mehsana, Gujarat', '+91-99XXX-XXXXX', TRUE, 'active');

-- Update the buy listing with requirement and budget
UPDATE marketplace_listings 
SET requirement = 'High-yielding, 2-4 years', budget = '₹70,000-90,000'
WHERE listing_type = 'buy' AND breed = 'Murrah';

-- Create indexes for better performance
CREATE INDEX idx_breeds_name ON breeds(name);
CREATE INDEX idx_diseases_name ON diseases(name);
CREATE INDEX idx_diseases_type ON diseases(type);
CREATE INDEX idx_marketplace_type ON marketplace_listings(listing_type);
CREATE INDEX idx_marketplace_status ON marketplace_listings(status);
CREATE INDEX idx_marketplace_breed ON marketplace_listings(breed);

-- Create a view for active marketplace listings with full details
CREATE VIEW active_marketplace AS
SELECT 
    ml.*,
    u.username,
    u.email
FROM marketplace_listings ml
LEFT JOIN users u ON ml.user_id = u.id
WHERE ml.status = 'active'
ORDER BY ml.created_at DESC;

COMMIT;
