#!/bin/bash
set -e

echo "🚀 Deploying Frontend to Cloudflare Pages..."

# Check if wrangler is installed
if ! command -v wrangler &> /dev/null; then
    echo "❌ Wrangler not found. Installing..."
    npm install -g wrangler
fi

# Login to Cloudflare
echo "📝 Logging into Cloudflare..."
wrangler login

# Prompt for backend URL
read -p "Enter your Render backend URL (e.g., https://postiz-backend-xxx.onrender.com): " BACKEND_URL

# Set environment variable
export NEXT_PUBLIC_BACKEND_URL=$BACKEND_URL

# Build frontend
echo "🔨 Building frontend..."
pnpm install
pnpm run build:frontend

# Deploy to Cloudflare Pages
echo "📤 Deploying to Cloudflare Pages..."
cd apps/frontend
wrangler pages deploy out --project-name=postiz-frontend

echo "✅ Deployment complete!"
echo ""
echo "📋 Next steps:"
echo "1. Copy your Cloudflare Pages URL (e.g., https://postiz-frontend.pages.dev)"
echo "2. Update FRONTEND_URL in Render dashboard"
echo "3. Redeploy backend service in Render"
