#!/bin/bash

# Deployment script for gopipit.com
# This script builds and prepares the Flutter web application for deployment

set -e

echo "🚀 Starting deployment preparation for gopipit.com..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if Flutter is available
if ! command -v flutter &> /dev/null; then
    echo -e "${YELLOW}⚠️  Flutter not found. Please install Flutter first.${NC}"
    echo "Visit: https://docs.flutter.dev/get-started/install"
    exit 1
fi

echo "✅ Flutter found: $(flutter --version | head -1)"

# Clean previous builds
echo "🧹 Cleaning previous builds..."
flutter clean

# Get dependencies
echo "📦 Getting dependencies..."
flutter pub get

# Run code analysis
echo "🔍 Running code analysis..."
flutter analyze --fatal-infos

# Run tests
echo "🧪 Running tests..."
flutter test

# Build for production (gopipit.com/pipit/)
echo "🏗️  Building for production (gopipit.com/pipit/)..."
flutter build web --release --base-href "/pipit/" --web-renderer html

# Create production deployment directory
echo "📁 Preparing production files..."
rm -rf public_html/pipit/*
cp -r build/web/* public_html/pipit/

# Build for staging (staging.gopipit.com/)
echo "🏗️  Building for staging (staging.gopipit.com/)..."
flutter build web --release --web-renderer html

# Create staging deployment directory  
echo "📁 Preparing staging files..."
rm -rf public_html/staging/*
cp -r build/web/* public_html/staging/

# Set proper permissions
echo "🔒 Setting file permissions..."
find public_html/pipit -type f -exec chmod 644 {} \;
find public_html/pipit -type d -exec chmod 755 {} \;
find public_html/staging -type f -exec chmod 644 {} \;
find public_html/staging -type d -exec chmod 755 {} \;

# Display deployment summary
echo -e "${GREEN}✅ Deployment preparation complete!${NC}"
echo ""
echo "📋 Deployment Summary:"
echo "  Production: public_html/pipit/ → https://gopipit.com/pipit/"
echo "  Staging: public_html/staging/ → https://staging.gopipit.com/"
echo ""
echo "🔄 Next steps:"
echo "  1. Upload public_html/pipit/* to your production server"
echo "  2. Upload public_html/staging/* to your staging server"
echo "  3. Configure DNS settings for gopipit.com and staging.gopipit.com"
echo "  4. Install SSL certificates"
echo ""
echo "📚 See docs/deployment.md for detailed deployment instructions"