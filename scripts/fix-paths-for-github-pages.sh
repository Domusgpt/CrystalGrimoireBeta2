#!/bin/bash

# Fix paths for GitHub Pages deployment in subdirectory
# This script updates absolute paths after Flutter build

echo "Fixing paths for GitHub Pages deployment..."

# Update manifest.json icon paths
sed -i 's|"src": "icons/|"src": "/CrystalGrimoireBeta2/icons/|g' ../manifest.json

# Update index.html favicon and manifest paths
sed -i 's|href="favicon.png"|href="/CrystalGrimoireBeta2/favicon.png"|g' ../index.html
sed -i 's|href="manifest.json"|href="/CrystalGrimoireBeta2/manifest.json"|g' ../index.html
sed -i 's|href="icons/Icon-192.png"|href="/CrystalGrimoireBeta2/icons/Icon-192.png"|g' ../index.html

echo "Path fixes applied successfully!"