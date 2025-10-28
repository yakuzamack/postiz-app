#!/bin/bash
set -e

echo "🚀 Building for Cloudflare Pages..."

# Install dependencies
pnpm install

# Build frontend with Cloudflare config
cd apps/frontend
NEXT_CONFIG_FILE=next.config.cloudflare.js pnpm run build

echo "✅ Build complete! Output: apps/frontend/out"
