#!/bin/bash

# Verify deployment and check for 404 errors

echo "Verifying Crystal Grimoire deployment..."
echo "=========================================="

BASE_URL="https://domusgpt.github.io/CrystalGrimoireBeta2"

# Function to check URL
check_url() {
    local url=$1
    local description=$2
    echo -n "Checking $description: "
    response=$(curl -s -o /dev/null -w "%{http_code}" "$url")
    if [ "$response" = "200" ]; then
        echo "✓ OK (200)"
    else
        echo "✗ FAILED ($response)"
    fi
}

# Check main resources
check_url "$BASE_URL/" "Main page"
check_url "$BASE_URL/favicon.png" "Favicon"
check_url "$BASE_URL/manifest.json" "Manifest"
check_url "$BASE_URL/icons/Icon-192.png" "Icon 192x192"
check_url "$BASE_URL/icons/Icon-512.png" "Icon 512x512"
check_url "$BASE_URL/main.dart.js" "Main JavaScript"
check_url "$BASE_URL/flutter_service_worker.js" "Service Worker"

echo ""
echo "Checking manifest.json content..."
echo "================================="
curl -s "$BASE_URL/manifest.json" | grep -E '"src":|"start_url":' | head -5

echo ""
echo "Checking index.html paths..."
echo "============================"
curl -s "$BASE_URL/" | grep -E 'favicon|manifest|apple-touch-icon' | sed 's/^/  /'

echo ""
echo "Deployment verification complete!"