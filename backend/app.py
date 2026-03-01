"""
Buffalo Farming Application - Flask Backend
Main Application File
"""

from flask import Flask, jsonify, request
from flask_cors import CORS
from flask_sqlalchemy import SQLAlchemy
from werkzeug.security import generate_password_hash, check_password_hash
from datetime import datetime
import os

# Initialize Flask app
app = Flask(__name__)
DATABASE_URL = os.environ.get("DATABASE_URL")

if DATABASE_URL:
    if DATABASE_URL.startswith("postgres://"):
        DATABASE_URL = DATABASE_URL.replace("postgres://", "postgresql://", 1)
    app.config["SQLALCHEMY_DATABASE_URI"] = DATABASE_URL
else:
    app.config["SQLALCHEMY_DATABASE_URI"] = "sqlite:///buffalo.db"

app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False

db = SQLAlchemy(app)
CORS(app)  # Enable CORS for frontend

# Database Configuration
DATABASE_URL = os.getenv('DATABASE_URL', 'postgresql://postgres:user@localhost:5432/buffalo_farming')
# Fix for Render/Heroku: postgres:// to postgresql://
if DATABASE_URL.startswith('postgres://'):
    DATABASE_URL = DATABASE_URL.replace('postgres://', 'postgresql://', 1)

app.config['SQLALCHEMY_DATABASE_URI'] = DATABASE_URL
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
app.config['SECRET_KEY'] = os.getenv('SECRET_KEY', 'your-secret-key-change-in-production')

# Initialize Database
    db.init_app(app)   # ✅ attach to app here

#db = SQLAlchemy(app)


# ===========================
# Database Models
# ===========================

class User(db.Model):
    __tablename__ = 'users'
    
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(100), unique=True, nullable=False)
    email = db.Column(db.String(150), unique=True, nullable=False)
    password_hash = db.Column(db.String(255), nullable=False)
    phone = db.Column(db.String(20))
    location = db.Column(db.String(200))
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    
    def set_password(self, password):
        self.password_hash = generate_password_hash(password)
    
    def check_password(self, password):
        return check_password_hash(self.password_hash, password)
    
    def to_dict(self):
        return {
            'id': self.id,
            'username': self.username,
            'email': self.email,
            'phone': self.phone,
            'location': self.location,
            'created_at': self.created_at.isoformat()
        }


class Breed(db.Model):
    __tablename__ = 'breeds'
    
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(100), nullable=False)
    state = db.Column(db.String(200))
    color = db.Column(db.String(100))
    milk_yield = db.Column(db.String(50))
    fat_content = db.Column(db.String(20))
    weight = db.Column(db.String(50))
    features = db.Column(db.Text)
    nickname = db.Column(db.String(100))
    best_for = db.Column(db.String(200))
    price_range = db.Column(db.String(50))
    image_url = db.Column(db.String(255))
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    
    def to_dict(self):
        return {
            'id': self.id,
            'name': self.name,
            'state': self.state,
            'color': self.color,
            'milkYield': self.milk_yield,
            'fatContent': self.fat_content,
            'weight': self.weight,
            'features': self.features,
            'nickname': self.nickname,
            'bestFor': self.best_for,
            'price': self.price_range,
            'image': self.image_url
        }


class Disease(db.Model):
    __tablename__ = 'diseases'
    
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(150), nullable=False)
    type = db.Column(db.String(50))
    severity = db.Column(db.String(50))
    symptoms = db.Column(db.ARRAY(db.Text))
    treatment = db.Column(db.ARRAY(db.Text))
    prevention = db.Column(db.ARRAY(db.Text))
    cost_range = db.Column(db.String(50))
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    
    medicines = db.relationship('DiseaseMedicine', backref='disease', lazy=True, cascade='all, delete-orphan')
    
    def to_dict(self):
        return {
            'id': self.id,
            'name': self.name,
            'type': self.type,
            'severity': self.severity,
            'symptoms': self.symptoms,
            'treatment': self.treatment,
            'prevention': self.prevention,
            'cost': self.cost_range,
            'medicines': [m.medicine_name for m in self.medicines]
        }


