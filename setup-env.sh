#!/bin/bash

# Postiz Vercel Environment Variables Setup Script
# Run this after creating Postgres and Redis databases

echo "🚀 Setting up Postiz environment variables..."
echo ""
echo "⚠️  Before running this script, make sure you have:"
echo "1. Created Vercel Postgres database"
echo "2. Created Vercel KV (Redis) database"
echo "3. Have Cloudflare R2 credentials (optional for now)"
echo ""
read -p "Press Enter to continue or Ctrl+C to cancel..."

# JWT Secret (already generated)
JWT_SECRET="C0QqrvRfPMPJZwC9MMBrgvls8jRGvzLmV6jBu5GAwPkqYkg2EYBpxh4Cp+FXBgsqctq9hzpX6pyv0oUmxX0xrw=="

echo ""
echo "📝 Enter your database connection strings:"
echo ""

# Get Database URL
read -p "Enter POSTGRES_URL (from Vercel): " DATABASE_URL

# Get Redis URL
echo ""
echo "For Redis, you can enter either:"
echo "  1. Full Redis URL (redis://...)"
echo "  2. Or KV REST API URL (https://...)"
read -p "Enter REDIS_URL or KV URL: " REDIS_URL

# Get deployment URL (will update after first deploy)
echo ""
read -p "Enter your Vercel app URL (or press Enter to use temp): " FRONTEND_URL
if [ -z "$FRONTEND_URL" ]; then
    FRONTEND_URL="https://postiz-app.vercel.app"
fi

# Backend URL (for now, same as frontend - will need separate backend later)
BACKEND_URL="$FRONTEND_URL"

echo ""
echo "📤 Setting environment variables in Vercel..."
echo ""

# Required variables
vercel env add DATABASE_URL production <<< "$DATABASE_URL"
vercel env add REDIS_URL production <<< "$REDIS_URL"
vercel env add JWT_SECRET production <<< "$JWT_SECRET"
vercel env add FRONTEND_URL production <<< "$FRONTEND_URL"
vercel env add NEXT_PUBLIC_BACKEND_URL production <<< "$BACKEND_URL"
vercel env add BACKEND_INTERNAL_URL production <<< "$BACKEND_URL"
vercel env add STORAGE_PROVIDER production <<< "local"
vercel env add IS_GENERAL production <<< "true"
vercel env add NX_ADD_PLUGINS production <<< "false"

echo ""
echo "✅ Basic environment variables set!"
echo ""
echo "⚠️  Important Notes:"
echo "1. You'll need to deploy backend separately (Railway/Render/Fly.io)"
echo "2. Update NEXT_PUBLIC_BACKEND_URL with actual backend URL later"
echo "3. Add Cloudflare R2 credentials for file uploads"
echo "4. Add social media API keys when ready"
echo ""
echo "🚀 Ready to deploy! Run: vercel --prod"
