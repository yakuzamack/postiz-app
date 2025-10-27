# Render + Cloudflare Pages Deployment Guide

Deploy Postiz with **backend on Render** and **frontend on Cloudflare Pages**.

## Architecture

```
┌─────────────────────┐      API calls       ┌──────────────────┐
│  Cloudflare Pages   │ ───────────────────> │      Render      │
│   (Frontend/UI)     │                      │  (Backend/API)   │
└─────────────────────┘                      └──────────────────┘
                                                      │
                                                      ├─> PostgreSQL
                                                      └─> Redis
```

---

## Step 1: Deploy Backend to Render (One-Click)

### Option A: Blueprint (Easiest - Auto-setup)

1. **Push `render.yaml` to your GitHub repo**
2. Go to [render.com/dashboard](https://dashboard.render.com)
3. Click **New** → **Blueprint**
4. Connect your GitHub repository
5. Render will automatically create:
   - PostgreSQL database
   - Redis instance
   - Backend service
   - Workers service
   - Cron service

### Option B: Manual Setup

If you prefer manual control:

#### 1.1 Create PostgreSQL Database
1. Go to [Render Dashboard](https://dashboard.render.com)
2. **New** → **PostgreSQL**
   - Name: `postiz-db`
   - Database: `postiz`
   - User: `postiz`
   - Region: `Oregon (US West)`
   - Plan: `Starter ($7/month)`

#### 1.2 Create Redis Instance
1. **New** → **Redis**
   - Name: `postiz-redis`
   - Plan: `Starter ($7/month)`
   - Max Memory Policy: `allkeys-lru`

#### 1.3 Deploy Backend Service
1. **New** → **Web Service**
2. Connect your GitHub repository
3. Configure:
   - **Name**: `postiz-backend`
   - **Region**: `Oregon (US West)`
   - **Branch**: `main`
   - **Root Directory**: `.`
   - **Environment**: `Node`
   - **Build Command**: `pnpm install && pnpm run build:backend`
   - **Start Command**: `pnpm run start:prod:backend`
   - **Plan**: `Starter ($7/month)`

#### 1.4 Deploy Workers Service
1. **New** → **Background Worker**
2. Connect your GitHub repository
3. Configure:
   - **Name**: `postiz-workers`
   - **Build Command**: `pnpm install && pnpm run build:workers`
   - **Start Command**: `pnpm run start:prod:workers`
   - **Plan**: `Starter ($7/month)`

#### 1.5 Deploy Cron Service
1. **New** → **Cron Job**
2. Connect your GitHub repository
3. Configure:
   - **Name**: `postiz-cron`
   - **Build Command**: `pnpm install && pnpm run build:cron`
   - **Start Command**: `pnpm run start:prod:cron`
   - **Schedule**: `*/5 * * * *` (every 5 minutes)
   - **Plan**: `Starter ($7/month)`

---

## Step 2: Configure Environment Variables

### For Backend Service

Go to `postiz-backend` → **Environment** and add:

```bash
# Database (from Render PostgreSQL)
DATABASE_URL=${{postiz-db.DATABASE_URL}}

# Redis (from Render Redis)
REDIS_URL=${{postiz-redis.REDIS_URL}}

# JWT (generate random 32+ char string)
JWT_SECRET="your-random-secret-here-make-it-long-and-secure"

# URLs (will update FRONTEND_URL after Cloudflare Pages deployment)
BACKEND_INTERNAL_URL=${{RENDER_EXTERNAL_URL}}
NEXT_PUBLIC_BACKEND_URL=${{RENDER_EXTERNAL_URL}}
FRONTEND_URL="https://your-site.pages.dev"

# Cloudflare R2 Storage
CLOUDFLARE_ACCOUNT_ID="your-cloudflare-account-id"
CLOUDFLARE_ACCESS_KEY="your-r2-access-key"
CLOUDFLARE_SECRET_ACCESS_KEY="your-r2-secret-key"
CLOUDFLARE_BUCKETNAME="postiz-uploads"
CLOUDFLARE_BUCKET_URL="https://pub-xxxxx.r2.dev"
CLOUDFLARE_REGION="auto"
STORAGE_PROVIDER="cloudflare"

# Email (optional - Resend)
RESEND_API_KEY="re_your_api_key"
EMAIL_FROM_ADDRESS="noreply@yourdomain.com"
EMAIL_FROM_NAME="Postiz"

# Social Media APIs (add as needed)
X_API_KEY=""
X_API_SECRET=""
LINKEDIN_CLIENT_ID=""
LINKEDIN_CLIENT_SECRET=""
# ... see .env.example for more

# System
IS_GENERAL="true"
NODE_ENV="production"
NODE_VERSION="22.0.0"
```

### For Workers & Cron Services

Copy the same environment variables from **Backend** to:
- `postiz-workers` → **Environment**
- `postiz-cron` → **Environment**

---

## Step 3: Setup Cloudflare R2 Storage

### 3.1 Create R2 Bucket
1. Go to [Cloudflare Dashboard](https://dash.cloudflare.com) → **R2**
2. **Create bucket**
   - Name: `postiz-uploads`
   - Location: `Automatic`
3. **Settings** → Enable **Public Access** or configure custom domain

### 3.2 Create API Token
1. **R2** → **Manage R2 API Tokens**
2. **Create API Token**
   - Permissions: **Object Read & Write**
   - Apply to bucket: `postiz-uploads`
3. Save:
   - **Access Key ID** (CLOUDFLARE_ACCESS_KEY)
   - **Secret Access Key** (CLOUDFLARE_SECRET_ACCESS_KEY)

### 3.3 Get Bucket Details
- **Account ID**: Found in R2 overview
- **Bucket URL**: `https://pub-xxxxxxxxx.r2.dev` (or custom domain)

Update these values in Render environment variables.

---

## Step 4: Deploy Frontend to Cloudflare Pages

### 4.1 Via Cloudflare Dashboard (Recommended)

1. Go to [Cloudflare Dashboard](https://dash.cloudflare.com)
2. **Workers & Pages** → **Create application** → **Pages**
3. **Connect to Git** → Select your repository
4. Configure build:
   - **Project name**: `postiz-frontend`
   - **Production branch**: `main`
   - **Build command**: `pnpm run build:frontend`
   - **Build output directory**: `apps/frontend/out`
   - **Root directory**: `/`
   
5. **Environment variables** (click **Add variable**):
   ```bash
   NODE_VERSION=22
   NEXT_PUBLIC_BACKEND_URL=https://postiz-backend.onrender.com
   FRONTEND_URL=https://postiz-frontend.pages.dev
   CLOUDFLARE_ACCOUNT_ID=your-account-id
   CLOUDFLARE_ACCESS_KEY=your-access-key
   CLOUDFLARE_SECRET_ACCESS_KEY=your-secret-key
   CLOUDFLARE_BUCKETNAME=postiz-uploads
   CLOUDFLARE_BUCKET_URL=https://pub-xxxxx.r2.dev
   CLOUDFLARE_REGION=auto
   STORAGE_PROVIDER=cloudflare
   ```

6. **Save and Deploy**

### 4.2 Via CLI (Alternative)

```bash
# Install Wrangler
npm install -g wrangler
wrangler login

# Build locally
pnpm install
pnpm run build:frontend

# Deploy
cd apps/frontend
wrangler pages deploy out --project-name=postiz-frontend
```

---

## Step 5: Update CORS Settings

After Cloudflare Pages deployment:

1. Get your Pages URL: `https://postiz-frontend.pages.dev`
2. Update Render backend environment variable:
   ```bash
   FRONTEND_URL=https://postiz-frontend.pages.dev
   ```
3. Redeploy backend service in Render

---

## Step 6: Test Your Deployment

1. Visit: `https://postiz-frontend.pages.dev`
2. Register a new account
3. Connect a social media account
4. Try creating a post
5. Check Render logs if issues occur

---

## Troubleshooting

### Build Fails
- Check Render logs for errors
- Verify Node version is 22.x
- Ensure `pnpm` is installing correctly

### CORS Errors
- Verify `FRONTEND_URL` matches your Cloudflare Pages URL exactly
- No trailing slash in URLs

### Database Connection
- Check `DATABASE_URL` is populated from Render PostgreSQL
- Verify database is running (green status)

### Redis Connection
- Check `REDIS_URL` is populated
- Verify Redis instance is active

### Image Uploads Fail
- Verify all Cloudflare R2 credentials are correct
- Check R2 bucket has public access enabled
- Test bucket URL in browser

---

## Updating Your Deployment

### Backend (Render)
- Push to GitHub → Render auto-deploys
- Or: Manual deploy in Render dashboard

### Frontend (Cloudflare Pages)
- Push to GitHub → Auto-deploys
- Or: `wrangler pages deploy out`

---

## Cost Breakdown

| Service | Plan | Cost |
|---------|------|------|
| Render PostgreSQL | Basic | $21/month |
| Render Redis | Standard | $10/month |
| Render Backend | Standard | $25/month |
| Render Workers | Standard | $25/month |
| Render Cron | Standard | $25/month |
| Cloudflare Pages | Free | $0 |
| Cloudflare R2 | Pay-as-you-go | ~$1-5/month |
| **Total** | | **~$107-111/month** |

### Cost Optimization Tips
- Start with **Hobby plan** ($7/month per service) for development/testing
- Combine Workers + Cron into one service to save $25/month
- Use **Free tier** for non-production testing (limited resources)
- Consider **Standard Plus** ($50/month) for high-traffic production

---

## Alternative: All-in-One Render

If you want to skip Cloudflare Pages and host everything on Render:

1. Add frontend service to `render.yaml`
2. Deploy as static site on Render
3. Saves Cloudflare setup but costs $7 more/month

---

## Render Blueprint

The included `render.yaml` file allows one-click deployment of the entire backend stack. Just:

```bash
git add render.yaml
git commit -m "Add Render blueprint"
git push
```

Then create a Blueprint in Render dashboard pointing to your repo.

---

## Need Help?

- [Postiz Discord](https://discord.postiz.com)
- [Render Docs](https://render.com/docs)
- [Cloudflare Pages Docs](https://developers.cloudflare.com/pages)

---

## Quick Start Summary

```bash
# 1. Push to GitHub
git add .
git commit -m "Ready for Render deployment"
git push

# 2. Deploy to Render (use Blueprint with render.yaml)
# 3. Setup Cloudflare R2
# 4. Deploy frontend to Cloudflare Pages
# 5. Update FRONTEND_URL in Render
# 6. Done! 🚀
```
