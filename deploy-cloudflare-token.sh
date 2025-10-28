#!/bin/bash
set -e

echo "🚀 Deploying Frontend to Cloudflare Pages..."

# Prompt for API token if not set
if [ -z "$CLOUDFLARE_API_TOKEN" ]; then
    read -sp "Enter your Cloudflare API Token: " CLOUDFLARE_API_TOKEN
    export CLOUDFLARE_API_TOKEN
    echo ""
fi

# Prompt for account ID if not set
if [ -z "$CLOUDFLARE_ACCOUNT_ID" ]; then
    read -p "Enter your Cloudflare Account ID: " CLOUDFLARE_ACCOUNT_ID
    export CLOUDFLARE_ACCOUNT_ID
fi

# Prompt for backend URL
read -p "Enter your Render backend URL (e.g., https://postiz-backend-fbp3.onrender.com): " BACKEND_URL

# Check if wrangler is installed
if ! command -v wrangler &> /dev/null; then
    echo "❌ Wrangler not found. Installing..."
    npm install -g wrangler
fi

# Build frontend
echo "🔨 Building frontend..."
pnpm install
pnpm run build:frontend

# Deploy to Cloudflare Pages
echo "📤 Deploying to Cloudflare Pages..."
cd apps/frontend

# Set environment variable for build
export NEXT_PUBLIC_BACKEND_URL=$BACKEND_URL

# Deploy
wrangler pages deploy out --project-name=postiz-frontend

echo "✅ Deployment complete!"
echo ""
echo "Your Cloudflare Pages URL will be shown above."
echo ""
echo "📋 Final step:"
echo "1. Copy your Cloudflare Pages URL"
echo "2. Update FRONTEND_URL in Render dashboard: https://dashboard.render.com"
echo "3. Redeploy backend service"
