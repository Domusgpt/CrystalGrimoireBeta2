#!/bin/bash

# Crystal Grimoire Beta2 - Deployment Script
# This script handles deployment to various platforms

set -e

PLATFORM=${1:-"web"}
ENVIRONMENT=${2:-"production"}

echo "🚀 Deploying Crystal Grimoire Beta2 to $PLATFORM ($ENVIRONMENT)..."

# Navigate to Flutter directory
cd crystal_grimoire_flutter

# Run tests first
echo "🧪 Running tests..."
flutter test

# Analyze code
echo "🔍 Analyzing code..."
flutter analyze

# Format code
echo "🎨 Formatting code..."
flutter format . --set-exit-if-changed

case $PLATFORM in
    "web")
        echo "🌐 Building for web..."
        flutter build web --release --dart-define=FLUTTER_WEB_USE_SKIA=true
        echo "✅ Web build complete. Files in build/web/"
        ;;
    "android")
        echo "🤖 Building for Android..."
        flutter build appbundle --release
        echo "✅ Android build complete. File: build/app/outputs/bundle/release/app-release.aab"
        ;;
    "ios")
        echo "🍏 Building for iOS..."
        flutter build ios --release
        echo "✅ iOS build complete. Open ios/Runner.xcworkspace in Xcode to archive."
        ;;
    "all")
        echo "🌍 Building for all platforms..."
        flutter build web --release --dart-define=FLUTTER_WEB_USE_SKIA=true
        flutter build appbundle --release
        flutter build ios --release
        echo "✅ All builds complete!"
        ;;
    *)
        echo "❌ Unknown platform: $PLATFORM"
        echo "Usage: ./deploy.sh [web|android|ios|all] [development|production]"
        exit 1
        ;;
esac

cd ..

# Deploy backend if needed
if [ "$ENVIRONMENT" = "production" ]; then
    echo "🐍 Checking backend deployment..."
    if [ -f "backend/render.yaml" ]; then
        echo "🌐 Backend configured for Render.com deployment"
        echo "To deploy backend: git push to your Render.com connected repository"
    fi
fi

echo "✨ Deployment process complete!"
echo ""
echo "Next steps:"
case $PLATFORM in
    "web")
        echo "- Upload build/web/ contents to your web hosting service"
        echo "- Update DNS if using custom domain"
        ;;
    "android")
        echo "- Upload build/app/outputs/bundle/release/app-release.aab to Google Play Console"
        echo "- Update store listing and screenshots"
        ;;
    "ios")
        echo "- Open ios/Runner.xcworkspace in Xcode"
        echo "- Archive and upload to App Store Connect"
        echo "- Update store listing and screenshots"
        ;;
esac
echo "🔮 Good luck with your release!"
