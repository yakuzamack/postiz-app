#!/bin/bash
# Cloudflare R2 Setup for Postiz
# Bucket: postiz-uploads (already created ✅)
# Account ID: 0a36854052d818a17ee27bd1b2fb3ba3

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}=== Cloudflare R2 Setup ===${NC}"
echo ""
echo -e "${GREEN}✅ Bucket 'postiz-uploads' created successfully!${NC}"
echo ""

# Account ID from wrangler whoami
ACCOUNT_ID="0a36854052d818a17ee27bd1b2fb3ba3"
BUCKET_NAME="postiz-uploads"

echo -e "${YELLOW}📋 Your R2 Configuration:${NC}"
echo "  Account ID: $ACCOUNT_ID"
echo "  Bucket Name: $BUCKET_NAME"
echo "  Bucket URL: https://pub-${ACCOUNT_ID}.r2.dev (after public access enabled)"
echo ""

echo -e "${RED}⚠️  MANUAL STEP REQUIRED:${NC}"
echo ""
echo "The Wrangler CLI cannot create R2 API tokens. You need to:"
echo ""
echo "1. Go to Cloudflare Dashboard:"
echo "   https://dash.cloudflare.com/${ACCOUNT_ID}/r2/overview/api-tokens"
echo ""
echo "2. Click 'Create API Token'"
echo ""
echo "3. Configure the token:"
echo "   - Name: postiz-api-token"
echo "   - Permissions: Object Read & Write"
echo "   - Apply to specific buckets: postiz-uploads"
echo ""
echo "4. Save these credentials (shown only once):"
echo "   - Access Key ID (CLOUDFLARE_ACCESS_KEY)"
echo "   - Secret Access Key (CLOUDFLARE_SECRET_ACCESS_KEY)"
echo ""
echo "5. Enable public access (optional, for public URLs):"
echo "   https://dash.cloudflare.com/${ACCOUNT_ID}/r2/buckets/${BUCKET_NAME}/settings"
echo "   - Toggle 'Public Access' ON"
echo "   - Copy the public bucket URL"
echo ""

echo -e "${YELLOW}📝 Once you have the credentials, add them to:${NC}"
echo ""
echo "A. Vercel (Production environment):"
echo "   vercel env add CLOUDFLARE_ACCOUNT_ID production"
echo "   # Enter: $ACCOUNT_ID"
echo ""
echo "   vercel env add CLOUDFLARE_ACCESS_KEY production"
echo "   # Enter: <access-key-from-dashboard>"
echo ""
echo "   vercel env add CLOUDFLARE_SECRET_ACCESS_KEY production"
echo "   # Enter: <secret-key-from-dashboard>"
echo ""
echo "   vercel env add CLOUDFLARE_BUCKETNAME production"
echo "   # Enter: $BUCKET_NAME"
echo ""
echo "   vercel env add CLOUDFLARE_BUCKET_URL production"
echo "   # Enter: <public-url-from-dashboard>"
echo ""

echo "B. Render Backend:"
echo "   Go to: https://dashboard.render.com/web/srv-d3vfknje5dus73abjh00"
echo "   Add the same 5 environment variables in the Environment tab"
echo ""

echo -e "${GREEN}Then redeploy:${NC}"
echo "   vercel --prod"
echo "   (Render will auto-redeploy)"
echo ""

# Helper function to add env vars once user has credentials
read -p "Do you have the API credentials ready? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo ""
    echo -e "${GREEN}Great! Let's add them to Vercel...${NC}"
    echo ""
    
    # Add to Vercel
    echo "$ACCOUNT_ID" | vercel env add CLOUDFLARE_ACCOUNT_ID production
    echo "$BUCKET_NAME" | vercel env add CLOUDFLARE_BUCKETNAME production
    
    echo ""
    echo -e "${YELLOW}Now enter your Access Key ID:${NC}"
    vercel env add CLOUDFLARE_ACCESS_KEY production
    
    echo ""
    echo -e "${YELLOW}Now enter your Secret Access Key:${NC}"
    vercel env add CLOUDFLARE_SECRET_ACCESS_KEY production
    
    echo ""
    echo -e "${YELLOW}Now enter your Bucket URL (e.g., https://pub-xxxxx.r2.dev):${NC}"
    vercel env add CLOUDFLARE_BUCKET_URL production
    
    echo ""
    echo -e "${GREEN}✅ Credentials added to Vercel!${NC}"
    echo ""
    echo -e "${YELLOW}Don't forget to add them to Render too:${NC}"
    echo "   https://dashboard.render.com/web/srv-d3vfknje5dus73abjh00"
    echo ""
    
    read -p "Deploy to Vercel now? (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo ""
        echo -e "${GREEN}Deploying to Vercel...${NC}"
        vercel --prod
    fi
else
    echo ""
    echo -e "${YELLOW}No problem! Get the credentials from:${NC}"
    echo "   https://dash.cloudflare.com/${ACCOUNT_ID}/r2/overview/api-tokens"
    echo ""
    echo "Then run this script again!"
fi

echo ""
echo -e "${GREEN}=== Setup Complete ===${NC}"