class DiseaseMedicine(db.Model):
    __tablename__ = 'disease_medicines'
    
    id = db.Column(db.Integer, primary_key=True)
    disease_id = db.Column(db.Integer, db.ForeignKey('diseases.id', ondelete='CASCADE'), nullable=False)
    medicine_name = db.Column(db.String(150), nullable=False)
    dosage = db.Column(db.String(100))
    created_at = db.Column(db.DateTime, default=datetime.utcnow)


class FeedingCategory(db.Model):
    __tablename__ = 'feeding_categories'
    
    id = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.String(100), nullable=False)
    items = db.Column(db.ARRAY(db.Text))
    quantity = db.Column(db.String(100))
    cost = db.Column(db.String(100))
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    
    def to_dict(self):
        return {
            'id': self.id,
            'title': self.title,
            'items': self.items,
            'quantity': self.quantity,
            'cost': self.cost
        }


class GovernmentScheme(db.Model):
    __tablename__ = 'government_schemes'
    
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(200), nullable=False)
    benefit = db.Column(db.Text)
    eligibility = db.Column(db.Text)
    subsidy_amount = db.Column(db.String(100))
    how_to_apply = db.Column(db.Text)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    
    def to_dict(self):
        return {
            'id': self.id,
            'name': self.name,
            'benefit': self.benefit,
            'eligibility': self.eligibility,
            'subsidy': self.subsidy_amount,
            'howToApply': self.how_to_apply
        }


class SuccessStory(db.Model):
    __tablename__ = 'success_stories'
    
    id = db.Column(db.Integer, primary_key=True)
    farmer_name = db.Column(db.String(100), nullable=False)
    location = db.Column(db.String(150))
    scale = db.Column(db.String(100))
    investment = db.Column(db.String(50))
    monthly_income = db.Column(db.String(50))
    story = db.Column(db.Text)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    
    def to_dict(self):
        return {
            'id': self.id,
            'name': self.farmer_name,
            'location': self.location,
            'scale': self.scale,
            'investment': self.investment,
            'monthlyIncome': self.monthly_income,
            'story': self.story
        }


class MarketplaceListing(db.Model):
    __tablename__ = 'marketplace_listings'
    
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('users.id', ondelete='CASCADE'))
    listing_type = db.Column(db.String(20), nullable=False)  # 'sell' or 'buy'
    breed = db.Column(db.String(100))
    age = db.Column(db.String(50))
    milk_yield = db.Column(db.String(50))
    price = db.Column(db.String(50))
    budget = db.Column(db.String(50))
    requirement = db.Column(db.Text)
    location = db.Column(db.String(200))
    contact = db.Column(db.String(50))
    verified = db.Column(db.Boolean, default=False)
    status = db.Column(db.String(20), default='active')  # 'active', 'sold', 'inactive'
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    
    def to_dict(self):
        return {
            'id': self.id,
            'type': self.listing_type,
            'breed': self.breed,
            'age': self.age,
            'milkYield': self.milk_yield,
            'price': self.price,
            'budget': self.budget,
            'requirement': self.requirement,
            'location': self.location,
            'contact': self.contact,
            'verified': self.verified,
            'status': self.status,
            'createdAt': self.created_at.isoformat()
        }


# ===========================
# API Routes
# ===========================

@app.route('/')
def index():
    return jsonify({
        'message': 'Buffalo Farming API',
        'version': '1.0',
        'endpoints': {
            'breeds': '/api/breeds',
            'diseases': '/api/diseases',
            'feeding': '/api/feeding',
            'schemes': '/api/schemes',
            'success': '/api/success-stories',
            'market': '/api/marketplace'
        }
    })


# ===========================
# Breeds Routes
# ===========================

