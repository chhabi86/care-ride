# CareRide Multi-Repository Setup Guide

## 🏗️ Architecture Overview

You have two separate repositories:
- **Frontend Repository**: `chhabi86/care-ride` (Angular TypeScript)
- **Backend Repository**: `chhabi86/care-ride-site-chhabi` (Spring Boot Java)

## 📁 Recommended Local Structure

```
~/Documents/
├── care-ride-frontend/          # Clone of chhabi86/care-ride
│   ├── src/
│   ├── package.json
│   ├── angular.json
│   └── .github/workflows/
└── care-ride-backend/           # Clone of chhabi86/care-ride-site-chhabi  
    ├── src/
    ├── pom.xml
    ├── docker-compose.yml
    └── .github/workflows/
```

## 🚀 Setup Instructions

### 1. Clone Both Repositories Separately

```bash
cd ~/Documents
git clone https://github.com/chhabi86/care-ride.git care-ride-frontend
git clone https://github.com/chhabi86/care-ride-site-chhabi.git care-ride-backend
```

### 2. Backend Setup (Spring Boot)
```bash
cd care-ride-backend
# Add CI/CD workflow for backend deployment
# Configure Docker deployment
# Set up database connections
```

### 3. Frontend Setup (Angular)
```bash
cd care-ride-frontend  
# Add CI/CD workflow for frontend deployment
# Configure API proxy to backend
# Set up static file deployment
```

### 4. Local Development Scripts
- Backend: `./start-backend.sh` (runs Spring Boot + PostgreSQL)
- Frontend: `./start-frontend.sh` (runs Angular dev server with API proxy)
- Combined: `./start-all.sh` (starts both with proper configuration)

## 🔄 CI/CD Strategy

### Backend CI/CD:
- Build Spring Boot JAR
- Run tests
- Build Docker image
- Deploy to server port 8080
- Health checks

### Frontend CI/CD:
- Build Angular app
- Run tests  
- Generate static files
- Deploy to Nginx
- Configure reverse proxy to backend

## 🌐 Production Architecture
```
[Domain] → [Nginx] → [Angular Static Files]
                  → [/api/*] → [Spring Boot :8080]
```
