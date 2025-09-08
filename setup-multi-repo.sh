#!/bin/bash

# CareRide Multi-Repository Local Development Setup
echo "🏗️ Setting up CareRide Multi-Repository Development Environment..."

# Check if we're in the right directory
if [ ! -f "MULTI_REPO_SETUP.md" ]; then
    echo "❌ Please run this script from the directory containing MULTI_REPO_SETUP.md"
    exit 1
fi

BASE_DIR="$(pwd)"
PARENT_DIR="$(dirname "$BASE_DIR")"

echo "📁 Creating separate repository structure..."

# Create the proper directory structure
mkdir -p "$PARENT_DIR/care-ride-frontend"
mkdir -p "$PARENT_DIR/care-ride-backend"

echo "📥 Cloning frontend repository (Angular)..."
if [ ! -d "$PARENT_DIR/care-ride-frontend/.git" ]; then
    git clone https://github.com/chhabi86/care-ride.git "$PARENT_DIR/care-ride-frontend"
else
    echo "Frontend repository already exists, updating..."
    cd "$PARENT_DIR/care-ride-frontend"
    git pull origin main
fi

echo "📥 Cloning backend repository (Spring Boot)..."
if [ ! -d "$PARENT_DIR/care-ride-backend/.git" ]; then
    git clone https://github.com/chhabi86/care-ride-site-chhabi.git "$PARENT_DIR/care-ride-backend"
else
    echo "Backend repository already exists, updating..."
    cd "$PARENT_DIR/care-ride-backend"
    git pull origin main
fi

echo "🔧 Setting up development scripts..."

# Create backend startup script
cat > "$PARENT_DIR/care-ride-backend/start-backend.sh" << 'EOF'
#!/bin/bash
echo "🚀 Starting CareRide Backend (Spring Boot + PostgreSQL)..."

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "⚠️  Docker Desktop is not running. Please start Docker Desktop first."
    exit 1
fi

# Start PostgreSQL database
echo "🗄️  Starting PostgreSQL database..."
docker-compose up -d db

echo "⏳ Waiting for database to be ready..."
sleep 10

# Start Spring Boot application
echo "🚀 Starting Spring Boot backend..."
if [ -f "./mvnw" ]; then
    ./mvnw spring-boot:run
else
    mvn spring-boot:run
fi
EOF

# Create frontend startup script
cat > "$PARENT_DIR/care-ride-frontend/start-frontend.sh" << 'EOF'
#!/bin/bash
echo "🎨 Starting CareRide Frontend (Angular)..."

# Install dependencies if needed
if [ ! -d "node_modules" ]; then
    echo "📦 Installing dependencies..."
    npm install
fi

# Start Angular development server with API proxy
echo "🚀 Starting Angular frontend with API proxy..."
npm start -- --proxy-config proxy.conf.json --port 4201
EOF

# Create combined startup script
cat > "$PARENT_DIR/start-care-ride.sh" << 'EOF'
#!/bin/bash
echo "🚗 Starting Complete CareRide Development Environment..."

# Start backend in background
echo "🚀 Starting backend..."
cd care-ride-backend
chmod +x start-backend.sh
./start-backend.sh &
BACKEND_PID=$!

# Wait for backend to start
echo "⏳ Waiting for backend to initialize..."
sleep 30

# Start frontend
echo "🎨 Starting frontend..."
cd ../care-ride-frontend
chmod +x start-frontend.sh
./start-frontend.sh &
FRONTEND_PID=$!

echo ""
echo "✅ CareRide Development Environment Started!"
echo ""
echo "📋 Services:"
echo "   🗄️  Database:  http://localhost:5432 (PostgreSQL)"
echo "   🚀 Backend:   http://localhost:8080 (Spring Boot API)"
echo "   🎨 Frontend:  http://localhost:4201 (Angular App)"
echo ""
echo "🌐 Open your browser to: http://localhost:4201"
echo ""
echo "To stop all services:"
echo "   kill $BACKEND_PID $FRONTEND_PID"
echo ""

# Wait for user input to stop
echo "Press Ctrl+C to stop all services..."
trap 'echo "🛑 Stopping services..."; kill $BACKEND_PID $FRONTEND_PID 2>/dev/null; exit' INT
wait
EOF

# Make scripts executable
chmod +x "$PARENT_DIR/care-ride-backend/start-backend.sh"
chmod +x "$PARENT_DIR/care-ride-frontend/start-frontend.sh"
chmod +x "$PARENT_DIR/start-care-ride.sh"

echo ""
echo "✅ Multi-repository setup completed!"
echo ""
echo "📁 Directory structure:"
echo "   $PARENT_DIR/"
echo "   ├── care-ride-frontend/ (Angular TypeScript)"
echo "   ├── care-ride-backend/  (Spring Boot Java)" 
echo "   └── start-care-ride.sh  (Combined startup)"
echo ""
echo "🚀 To start development:"
echo "   cd $PARENT_DIR"
echo "   ./start-care-ride.sh"
echo ""
echo "📝 Next steps:"
echo "   1. Set up CI/CD workflows for each repository"
echo "   2. Configure API proxy in frontend"
echo "   3. Set up production deployment scripts"
echo ""
