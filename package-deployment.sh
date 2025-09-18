#!/bin/bash

# Deployment Package Creator for gopipit.com
# This script creates a deployment-ready package

set -e

echo "📦 Creating deployment package for gopipit.com..."

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

PACKAGE_NAME="pipit-gopipit-deployment-$(date +%Y%m%d-%H%M%S)"
PACKAGE_DIR="/tmp/$PACKAGE_NAME"

echo -e "${BLUE}📁 Creating package directory: $PACKAGE_DIR${NC}"
mkdir -p "$PACKAGE_DIR"

echo -e "${BLUE}📋 Copying deployment files...${NC}"

# Copy public_html directory
cp -r public_html "$PACKAGE_DIR/"

# Copy documentation
cp DEPLOYMENT_READY.md "$PACKAGE_DIR/"
cp docs/deployment.md "$PACKAGE_DIR/"
cp README.md "$PACKAGE_DIR/"

# Copy deployment script
cp deploy.sh "$PACKAGE_DIR/"

# Create additional deployment info
cat > "$PACKAGE_DIR/DEPLOYMENT_INFO.txt" << EOF
Pipit Flutter Web Application - Deployment Package
==================================================

Domain: gopipit.com
Package Created: $(date)
Package Name: $PACKAGE_NAME

Contents:
- public_html/pipit/     → Production files for gopipit.com/pipit/
- public_html/staging/   → Staging files for staging.gopipit.com/
- DEPLOYMENT_READY.md    → Quick deployment guide
- deployment.md          → Complete deployment documentation
- README.md              → Project documentation
- deploy.sh              → Build automation script

Deployment URLs:
- Production: https://gopipit.com/pipit/
- Staging: https://staging.gopipit.com/

Next Steps:
1. Upload public_html/pipit/* to your Namecheap hosting
2. Configure DNS for gopipit.com
3. Install SSL certificates
4. Test the deployment

For detailed instructions, see DEPLOYMENT_READY.md
EOF

echo -e "${BLUE}🗜️  Creating deployment archive...${NC}"
cd /tmp
tar -czf "${PACKAGE_NAME}.tar.gz" "$PACKAGE_NAME"

# Calculate file sizes
PACKAGE_SIZE=$(du -sh "${PACKAGE_NAME}.tar.gz" | cut -f1)
UNCOMPRESSED_SIZE=$(du -sh "$PACKAGE_NAME" | cut -f1)

echo -e "${GREEN}✅ Deployment package created successfully!${NC}"
echo ""
echo "📦 Package Details:"
echo "   Name: ${PACKAGE_NAME}.tar.gz"
echo "   Location: /tmp/${PACKAGE_NAME}.tar.gz"
echo "   Compressed Size: $PACKAGE_SIZE"
echo "   Uncompressed Size: $UNCOMPRESSED_SIZE"
echo ""
echo "📋 Package Contents:"
ls -la "$PACKAGE_DIR"
echo ""
echo -e "${YELLOW}🚀 Ready for deployment to gopipit.com!${NC}"
echo ""
echo "To extract and deploy:"
echo "  tar -xzf /tmp/${PACKAGE_NAME}.tar.gz"
echo "  cd $PACKAGE_NAME"
echo "  # Follow instructions in DEPLOYMENT_READY.md"

# Copy back to project for commit
cp "/tmp/${PACKAGE_NAME}.tar.gz" "/home/runner/work/hook/hook/"
echo ""
echo "📁 Package also copied to project root for download"