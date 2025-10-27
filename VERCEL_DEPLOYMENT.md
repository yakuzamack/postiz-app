# Postiz Vercel Deployment Guide

## ⚠️ Important Notice

Postiz is a **full-stack monorepo** that requires:
1. **Frontend** (Next.js) - Can deploy to Vercel
2. **Backend** (NestJS API) - Needs separate hosting (Railway, Render, Fly.io)
3. **Workers** (BullMQ) - Background jobs processing
4. **Cron** (Scheduled tasks)
5. **PostgreSQL Database**
6. **Redis**

**This guide focuses on deploying ONLY the frontend to Vercel.**

---

## Step 1: Set Up Required Services

### A. Database - Choose one:

**Option 1: Vercel Postgres** (Easiest)
```bash
# In Vercel Dashboard:
# Storage → Create Database → Postgres
```

**Option 2: External (Supabase, Neon, Railway)**
- Sign up for free tier
- Get connection string

### B. Redis - Choose one:

**Option 1: Vercel KV** (Easiest)
```bash
# In Vercel Dashboard:
# Storage → Create Database → KV
```

**Option 2: Upstash Redis** (Free tier)
- Go to https://upstash.com
- Create Redis database
- Get connection string

### C. Cloudflare R2 (Required for file storage)
1. Go to https://dash.cloudflare.com
2. R2 → Create bucket
3. Get API tokens

---

## Step 2: Deploy Frontend to Vercel

### Option A: Via CLI (Current Setup)

```bash
# Link project to Vercel
vercel link

# Add environment variables (do this in Vercel Dashboard first)
# Then deploy
vercel --prod
```

### Option B: Via Dashboard (Recommended)

1. Go to https://vercel.com/new
2. Import **yakuzamack/postiz-app**
3. Configure:
   - **Root Directory**: Leave blank or use `/`
   - **Build Command**: `pnpm run build:frontend`
   - **Output Directory**: `apps/frontend/.next`
   - **Install Command**: `pnpm install`

---

## Step 3: Add Environment Variables in Vercel

Go to: **Project Settings → Environment Variables**

Add these (minimum required):

```bash
# Database
DATABASE_URL=postgresql://user:pass@host:5432/db

# Redis
REDIS_URL=redis://default:pass@host:6379

# JWT
JWT_SECRET=your-super-long-random-secret-here

# URLs (Update after first deployment)
FRONTEND_URL=https://your-app.vercel.app
NEXT_PUBLIC_BACKEND_URL=https://your-backend.com
BACKEND_INTERNAL_URL=https://your-backend.com

# Cloudflare R2
CLOUDFLARE_ACCOUNT_ID=your-account-id
CLOUDFLARE_ACCESS_KEY=your-access-key
CLOUDFLARE_SECRET_ACCESS_KEY=your-secret
CLOUDFLARE_BUCKETNAME=your-bucket
CLOUDFLARE_BUCKET_URL=https://your-bucket.r2.cloudflarestorage.com/
CLOUDFLARE_REGION=auto

# Storage
STORAGE_PROVIDER=cloudflare

# Required
IS_GENERAL=true
NX_ADD_PLUGINS=false
```

---

## Step 4: Deploy Backend (Required!)

The frontend **won't work** without the backend. Deploy backend to:

### Recommended Services:
- **Railway** (easiest): https://railway.app
- **Render**: https://render.com
- **Fly.io**: https://fly.io

### Deploy commands:
```bash
# Build backend
pnpm run build:backend

# Start backend
pnpm run start:prod:backend
```

---

## Step 5: Add Social Media Accounts

After deployment, to add social media accounts:

1. **Get API Credentials** from each platform:

   - **Twitter/X**: https://developer.twitter.com/en/portal/dashboard
   - **LinkedIn**: https://www.linkedin.com/developers/apps
   - **Facebook**: https://developers.facebook.com/apps
   - **YouTube**: https://console.cloud.google.com/apis/credentials
   - **TikTok**: https://developers.tiktok.com/
   - **Pinterest**: https://developers.pinterest.com/apps/
   - **Discord**: https://discord.com/developers/applications
   - **Reddit**: https://www.reddit.com/prefs/apps

2. **Add credentials to Vercel Environment Variables**:
   ```
   X_API_KEY=xxx
   X_API_SECRET=xxx
   LINKEDIN_CLIENT_ID=xxx
   LINKEDIN_CLIENT_SECRET=xxx
   # ... etc
   ```

3. **Set OAuth Redirect URLs** in each platform:
   ```
   https://your-app.vercel.app/api/auth/callback/[platform]
   ```

4. **Connect in Postiz UI**:
   - Login to your deployed app
   - Go to **Settings → Integrations**
   - Click **Connect** for each platform
   - Authorize via OAuth

---

## Quick Deploy Command

```bash
# Deploy to Vercel
vercel --prod
```

---

## Troubleshooting

**Build fails?**
- Check that all environment variables are set
- Verify PostgreSQL and Redis are accessible

**Can't connect social media?**
- Verify API keys in environment variables
- Check OAuth redirect URLs in platform settings
- Make sure BACKEND_URL is correct

**Frontend loads but API errors?**
- Backend is not deployed or not accessible
- Check NEXT_PUBLIC_BACKEND_URL is correct
