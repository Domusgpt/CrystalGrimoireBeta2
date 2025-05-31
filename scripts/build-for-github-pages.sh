#!/bin/bash

# Build Flutter web app for GitHub Pages deployment

# Exit on error
set -e

echo "Building Crystal Grimoire for GitHub Pages..."

# Navigate to flutter project
cd ../crystal_grimoire_flutter

# Clean previous build
echo "Cleaning previous build..."
flutter clean

# Get dependencies
echo "Getting dependencies..."
flutter pub get

# Build for web with base href
echo "Building for web with base href..."
flutter build web --release --base-href="/CrystalGrimoireBeta2/"

# Copy build output to root
echo "Copying build output..."
cp -r build/web/* ../

# Navigate back to scripts directory
cd ../scripts

# Fix absolute paths for GitHub Pages
echo "Fixing paths for GitHub Pages..."
./fix-paths-for-github-pages.sh

echo "Build complete! Ready to commit and push to GitHub."