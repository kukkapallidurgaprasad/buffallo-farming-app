# Buffalo Farming Information System

A complete full-stack web application for buffalo farming information, built with **Python Flask**, **PostgreSQL**, and **HTML/JavaScript**.

## 🎯 Features

- **Buffalo Breeds Database**: Comprehensive information on 7+ major Indian buffalo breeds
- **Disease Management**: Common diseases, symptoms, treatments, and prevention
- **Feeding Guide**: Nutrition requirements, feeding schedules, and cost calculations
- **Government Schemes**: Information on subsidies and financial support
- **Success Stories**: Real farmer experiences and income details
- **Marketplace**: Buy/sell buffalo listings with verification
- **RESTful API**: Complete backend API for all operations
- **Responsive UI**: Mobile-friendly interface

## 📋 Prerequisites

- Python 3.8 or higher
- PostgreSQL 12 or higher
- pip (Python package manager)
- Web browser

## 🚀 Installation & Setup

### 1. Clone/Download the Project

```bash
cd buffalo-farming-app
```

### 2. Set Up PostgreSQL Database

**Create Database:**
```bash
# Login to PostgreSQL
psql -U postgres

# Create database
CREATE DATABASE buffalo_farming;

# Exit psql
\q
```

**Import Schema:**
```bash
# Run the schema file to create tables and insert sample data
psql -U postgres -d buffalo_farming -f database/schema.sql
```

### 3. Set Up Python Backend

**Navigate to backend directory:**
```bash
cd backend
```

**Create virtual environment:**
```bash
python -m venv venv

# Activate virtual environment
# On Windows:
venv\Scripts\activate
# On Mac/Linux:
source venv/bin/activate
```

**Install dependencies:**
```bash
pip install -r requirements.txt
```

**Configure Environment Variables:**
```bash
# Copy example env file
cp .env.example .env

# Edit .env file with your database credentials
# DATABASE_URL=postgresql://postgres:YOUR_PASSWORD@localhost:5432/buffalo_farming
```

**Run the Flask Application:**
```bash
python app.py
```

The backend will run on `http://localhost:5000`

### 4. Set Up Frontend

**Open another terminal and navigate to frontend:**
```bash
cd frontend
```

**Start a simple HTTP server:**

**Option 1 - Python:**
```bash
# Python 3
python -m http.server 8000

# Or Python 2
python -m SimpleHTTPServer 8000
```

**Option 2 - Node.js (if installed):**
```bash
npx http-server -p 8000
```

**Option 3 - Just open the file:**
Simply open `index.html` in your browser (update API_URL in the file to use CORS)

The frontend will be available at `http://localhost:8000`

## 📡 API Endpoints

### Statistics
```
GET /api/stats - Get application statistics
```

### Breeds
```
GET /api/breeds - Get all breeds
GET /api/breeds?search=murrah - Search breeds
GET /api/breeds/:id - Get single breed
```

### Diseases
```
GET /api/diseases - Get all diseases
GET /api/diseases?search=mastitis - Search diseases
GET /api/diseases?type=viral - Filter by type
GET /api/diseases/:id - Get single disease
```

### Feeding
```
GET /api/feeding - Get feeding guide
```

### Government Schemes
```
GET /api/schemes - Get all schemes
```

### Success Stories
```
GET /api/success-stories - Get all success stories
```

### Marketplace
```
GET /api/marketplace - Get all listings
GET /api/marketplace?type=sell - Filter by type (sell/buy)
GET /api/marketplace?breed=murrah - Filter by breed
GET /api/marketplace/:id - Get single listing
POST /api/marketplace - Create new listing
PUT /api/marketplace/:id - Update listing
DELETE /api/marketplace/:id - Delete listing
```

## 🗄️ Database Schema

### Tables
- `users` - User accounts
- `breeds` - Buffalo breed information
- `diseases` - Disease information
- `disease_medicines` - Medicines for each disease
- `feeding_categories` - Feeding guidelines
- `government_schemes` - Government subsidy schemes
- `success_stories` - Farmer success stories
- `marketplace_listings` - Buy/sell listings

## 💡 Usage Examples

### Creating a Marketplace Listing (POST request)

```bash
curl -X POST http://localhost:5000/api/marketplace \
  -H "Content-Type: application/json" \
  -d '{
    "type": "sell",
    "breed": "Murrah",
    "age": "3 years",
    "milkYield": "18 L/day",
    "price": "₹85,000",
    "location": "Karnal, Haryana",
    "contact": "+91-98XXXXXXXX"
  }'
```

### Searching Breeds

```bash
curl http://localhost:5000/api/breeds?search=murrah
```

## 🔧 Configuration

### Database Configuration
Edit `backend/.env`:
```env
DATABASE_URL=postgresql://username:password@localhost:5432/buffalo_farming
SECRET_KEY=your-secret-key-here
```

### Frontend Configuration
Edit `frontend/index.html` (line with `API_URL`):
```javascript
const API_URL = 'http://localhost:5000/api';
```

## 📊 Sample Data

The database schema includes sample data for:
- 7 Buffalo Breeds (Murrah, Jaffarabadi, Nili-Ravi, etc.)
- 6 Common Diseases (FMD, Mastitis, HS, etc.)
- 5 Feeding Categories
- 6 Government Schemes
- 4 Success Stories
- 5 Marketplace Listings

## 🛠️ Development

### Adding New Features

**1. Add Database Table:**
```sql
-- Add to database/schema.sql
CREATE TABLE your_table (...);
```

**2. Create Model in Flask:**
```python
# Add to backend/app.py
class YourModel(db.Model):
    __tablename__ = 'your_table'
    # ... fields
```

**3. Create API Endpoint:**
```python
@app.route('/api/your-endpoint')
def your_endpoint():
    # ... logic
```

**4. Add Frontend Display:**
```javascript
// Add to frontend/index.html
function loadYourData() {
    // ... fetch and display
}
```

## 🐛 Troubleshooting

### Database Connection Error
- Check PostgreSQL is running: `sudo service postgresql status`
- Verify credentials in `.env` file
- Ensure database exists: `psql -U postgres -l`

### Port Already in Use
- Change Flask port in `app.py`: `app.run(port=5001)`
- Change frontend port: `python -m http.server 8001`

### CORS Error
- Ensure Flask-CORS is installed
- Check API_URL in frontend matches backend URL

## 📝 License

This project is for educational and informational purposes.

## 🤝 Contributing

Contributions are welcome! Please feel free to submit pull requests.

## 📧 Support

For issues and questions, please create an issue in the repository.

## 🌟 Future Enhancements

- [ ] User authentication and authorization
- [ ] Advanced search and filtering
- [ ] Image upload for buffalo listings
- [ ] SMS/Email notifications
- [ ] Mobile app version
- [ ] Multi-language support
- [ ] Analytics dashboard
- [ ] Export to PDF/Excel
- [ ] Real-time chat for marketplace
- [ ] Payment gateway integration

---

**Made with ❤️ for Indian Buffalo Farmers**