@app.route('/api/breeds', methods=['GET'])
def get_breeds():
    """Get all buffalo breeds"""
    try:
        search = request.args.get('search', '')
        
        query = Breed.query
        if search:
            query = query.filter(
                db.or_(
                    Breed.name.ilike(f'%{search}%'),
                    Breed.state.ilike(f'%{search}%')
                )
            )
        
        breeds = query.all()
        return jsonify({
            'success': True,
            'data': [breed.to_dict() for breed in breeds],
            'count': len(breeds)
        })
    except Exception as e:
        return jsonify({'success': False, 'error': str(e)}), 500


@app.route('/api/breeds/<int:breed_id>', methods=['GET'])
def get_breed(breed_id):
    """Get single breed by ID"""
    try:
        breed = Breed.query.get_or_404(breed_id)
        return jsonify({
            'success': True,
            'data': breed.to_dict()
        })
    except Exception as e:
        return jsonify({'success': False, 'error': str(e)}), 404


# ===========================
# Diseases Routes
# ===========================

@app.route('/api/diseases', methods=['GET'])
def get_diseases():
    """Get all diseases"""
    try:
        search = request.args.get('search', '')
        disease_type = request.args.get('type', '')
        
        query = Disease.query
        if search:
            query = query.filter(Disease.name.ilike(f'%{search}%'))
        if disease_type:
            query = query.filter(Disease.type == disease_type)
        
        diseases = query.all()
        return jsonify({
            'success': True,
            'data': [disease.to_dict() for disease in diseases],
            'count': len(diseases)
        })
    except Exception as e:
        return jsonify({'success': False, 'error': str(e)}), 500


@app.route('/api/diseases/<int:disease_id>', methods=['GET'])
def get_disease(disease_id):
    """Get single disease by ID"""
    try:
        disease = Disease.query.get_or_404(disease_id)
        return jsonify({
            'success': True,
            'data': disease.to_dict()
        })
    except Exception as e:
        return jsonify({'success': False, 'error': str(e)}), 404


# ===========================
# Feeding Routes
# ===========================

@app.route('/api/feeding', methods=['GET'])
def get_feeding():
    """Get all feeding categories"""
    try:
        categories = FeedingCategory.query.all()
        return jsonify({
            'success': True,
            'data': {
                'categories': [cat.to_dict() for cat in categories],
                'waterRequirements': '60-80 liters/day (more in summer and for lactating animals)',
                'feedingSchedule': [
                    'Morning (6-7 AM): Green fodder + concentrate',
                    'Mid-day (12-1 PM): Dry fodder + water',
                    'Evening (5-6 PM): Green fodder + concentrate',
                    'Night (9-10 PM): Dry fodder + water'
                ]
            }
        })
    except Exception as e:
        return jsonify({'success': False, 'error': str(e)}), 500


# ===========================
# Government Schemes Routes
# ===========================

@app.route('/api/schemes', methods=['GET'])
def get_schemes():
    """Get all government schemes"""
    try:
        schemes = GovernmentScheme.query.all()
        return jsonify({
            'success': True,
            'data': [scheme.to_dict() for scheme in schemes],
            'count': len(schemes)
        })
    except Exception as e:
        return jsonify({'success': False, 'error': str(e)}), 500


# ===========================
# Success Stories Routes
# ===========================

@app.route('/api/success-stories', methods=['GET'])
def get_success_stories():
    """Get all success stories"""
    try:
        stories = SuccessStory.query.all()
        return jsonify({
            'success': True,
            'data': [story.to_dict() for story in stories],
            'count': len(stories)
        })
    except Exception as e:
        return jsonify({'success': False, 'error': str(e)}), 500


# ===========================
# Marketplace Routes
# ===========================

@app.route('/api/marketplace', methods=['GET'])
def get_marketplace_listings():
    """Get all marketplace listings"""
    try:
        listing_type = request.args.get('type', '')  # 'sell' or 'buy'
        breed = request.args.get('breed', '')
        
        query = MarketplaceListing.query.filter_by(status='active')
        
        if listing_type:
            query = query.filter_by(listing_type=listing_type)
        if breed:
            query = query.filter(MarketplaceListing.breed.ilike(f'%{breed}%'))
        
        listings = query.order_by(MarketplaceListing.created_at.desc()).all()
        return jsonify({
            'success': True,
            'data': [listing.to_dict() for listing in listings],
            'count': len(listings)
        })
    except Exception as e:
        return jsonify({'success': False, 'error': str(e)}), 500


