#!/bin/bash
# Postiz - Cloudflare R2 Storage Setup Script
# This script helps you configure Cloudflare R2 storage for Postiz

set -e

echo "=========================================="
echo "Postiz - Cloudflare R2 Setup"
echo "=========================================="
echo ""

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Check if wrangler is installed and authenticated
echo "Checking Cloudflare authentication..."
if ! wrangler whoami > /dev/null 2>&1; then
    echo -e "${RED}Error: Not logged into Cloudflare${NC}"
    echo "Please run: wrangler login"
    exit 1
fi

# Get account ID
ACCOUNT_ID=$(wrangler whoami 2>&1 | grep "Account ID" | awk '{print $4}')
if [ -z "$ACCOUNT_ID" ]; then
    echo -e "${RED}Error: Could not get Cloudflare Account ID${NC}"
    exit 1
fi

echo -e "${GREEN}✓ Cloudflare authenticated${NC}"
echo "Account ID: $ACCOUNT_ID"
echo ""

# Step 1: Create R2 Bucket
echo "=========================================="
echo "Step 1: Creating R2 Bucket"
echo "=========================================="
BUCKET_NAME="postiz-uploads"

echo "Checking if bucket '$BUCKET_NAME' already exists..."
if wrangler r2 bucket list 2>&1 | grep -q "$BUCKET_NAME"; then
    echo -e "${YELLOW}⚠ Bucket '$BUCKET_NAME' already exists${NC}"
else
    echo "Creating bucket '$BUCKET_NAME'..."
    if wrangler r2 bucket create "$BUCKET_NAME"; then
        echo -e "${GREEN}✓ Bucket created successfully${NC}"
    else
        echo -e "${RED}✗ Failed to create bucket${NC}"
        exit 1
    fi
fi
echo ""

# Step 2: Enable R2.dev subdomain for testing
echo "=========================================="
echo "Step 2: R2 Bucket Configuration"
echo "=========================================="
echo "To enable public access, you need to:"
echo "1. Go to: https://dash.cloudflare.com/$ACCOUNT_ID/r2/buckets"
echo "2. Click on '$BUCKET_NAME'"
echo "3. Go to 'Settings' tab"
echo "4. Under 'R2.dev subdomain', click 'Allow Access'"
echo "5. Copy the R2.dev URL (e.g., https://pub-xxxxx.r2.dev)"
echo ""
echo "Alternatively, for production, set up a custom domain:"
echo "- Go to Settings → Custom Domains → Connect Domain"
echo ""
read -p "Press Enter after you've enabled R2.dev subdomain or configured custom domain..."
echo ""

# Step 3: Get R2 Access Keys
echo "=========================================="
echo "Step 3: R2 API Tokens"
echo "=========================================="
echo "You need to create R2 API tokens:"
echo "1. Go to: https://dash.cloudflare.com/$ACCOUNT_ID/r2/api-tokens"
echo "2. Click 'Create API Token'"
echo "3. Permissions: Admin Read & Write"
echo "4. Click 'Create API Token'"
echo "5. Save both Access Key ID and Secret Access Key"
echo ""
read -p "Press Enter after you've created the API token..."
echo ""

# Step 4: Collect credentials
echo "=========================================="
echo "Step 4: Enter Your Credentials"
echo "=========================================="
echo ""

read -p "Enter Cloudflare Account ID [$ACCOUNT_ID]: " INPUT_ACCOUNT_ID
ACCOUNT_ID=${INPUT_ACCOUNT_ID:-$ACCOUNT_ID}

read -p "Enter R2 Access Key ID: " ACCESS_KEY
while [ -z "$ACCESS_KEY" ]; do
    echo -e "${RED}Access Key ID cannot be empty${NC}"
    read -p "Enter R2 Access Key ID: " ACCESS_KEY
done

read -sp "Enter R2 Secret Access Key: " SECRET_KEY
echo ""
while [ -z "$SECRET_KEY" ]; do
    echo -e "${RED}Secret Access Key cannot be empty${NC}"
    read -sp "Enter R2 Secret Access Key: " SECRET_KEY
    echo ""
done

read -p "Enter R2 Bucket Name [$BUCKET_NAME]: " INPUT_BUCKET
BUCKET_NAME=${INPUT_BUCKET:-$BUCKET_NAME}

read -p "Enter R2 Bucket URL (e.g., https://pub-xxxxx.r2.dev): " BUCKET_URL
while [ -z "$BUCKET_URL" ]; do
    echo -e "${RED}Bucket URL cannot be empty${NC}"
    read -p "Enter R2 Bucket URL: " BUCKET_URL
done

# Step 5: Update Vercel
echo ""
echo "=========================================="
echo "Step 5: Updating Vercel Environment Variables"
echo "=========================================="

