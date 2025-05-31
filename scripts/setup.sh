#!/bin/bash

# Crystal Grimoire Beta2 - Setup Script
# This script sets up the development environment

set -e

echo "🔮 Setting up Crystal Grimoire Beta2 development environment..."

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter is not installed. Please install Flutter first."
    echo "Visit: https://docs.flutter.dev/get-started/install"
    exit 1
fi

# Check if Python is installed
if ! command -v python3 &> /dev/null; then
    echo "❌ Python 3 is not installed. Please install Python 3 first."
    exit 1
fi

echo "✅ Flutter and Python detected"

# Setup Flutter dependencies
echo "📱 Setting up Flutter dependencies..."
cd crystal_grimoire_flutter
flutter pub get
flutter doctor
cd ..

# Setup Python backend
echo "🐍 Setting up Python backend..."
cd backend
python3 -m venv venv
source venv/bin/activate
pip install -r requirements_simple.txt
cd ..

# Copy environment file
echo "⚙️ Setting up environment configuration..."
if [ ! -f ".env" ]; then
    cp .env.example .env
    echo "📝 Created .env file from example. Please update with your actual credentials."
else
    echo "✅ .env file already exists"
fi

# Create necessary directories
echo "📁 Creating necessary directories..."
mkdir -p logs
mkdir -p temp
mkdir -p backups

echo "✨ Setup complete!"
echo ""
echo "Next steps:"
echo "1. Update .env file with your actual API keys and credentials"
echo "2. Set up Firebase project and download configuration files"
echo "3. Configure RevenueCat and AdMob accounts"
echo "4. Run 'flutter run' in crystal_grimoire_flutter/ to start development"
echo "5. Run 'python backend/simple_backend.py' to start the backend server"
echo ""
echo "For more details, see README.md and docs/ folder."
echo "🔮 Happy coding!"
