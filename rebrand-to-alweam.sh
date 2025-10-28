#!/bin/bash
# Rebrand Postiz to AlWeam-MC.RAK
# This script updates the application name throughout the codebase

set -e

BRAND_NAME="AlWeam-MC.RAK"
BRAND_NAME_SHORT="AlWeam"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}=== Rebranding Postiz to ${BRAND_NAME} ===${NC}"
echo ""

# 1. Update package.json files
echo -e "${YELLOW}1. Updating package.json files...${NC}"

# Root package.json
sed -i '' 's/"name": "gitroom"/"name": "alweam-mc-rak"/g' package.json
echo "✅ Updated root package.json"

# Frontend package.json
sed -i '' 's/"name": "postiz-frontend"/"name": "alweam-frontend"/g' apps/frontend/package.json
echo "✅ Updated frontend package.json"

# 2. Update metadata (title tags)
echo -e "${YELLOW}2. Updating page titles and metadata...${NC}"

# Find and update all page.tsx files with title
find apps/frontend/src -name "page.tsx" -type f -exec sed -i '' "s/title: 'Postiz'/title: '${BRAND_NAME}'/g" {} \;
find apps/frontend/src -name "page.tsx" -type f -exec sed -i '' "s/title: \"Postiz\"/title: \"${BRAND_NAME}\"/g" {} \;
echo "✅ Updated page titles"

# 3. Update layout files
echo -e "${YELLOW}3. Updating layout files...${NC}"

# Update layout.tsx plausible domain
sed -i '' "s/domain={!!process.env.IS_GENERAL ? 'postiz.com' : 'gitroom.com'}/domain='alweam-mc.rak.com'/g" apps/frontend/src/app/\(app\)/layout.tsx
echo "✅ Updated main layout"

# 4. Update middleware
echo -e "${YELLOW}4. Updating middleware...${NC}"

sed -i '' 's/POSTIZ_GENERIC_OAUTH/ALWEAM_GENERIC_OAUTH/g' apps/frontend/src/middleware.ts
sed -i '' 's/POSTIZ_OAUTH/ALWEAM_OAUTH/g' apps/frontend/src/middleware.ts
echo "✅ Updated middleware"

# 5. Update environment variable references
echo -e "${YELLOW}5. Updating environment variable references...${NC}"

find apps/frontend/src -type f \( -name "*.tsx" -o -name "*.ts" \) -exec sed -i '' 's/POSTIZ_/ALWEAM_/g' {} \;
echo "✅ Updated environment variables"

# 6. Update component text references
echo -e "${YELLOW}6. Updating component text references...${NC}"

# Common files with "Postiz" text
find apps/frontend/src/components -type f \( -name "*.tsx" -o -name "*.ts" \) -exec sed -i '' "s/Postiz/${BRAND_NAME_SHORT}/g" {} \;
echo "✅ Updated component references"

# 7. Update auth pages
echo -e "${YELLOW}7. Updating auth pages...${NC}"

find apps/frontend/src/app/\(app\)/auth -type f -name "*.tsx" -exec sed -i '' "s/Postiz/${BRAND_NAME_SHORT}/g" {} \;
echo "✅ Updated auth pages"

# 8. Update README
echo -e "${YELLOW}8. Updating documentation...${NC}"

if [ -f "apps/frontend/README.md" ]; then
    sed -i '' "s/Postiz/${BRAND_NAME}/g" apps/frontend/README.md
fi
echo "✅ Updated README (if exists)"

echo ""
echo -e "${GREEN}=== Rebranding Complete! ===${NC}"
echo ""
echo "Next steps:"
echo "1. Update your logo/favicon at: apps/frontend/public/favicon.ico"
echo "2. Update images in: apps/frontend/public/"
echo "3. Review and test the changes"
echo "4. Commit changes:"
echo "   git add ."
echo "   git commit -m 'rebrand: Update Postiz to ${BRAND_NAME}'"
echo "   git push origin main"
echo ""
echo "Environment variables to update in Render:"
echo "   - POSTIZ_GENERIC_OAUTH → ALWEAM_GENERIC_OAUTH"
echo "   - NEXT_PUBLIC_POSTIZ_OAUTH_DISPLAY_NAME → NEXT_PUBLIC_ALWEAM_OAUTH_DISPLAY_NAME"
echo "   - NEXT_PUBLIC_POSTIZ_OAUTH_LOGO_URL → NEXT_PUBLIC_ALWEAM_OAUTH_LOGO_URL"
echo ""
