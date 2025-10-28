#!/bin/bash
# Quick fix script for adding missing environment variables to Vercel
# Run this after setting up Cloudflare R2 and Render services

set -e

echo "🔧 Postiz Vercel Environment Variable Setup"
echo "============================================="
echo ""

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Frontend URL
FRONTEND_URL="https://postiz-app-jet.vercel.app"

echo -e "${YELLOW}Adding environment variables to Vercel Production...${NC}"
echo ""

# System variables
echo -e "${GREEN}1. Adding IS_GENERAL...${NC}"
echo "true" | vercel env add IS_GENERAL production || echo "Already exists or error"

echo -e "${GREEN}2. Adding NODE_ENV...${NC}"
echo "production" | vercel env add NODE_ENV production || echo "Already exists or error"

echo -e "${GREEN}3. Adding FRONTEND_URL...${NC}"
echo "$FRONTEND_URL" | vercel env add FRONTEND_URL production || echo "Already exists or error"

echo -e "${GREEN}4. Adding STORAGE_PROVIDER...${NC}"
echo "cloudflare" | vercel env add STORAGE_PROVIDER production || echo "Already exists or error"

echo -e "${GREEN}5. Adding CLOUDFLARE_REGION...${NC}"
echo "auto" | vercel env add CLOUDFLARE_REGION production || echo "Already exists or error"

echo ""
echo -e "${YELLOW}⚠️  Manual Steps Required:${NC}"
echo ""
echo "Please add these variables manually via Vercel Dashboard:"
echo "https://vercel.com/xyakuzapro8s-projects/postiz-app/settings/environment-variables"
echo ""
echo "Required variables from Cloudflare R2:"
echo "  - CLOUDFLARE_ACCOUNT_ID"
echo "  - CLOUDFLARE_ACCESS_KEY"
echo "  - CLOUDFLARE_SECRET_ACCESS_KEY"
echo "  - CLOUDFLARE_BUCKETNAME"
echo "  - CLOUDFLARE_BUCKET_URL"
echo ""
echo "Optional (if not using these features):"
echo "  - DATABASE_URL (from Render PostgreSQL)"
echo "  - REDIS_URL (from Render Redis)"
echo "  - JWT_SECRET (random 32+ char string)"
echo ""
echo -e "${GREEN}✅ Basic environment variables added!${NC}"
echo ""
echo "Next steps:"
echo "1. Setup Cloudflare R2 (see CLOUDFLARE_DEPLOYMENT.md)"
echo "2. Add Cloudflare credentials to Vercel"
echo "3. Deploy: vercel --prod"
echo ""
