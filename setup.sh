#!/bin/bash

# Buffalo Farming App - Quick Start Script
# This script helps set up the entire application

echo "========================================="
echo "Buffalo Farming App - Quick Setup"
echo "========================================="
echo ""

# Check Python
echo "Checking Python installation..."
if ! command -v python3 &> /dev/null; then
    echo "❌ Python 3 is not installed. Please install Python 3.8+"
    exit 1
fi
echo "✓ Python found: $(python3 --version)"
echo ""

# Check PostgreSQL
echo "Checking PostgreSQL installation..."
if ! command -v psql &> /dev/null; then
    echo "❌ PostgreSQL is not installed. Please install PostgreSQL 12+"
    exit 1
fi
echo "✓ PostgreSQL found"
echo ""

# Get database credentials
echo "Enter PostgreSQL credentials:"
read -p "Username (default: postgres): " DB_USER
DB_USER=${DB_USER:-postgres}

read -sp "Password: " DB_PASS
echo ""

DB_NAME="buffalo_farming"

# Create database
echo ""
echo "Creating database..."
PGPASSWORD=$DB_PASS psql -U $DB_USER -c "CREATE DATABASE $DB_NAME;" 2>/dev/null
if [ $? -eq 0 ]; then
    echo "✓ Database created successfully"
else
    echo "ℹ Database may already exist, continuing..."
fi
echo ""

# Import schema
echo "Importing database schema..."
PGPASSWORD=$DB_PASS psql -U $DB_USER -d $DB_NAME -f database/schema.sql
if [ $? -eq 0 ]; then
    echo "✓ Schema imported successfully"
else
    echo "❌ Failed to import schema"
    exit 1
fi
echo ""

# Set up Python backend
echo "Setting up Python backend..."
cd backend

# Create virtual environment
if [ ! -d "venv" ]; then
    echo "Creating virtual environment..."
    python3 -m venv venv
    echo "✓ Virtual environment created"
fi

# Activate virtual environment
source venv/bin/activate

# Install dependencies
echo "Installing Python dependencies..."
pip install -r requirements.txt -q
if [ $? -eq 0 ]; then
    echo "✓ Dependencies installed"
else
    echo "❌ Failed to install dependencies"
    exit 1
fi

# Create .env file
echo "Creating .env file..."
cat > .env << EOF
DATABASE_URL=postgresql://$DB_USER:$DB_PASS@localhost:5432/$DB_NAME
FLASK_APP=app.py
FLASK_ENV=development
SECRET_KEY=$(python3 -c 'import secrets; print(secrets.token_hex(32))')
PORT=5000
HOST=0.0.0.0
EOF
echo "✓ .env file created"
echo ""

cd ..

echo "========================================="
echo "✓ Setup Complete!"
echo "========================================="
echo ""
echo "To start the application:"
echo ""
echo "1. Start Backend (Terminal 1):"
echo "   cd backend"
echo "   source venv/bin/activate"
echo "   python app.py"
echo ""
echo "2. Start Frontend (Terminal 2):"
echo "   cd frontend"
echo "   python3 -m http.server 8000"
echo ""
echo "3. Open browser:"
echo "   http://localhost:8000"
echo ""
echo "API will be available at:"
echo "   http://localhost:5000/api"
echo ""
echo "========================================="