@app.route('/api/marketplace', methods=['POST'])
def create_marketplace_listing():
    """Create new marketplace listing"""
    try:
        data = request.get_json()
        
        listing = MarketplaceListing(
            listing_type=data.get('type'),
            breed=data.get('breed'),
            age=data.get('age'),
            milk_yield=data.get('milkYield'),
            price=data.get('price'),
            budget=data.get('budget'),
            requirement=data.get('requirement'),
            location=data.get('location'),
            contact=data.get('contact')
        )
        
        db.session.add(listing)
        db.session.commit()
        
        return jsonify({
            'success': True,
            'message': 'Listing created successfully',
            'data': listing.to_dict()
        }), 201
    except Exception as e:
        db.session.rollback()
        return jsonify({'success': False, 'error': str(e)}), 500


@app.route('/api/marketplace/<int:listing_id>', methods=['GET'])
def get_marketplace_listing(listing_id):
    """Get single marketplace listing"""
    try:
        listing = MarketplaceListing.query.get_or_404(listing_id)
        return jsonify({
            'success': True,
            'data': listing.to_dict()
        })
    except Exception as e:
        return jsonify({'success': False, 'error': str(e)}), 404


@app.route('/api/marketplace/<int:listing_id>', methods=['PUT'])
def update_marketplace_listing(listing_id):
    """Update marketplace listing"""
    try:
        listing = MarketplaceListing.query.get_or_404(listing_id)
        data = request.get_json()
        
        if 'status' in data:
            listing.status = data['status']
        if 'price' in data:
            listing.price = data['price']
        if 'contact' in data:
            listing.contact = data['contact']
        
        listing.updated_at = datetime.utcnow()
        db.session.commit()
        
        return jsonify({
            'success': True,
            'message': 'Listing updated successfully',
            'data': listing.to_dict()
        })
    except Exception as e:
        db.session.rollback()
        return jsonify({'success': False, 'error': str(e)}), 500


@app.route('/api/marketplace/<int:listing_id>', methods=['DELETE'])
def delete_marketplace_listing(listing_id):
    """Delete marketplace listing"""
    try:
        listing = MarketplaceListing.query.get_or_404(listing_id)
        db.session.delete(listing)
        db.session.commit()
        
        return jsonify({
            'success': True,
            'message': 'Listing deleted successfully'
        })
    except Exception as e:
        db.session.rollback()
        return jsonify({'success': False, 'error': str(e)}), 500


# ===========================
# Statistics Routes
# ===========================

@app.route('/api/stats', methods=['GET'])
def get_stats():
    """Get application statistics"""
    try:
        stats = {
            'totalBreeds': Breed.query.count(),
            'totalDiseases': Disease.query.count(),
            'totalSchemes': GovernmentScheme.query.count(),
            'activeListings': MarketplaceListing.query.filter_by(status='active').count(),
            'successStories': SuccessStory.query.count()
        }
        return jsonify({
            'success': True,
            'data': stats
        })
    except Exception as e:
        return jsonify({'success': False, 'error': str(e)}), 500


# ===========================
# Error Handlers
# ===========================

@app.errorhandler(404)
def not_found(error):
    return jsonify({'success': False, 'error': 'Resource not found'}), 404


@app.errorhandler(500)
def internal_error(error):
    db.session.rollback()
    return jsonify({'success': False, 'error': 'Internal server error'}), 500


# ===========================
# Database Initialization
# ===========================

@app.cli.command()
def init_db():
    """Initialize the database."""
    db.create_all()
    print('Database initialized!')


@app.cli.command()
def seed_db():
    """Seed the database with sample data."""
    # Run the schema.sql file
    print('Please run the schema.sql file manually using psql')
    print('Command: psql -U postgres -d buffalo_farming -f database/schema.sql')


# ===========================
# Run Application
# ===========================

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)
