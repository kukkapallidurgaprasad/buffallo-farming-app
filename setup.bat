@echo off
REM Buffalo Farming App - Quick Start Script for Windows

echo =========================================
echo Buffalo Farming App - Quick Setup
echo =========================================
echo.

REM Check Python
echo Checking Python installation...
python --version >nul 2>&1
if errorlevel 1 (
    echo X Python is not installed. Please install Python 3.8+
    pause
    exit /b 1
)
echo Y Python found
echo.

REM Check PostgreSQL
echo Checking PostgreSQL installation...
psql --version >nul 2>&1
if errorlevel 1 (
    echo X PostgreSQL is not installed. Please install PostgreSQL 12+
    pause
    exit /b 1
)
echo Y PostgreSQL found
echo.

REM Get database credentials
set /p DB_USER="Enter PostgreSQL username (default: postgres): "
if "%DB_USER%"=="" set DB_USER=postgres

set /p DB_PASS="Enter PostgreSQL password: "

set DB_NAME=buffalo_farming

REM Set PostgreSQL password for commands
set PGPASSWORD=%DB_PASS%

REM Create database
echo.
echo Creating database...
psql -U %DB_USER% -c "CREATE DATABASE %DB_NAME%;" 2>nul
echo Y Database created (or already exists)
echo.

REM Import schema
echo Importing database schema...
psql -U %DB_USER% -d %DB_NAME% -f database\schema.sql
if errorlevel 1 (
    echo X Failed to import schema
    pause
    exit /b 1
)
echo Y Schema imported successfully
echo.

REM Set up Python backend
echo Setting up Python backend...
cd backend

REM Create virtual environment
if not exist "venv" (
    echo Creating virtual environment...
    python -m venv venv
    echo Y Virtual environment created
)

REM Activate virtual environment
call venv\Scripts\activate

REM Install dependencies
echo Installing Python dependencies...
pip install -r requirements.txt -q
if errorlevel 1 (
    echo X Failed to install dependencies
    pause
    exit /b 1
)
echo Y Dependencies installed
echo.

REM Create .env file
echo Creating .env file...
(
echo DATABASE_URL=postgresql://%DB_USER%:%DB_PASS%@localhost:5432/%DB_NAME%
echo FLASK_APP=app.py
echo FLASK_ENV=development
echo SECRET_KEY=change-this-secret-key-in-production
echo PORT=5000
echo HOST=0.0.0.0
) > .env
echo Y .env file created
echo.

cd ..

echo =========================================
echo Y Setup Complete!
echo =========================================
echo.
echo To start the application:
echo.
echo 1. Start Backend (Command Prompt 1):
echo    cd backend
echo    venv\Scripts\activate
echo    python app.py
echo.
echo 2. Start Frontend (Command Prompt 2):
echo    cd frontend
echo    python -m http.server 8000
echo.
echo 3. Open browser:
echo    http://localhost:8000
echo.
echo API will be available at:
echo    http://localhost:5000/api
echo.
echo =========================================
pause
