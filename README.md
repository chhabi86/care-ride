# CareRide Solutions - Medical Transportation Platform

A full-stack web application providing specialized medical transportation services with comprehensive patient care and safety features.

## 🚀 Live Application

**Production URL:** https://careridesolutionspa.com  
**IP Address:** http://167.99.55.181 (direct access)  
**Auto-Deploy:** ✅ Active - Updates automatically on push

## 📋 Project Overview

CareRide Solutions is a specialized medical transportation platform featuring:

- **Angular Frontend**: Modern, responsive patient and caregiver interface
- **Spring Boot Backend**: Robust API with JWT authentication and database integration
- **PostgreSQL Database**: Reliable data persistence for appointments and patient records
- **Professional Deployment**: Full production setup on DigitalOcean with SSL and CDN

## 🛠 Technology Stack

### Frontend
- **Angular 17+** - Modern TypeScript framework
- **SCSS** - Enhanced styling capabilities
- **Responsive Design** - Mobile-first approach

### Backend
- **Spring Boot 3.3.2** - Enterprise Java framework
- **Java 17** - Latest LTS version
- **Spring Security** - JWT-based authentication
- **Spring Data JPA** - Database abstraction layer
- **PostgreSQL 15** - Production database

### Infrastructure
- **Docker & Docker Compose** - Containerization
- **Nginx** - Reverse proxy and static file serving
- **DigitalOcean Droplet** - Cloud hosting (Ubuntu 24.04)
- **SSL Certificate** - HTTPS security via Let's Encrypt
- **Route 53** - DNS management

## 🚀 Quick Deployment

### One-Command Deployment
```bash
# Clone the repository
git clone https://github.com/chhabi86/care-ride.git
cd care-ride

# Run automated deployment
chmod +x deploy-droplet.sh
./deploy-droplet.sh
```

### Manual Deployment Steps

1. **Frontend Deployment**
   ```bash
   chmod +x deploy-frontend.sh
   ./deploy-frontend.sh
   ```

2. **Verify Deployment**
   ```bash
   chmod +x verify-deployment.sh
   ./verify-deployment.sh
   ```

## 🏗 Local Development

### Prerequisites
- **Docker Desktop** - Must be running
- **Node.js 18+** and npm (for frontend development)
- **Git**

### 🚀 Quick Start (Recommended)
```bash
# Start all services with one command
./start-local.sh
```

This script will automatically:
- ✅ Start PostgreSQL database (port 5432)
- ✅ Build and start Spring Boot backend (port 8080)
- ✅ Start Angular frontend (port 4201)
- ✅ Open browser to http://localhost:4201

### 🛑 Stop All Services
```bash
./stop-local.sh
```

### 📋 Service URLs
- **Frontend:** http://localhost:4201 (Angular app)
- **Backend API:** http://localhost:8080 (Spring Boot)
- **Database:** localhost:5432 (PostgreSQL)

### 🔧 Manual Setup (Alternative)

#### Step 1: Start Database & Backend
```bash
# Start database and backend containers
docker-compose -f docker-compose.local.yml up -d

# Check status
docker ps
```

#### Step 2: Start Frontend
```bash
cd frontend
npm install  # First time only
npm start -- --port 4201
```

#### Step 3: Access Application
- Frontend: http://localhost:4201
- Backend API: http://localhost:8080
- Database logs: `docker logs care-ride-site-db-1`
- Backend logs: `docker logs care-ride-site-backend-1`

## 📁 Project Structure

```
care-ride/
├── frontend/                 # Angular application
│   ├── src/
│   │   ├── app/             # Angular components and services
│   │   ├── assets/          # Static assets (images, etc.)
│   │   └── environments/    # Environment configurations
│   ├── package.json         # Node.js dependencies
│   └── angular.json         # Angular CLI configuration
├── backend/                 # Spring Boot application
│   ├── src/main/java/       # Java source code
│   ├── src/main/resources/  # Configuration files
│   │   ├── application.yml  # Spring Boot configuration
│   │   └── db/migration/    # Database migrations
│   ├── pom.xml             # Maven dependencies
│   └── Dockerfile          # Backend container definition
├── deploy-droplet.sh       # Automated deployment script
├── deploy-frontend.sh      # Frontend deployment script
├── verify-deployment.sh    # Deployment verification script
├── docker-compose.yml      # Multi-container orchestration
└── README.md              # Project documentation
```

## 🔧 Configuration

### Environment Variables

#### Backend Configuration
```bash
# Database
SPRING_DATASOURCE_URL=jdbc:postgresql://db:5432/caredb
SPRING_DATASOURCE_USERNAME=careuser
SPRING_DATASOURCE_PASSWORD=changeme_db_password

# Security
JWT_SECRET=your-256-bit-secret-key

# Server
SERVER_PORT=8080
```

#### Frontend Configuration
```typescript
// src/environments/environment.prod.ts
export const environment = {
  production: true,
  apiUrl: '/api'
};
```

### Database Configuration
```yaml
# PostgreSQL via Docker Compose
services:
  db:
    image: postgres:15
    environment:
      POSTGRES_DB: caredb
      POSTGRES_USER: careuser
      POSTGRES_PASSWORD: changeme_db_password
```

## 🔒 Security Features

- **JWT Authentication**: Secure token-based authentication
- **Spring Security**: Comprehensive security framework
- **HTTPS/SSL**: Production SSL certificate via Let's Encrypt
- **Input Validation**: Request validation and sanitization
- **CORS Configuration**: Secure cross-origin requests

## 📦 Deployment Scripts

### Automated Deployment (`deploy-droplet.sh`)
- Complete end-to-end deployment automation
- Environment setup and validation
- Docker container orchestration
- SSL certificate installation
- Health checks and verification

### Frontend Deployment (`deploy-frontend.sh`)
- Angular production build compilation
- Static asset optimization
- Nginx configuration for SPA routing
- Cache headers for performance

### Verification (`verify-deployment.sh`)
- Frontend serving verification
- Backend API health checks
- Database connectivity testing
- SSL certificate validation

## 🚧 Development Workflow

1. **Feature Development**
   - Create feature branch: `git checkout -b feature/your-feature`
   - Develop locally with hot-reload
   - Test thoroughly (frontend + backend)

2. **Testing**
   ```bash
   # Frontend tests
   cd frontend && npm test
   
   # Backend tests
   cd backend && ./mvnw test
   ```

3. **Deployment**
   ```bash
   # Deploy to production
   ./deploy-droplet.sh
   
   # Verify deployment
   ./verify-deployment.sh
   ```

## 🔍 Monitoring & Maintenance

### Health Checks
- **Frontend**: Nginx serving status
- **Backend**: Spring Boot Actuator endpoints
- **Database**: PostgreSQL connection health
- **SSL**: Certificate expiration monitoring

### Logs
```bash
# Application logs
docker logs care-ride-backend-1
docker logs care-ride-db-1

# Nginx logs
sudo tail -f /var/log/nginx/access.log
sudo tail -f /var/log/nginx/error.log
```

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🎯 Future Enhancements

- [ ] Real-time notifications via WebSocket
- [ ] Advanced appointment scheduling system
- [ ] Integration with medical record systems
- [ ] Mobile app development (React Native/Flutter)
- [ ] Advanced analytics dashboard
- [ ] Multi-language support
- [ ] Payment processing integration

## 📞 Support

For technical support or questions:
- **GitHub Issues**: [Create an issue](https://github.com/chhabi86/care-ride/issues)
- **Documentation**: Check this README and inline code comments
- **Deployment Guide**: See deployment scripts for detailed automation

---

**Built with ❤️ for better healthcare accessibility**
