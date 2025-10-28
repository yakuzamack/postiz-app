#!/bin/bash
set -e

echo "🚀 Deploying Postiz to Render via CLI..."

# Check if render CLI is installed
if ! command -v render &> /dev/null; then
    echo "❌ Render CLI not found. Installing..."
    npm install -g @render/cli
fi

# Login to Render
echo "📝 Logging into Render..."
render login

# Deploy using Blueprint
echo "🔨 Deploying Blueprint..."
render blueprint launch

echo "✅ Deployment initiated!"
echo ""
echo "📋 Next steps:"
echo "1. Wait for services to deploy in Render dashboard"
echo "2. Get your backend URL (e.g., https://postiz-backend-xxx.onrender.com)"
echo "3. Update environment variables in Render dashboard with real values"
echo "4. Deploy frontend to Cloudflare Pages using: npm run deploy:cloudflare"
