# Cloudflare Pages Deployment Guide

This guide shows you how to deploy Postiz with the **frontend on Cloudflare Pages** and **backend on Railway**.

## Architecture

```
┌─────────────────────┐      API calls       ┌──────────────────┐
│  Cloudflare Pages   │ ───────────────────> │     Railway      │
│   (Frontend/UI)     │                      │  (Backend/API)   │
└─────────────────────┘                      └──────────────────┘
                                                      │
                                                      ├─> PostgreSQL
                                                      └─> Redis
```

---

## Step 1: Deploy Backend to Railway

### 1.1 Create Railway Account
- Go to [railway.app](https://railway.app)
- Sign up/login with GitHub

### 1.2 Deploy Services
Click the button or follow manual steps:

[![Deploy on Railway](https://railway.app/button.svg)](https://railway.app/template)

**Manual deployment:**

1. Create new project in Railway
2. Add **PostgreSQL** database
3. Add **Redis** database
4. Add **Backend** service from GitHub repo:
   - Connect your GitHub repository
   - Root directory: `/`
   - Build command: `pnpm run build:backend`
   - Start command: `pnpm run start:prod:backend`
   
5. Add **Workers** service:
   - Build command: `pnpm run build:workers`
   - Start command: `pnpm run start:prod:workers`
   
6. Add **Cron** service:
   - Build command: `pnpm run build:cron`
   - Start command: `pnpm run start:prod:cron`

### 1.3 Configure Environment Variables

In Railway, set these variables for **all services** (Backend, Workers, Cron):

```bash
# Database (Auto-filled by Railway PostgreSQL)
DATABASE_URL=${{Postgres.DATABASE_URL}}

# Redis (Auto-filled by Railway Redis)
REDIS_URL=${{Redis.REDIS_URL}}

# JWT
JWT_SECRET="your-random-jwt-secret-min-32-chars"

# URLs (replace with your Railway backend URL)
BACKEND_INTERNAL_URL="https://your-backend.railway.app"
NEXT_PUBLIC_BACKEND_URL="https://your-backend.railway.app"
FRONTEND_URL="https://your-site.pages.dev"

# Cloudflare R2 (for media storage)
CLOUDFLARE_ACCOUNT_ID="your-account-id"
CLOUDFLARE_ACCESS_KEY="your-access-key"
CLOUDFLARE_SECRET_ACCESS_KEY="your-secret-key"
CLOUDFLARE_BUCKETNAME="postiz-uploads"
CLOUDFLARE_BUCKET_URL="https://your-bucket.r2.cloudflarestorage.com/"
CLOUDFLARE_REGION="auto"
STORAGE_PROVIDER="cloudflare"

# Email (optional - Resend)
RESEND_API_KEY="re_your_key"
EMAIL_FROM_ADDRESS="noreply@yourdomain.com"
EMAIL_FROM_NAME="Postiz"

# Social Media APIs (add as needed)
X_API_KEY=""
X_API_SECRET=""
LINKEDIN_CLIENT_ID=""
LINKEDIN_CLIENT_SECRET=""
# ... add others from .env.example

# Misc
IS_GENERAL="true"
NODE_ENV="production"
```

### 1.4 Get Your Backend URL
After deployment, Railway will give you a URL like:
```
https://postiz-backend-production-xxxx.railway.app
```

**Save this URL** - you'll need it for Cloudflare Pages.

---

## Step 2: Deploy Frontend to Cloudflare Pages

### 2.1 Install Wrangler CLI (if not already)
```bash
npm install -g wrangler
wrangler login
```

### 2.2 Create Cloudflare Pages Project

**Option A: Via Dashboard (Easiest)**
1. Go to [Cloudflare Dashboard](https://dash.cloudflare.com)
2. Navigate to **Workers & Pages** > **Create application** > **Pages**
3. Connect your GitHub repository
4. Configure build settings:
   - **Build command**: `pnpm run build:frontend` or use custom: `./cloudflare-build.sh`
   - **Build output directory**: `apps/frontend/out`
   - **Root directory**: `/`
   - **Node version**: `22`

**Option B: Via CLI**
```bash
# Build locally first
pnpm install
cd apps/frontend
NODE_ENV=production pnpm run build

# Deploy
wrangler pages deploy out --project-name=postiz-frontend
```

### 2.3 Configure Environment Variables

In Cloudflare Pages settings, add:

```bash
# Backend URL (from Railway)
NEXT_PUBLIC_BACKEND_URL="https://your-backend.railway.app"
FRONTEND_URL="https://your-site.pages.dev"

# Cloudflare (same as backend)
CLOUDFLARE_ACCOUNT_ID="your-account-id"
CLOUDFLARE_ACCESS_KEY="your-access-key"
CLOUDFLARE_SECRET_ACCESS_KEY="your-secret-key"
CLOUDFLARE_BUCKETNAME="postiz-uploads"
CLOUDFLARE_BUCKET_URL="https://your-bucket.r2.cloudflarestorage.com/"
CLOUDFLARE_REGION="auto"
STORAGE_PROVIDER="cloudflare"

# Optional: Sentry
SENTRY_ORG="your-org"
SENTRY_PROJECT="your-project"
SENTRY_AUTH_TOKEN="your-token"
```

### 2.4 Update CORS in Backend

After deployment, update your Railway backend's `FRONTEND_URL` environment variable with your Cloudflare Pages URL:

```bash
FRONTEND_URL="https://your-site.pages.dev"
```

Redeploy the backend service in Railway.

---

## Step 3: Setup Cloudflare R2 Storage

### 3.1 Create R2 Bucket
1. Go to Cloudflare Dashboard > **R2**
2. Click **Create bucket**
3. Name: `postiz-uploads`
4. Enable **Public access** or configure custom domain

### 3.2 Create API Token
1. Go to **R2** > **Manage R2 API Tokens**
2. Create token with:
   - **Object Read & Write** permissions
   - **Apply to specific bucket**: `postiz-uploads`
3. Save the `Access Key ID` and `Secret Access Key`

### 3.3 Get Bucket URL
```
https://pub-xxxxxxxxxxxxx.r2.dev
```
or use custom domain.

---

## Step 4: Test Your Deployment

1. Visit your Cloudflare Pages URL: `https://your-site.pages.dev`
2. Register a new account
3. Try posting to a social media account
4. Check Railway logs if issues occur

---

## Troubleshooting

### CORS Errors
- Ensure `FRONTEND_URL` in Railway matches your Cloudflare Pages URL exactly
- Check backend logs in Railway

### Database Connection Issues
- Verify `DATABASE_URL` is set correctly in Railway
- Check PostgreSQL service is running

### Image Upload Fails
- Verify R2 credentials in both Railway and Cloudflare Pages
- Check bucket permissions

### Build Fails
- Ensure Node version is 22.x
- Check build logs in Cloudflare Pages dashboard

---

## Updating Your Deployment

### Frontend (Cloudflare Pages)
- Push to GitHub - auto-deploys via GitHub integration
- OR: Build locally and run `wrangler pages deploy out`

### Backend (Railway)
- Push to GitHub - Railway auto-deploys
- OR: Manually trigger deployment in Railway dashboard

---

## Cost Estimate

- **Cloudflare Pages**: Free tier (500 builds/month)
- **Railway**: ~$5-20/month (depends on usage)
  - PostgreSQL: $5/month minimum
  - Redis: $5/month minimum  
  - Compute: Pay per usage
- **Cloudflare R2**: $0.015/GB stored, $0.36/million reads

**Total**: ~$10-25/month for small to medium usage

---

## Alternative: Simpler Option

If this seems complex, you can use **Vercel** for frontend (already configured in `vercel.json`) instead of Cloudflare Pages. The backend setup on Railway remains the same.

Deploy to Vercel:
```bash
vercel --prod
```

---

## Need Help?

- [Postiz Discord](https://discord.postiz.com)
- [Railway Docs](https://docs.railway.app)
- [Cloudflare Pages Docs](https://developers.cloudflare.com/pages)