if command -v vercel > /dev/null 2>&1; then
    echo "Updating Vercel environment variables..."

    # Remove old values (if they exist)
    vercel env rm CLOUDFLARE_ACCOUNT_ID production --yes 2>/dev/null || true
    vercel env rm CLOUDFLARE_ACCESS_KEY production --yes 2>/dev/null || true
    vercel env rm CLOUDFLARE_SECRET_ACCESS_KEY production --yes 2>/dev/null || true
    vercel env rm CLOUDFLARE_BUCKETNAME production --yes 2>/dev/null || true
    vercel env rm CLOUDFLARE_BUCKET_URL production --yes 2>/dev/null || true

    # Add new values
    echo "$ACCOUNT_ID" | vercel env add CLOUDFLARE_ACCOUNT_ID production
    echo "$ACCESS_KEY" | vercel env add CLOUDFLARE_ACCESS_KEY production
    echo "$SECRET_KEY" | vercel env add CLOUDFLARE_SECRET_ACCESS_KEY production
    echo "$BUCKET_NAME" | vercel env add CLOUDFLARE_BUCKETNAME production
    echo "$BUCKET_URL" | vercel env add CLOUDFLARE_BUCKET_URL production

    echo -e "${GREEN}✓ Vercel environment variables updated${NC}"
else
    echo -e "${YELLOW}⚠ Vercel CLI not found. Please update manually:${NC}"
    echo "https://vercel.com/dashboard"
fi
echo ""

# Step 6: Save to .env.local for reference
echo "=========================================="
echo "Step 6: Saving Configuration"
echo "=========================================="

cat > .env.r2.local << EOF
# Cloudflare R2 Configuration
# Generated: $(date)
CLOUDFLARE_ACCOUNT_ID=$ACCOUNT_ID
CLOUDFLARE_ACCESS_KEY=$ACCESS_KEY
CLOUDFLARE_SECRET_ACCESS_KEY=$SECRET_KEY
CLOUDFLARE_BUCKETNAME=$BUCKET_NAME
CLOUDFLARE_BUCKET_URL=$BUCKET_URL
CLOUDFLARE_REGION=auto
STORAGE_PROVIDER=cloudflare
EOF

echo -e "${GREEN}✓ Configuration saved to .env.r2.local${NC}"
echo ""

# Step 7: Update Render
echo "=========================================="
echo "Step 7: Update Render Backend"
echo "=========================================="
echo "You need to manually update Render environment variables:"
echo ""
echo "1. Go to: https://dashboard.render.com/"
echo "2. Select your 'postiz-backend' service"
echo "3. Go to 'Environment' tab"
echo "4. Update these variables:"
echo ""
echo "   CLOUDFLARE_ACCOUNT_ID=$ACCOUNT_ID"
echo "   CLOUDFLARE_ACCESS_KEY=$ACCESS_KEY"
echo "   CLOUDFLARE_SECRET_ACCESS_KEY=$SECRET_KEY"
echo "   CLOUDFLARE_BUCKETNAME=$BUCKET_NAME"
echo "   CLOUDFLARE_BUCKET_URL=$BUCKET_URL"
echo "   CLOUDFLARE_REGION=auto"
echo "   STORAGE_PROVIDER=cloudflare"
echo ""
echo "5. Click 'Save Changes'"
echo ""
echo "These values are also saved in .env.r2.local"
echo ""

# Step 8: Redeploy
echo "=========================================="
echo "Step 8: Redeploy Services"
echo "=========================================="
echo ""
read -p "Do you want to redeploy Vercel now? (y/n): " DEPLOY_VERCEL

if [ "$DEPLOY_VERCEL" = "y" ] || [ "$DEPLOY_VERCEL" = "Y" ]; then
    echo "Deploying to Vercel..."
    vercel --prod
    echo -e "${GREEN}✓ Vercel deployment initiated${NC}"
else
    echo "You can deploy later with: vercel --prod"
fi
echo ""

echo "After updating Render environment variables, the service will"
echo "automatically redeploy."
echo ""

# Summary
echo "=========================================="
echo "Setup Complete! ✓"
echo "=========================================="
echo ""
echo -e "${GREEN}Next Steps:${NC}"
echo "1. Update Render environment variables (see Step 7 above)"
echo "2. Wait for Render to redeploy (~5 minutes)"
echo "3. Test file uploads in your Postiz app"
echo ""
echo -e "${YELLOW}Verification:${NC}"
echo "Run this command to verify R2 is working:"
echo "  wrangler r2 bucket list"
echo ""
echo "Your configuration is saved in: .env.r2.local"
echo ""
echo "For more help, see: DEPLOYMENT_VERIFICATION.md"
echo ""
