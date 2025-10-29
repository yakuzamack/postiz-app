# Postiz App - Complete Deployment Verification & Instructions

**Generated**: October 29, 2025
**Project**: Postiz Social Media Scheduler
**Architecture**: Frontend (Vercel) + Backend (Render) + Storage (Cloudflare R2)

---

## 🎯 Current Deployment Status

### ✅ Authenticated Services
1. **GitHub** - ✅ Connected (yakuzamack/postiz-app)
2. **Vercel** - ✅ Authenticated (xyakuzapro@hotmail.com)
3. **Render** - ✅ Authenticated (tompralong49@gmail.com)
4. **Cloudflare** - ✅ Authenticated (xyakuzapro@hotmail.com)
   - Account ID: `0a36854052d818a17ee27bd1b2fb3ba3`

### 📊 Service Status

#### Frontend (Vercel)
- **Production URL**: https://postiz-app-jet.vercel.app
- **Status**: ✅ Deployed & Running (HTTP 307 redirecting to /auth)
- **Latest Deploy**: 17h ago
- **Build Status**: ✅ Successful

#### Backend (Render)
- **Production URL**: https://postiz-backend-fbp3.onrender.com
- **Status**: ✅ Running (HTTP 200 - "App is running!")
- **Health Check**: ✅ Passing

#### Environment Variables Status

**Vercel (Frontend)** - ✅ 12 Variables Set:
- ✅ `BACKEND_INTERNAL_URL`
- ✅ `NEXT_PUBLIC_BACKEND_URL`
- ✅ `FRONTEND_URL`
- ✅ `CLOUDFLARE_ACCOUNT_ID`
- ✅ `CLOUDFLARE_ACCESS_KEY`
- ✅ `CLOUDFLARE_SECRET_ACCESS_KEY`
- ✅ `CLOUDFLARE_BUCKETNAME`
- ✅ `CLOUDFLARE_BUCKET_URL`
- ✅ `CLOUDFLARE_REGION`
- ✅ `STORAGE_PROVIDER`
- ✅ `IS_GENERAL`
- ✅ `NODE_ENV`

---

## ⚠️ Critical Issues Found

### Issue #1: Cloudflare R2 Bucket Not Configured
**Status**: ❌ CRITICAL - Must Fix

**Problem**:
- R2 bucket list command failed with error: `Could not route to /client/v4/accounts/your-account-id/r2/buckets`
- This indicates the Cloudflare Account ID is a placeholder value "your-account-id"
- File uploads (profile pictures, media) will not work

**Solution**:
1. Update Cloudflare credentials with real values
2. Create R2 bucket
3. Update environment variables in both Vercel and Render

---

## 🚀 Step-by-Step Deployment Verification

### Step 1: Setup Cloudflare R2 Storage (CRITICAL)

#### 1.1 Create R2 Bucket
```bash
# Using Wrangler CLI
wrangler r2 bucket create postiz-uploads

# Verify bucket was created
wrangler r2 bucket list
```

#### 1.2 Generate R2 API Tokens
1. Go to: https://dash.cloudflare.com/profile/api-tokens
2. Click "Create Token"
3. Use "Edit Cloudflare Workers" template or create custom with:
   - Permissions: Account > R2 > Edit
   - Account Resources: Include > Your Account
4. Click "Continue to summary" → "Create Token"
5. **Save the token** (you won't see it again!)

#### 1.3 Get Your Access Keys
```bash
# In Cloudflare Dashboard:
# R2 → Manage R2 API Tokens → Create API Token
# Save both:
# - Access Key ID
# - Secret Access Key
```

#### 1.4 Get Your Bucket URL
```bash
# After creating bucket, get the public URL:
# Option 1: Custom Domain (recommended)
# R2 → Your Bucket → Settings → Custom Domains → Add

# Option 2: Use R2.dev subdomain (for testing)
# R2 → Your Bucket → Settings → R2.dev Subdomain → Allow Access
```

---

### Step 2: Update Environment Variables

#### 2.1 Update Vercel Environment Variables
```bash
# Get your actual Cloudflare Account ID
CLOUDFLARE_ACCOUNT_ID="0a36854052d818a17ee27bd1b2fb3ba3"

# Update these variables in Vercel:
vercel env rm CLOUDFLARE_ACCOUNT_ID production
vercel env add CLOUDFLARE_ACCOUNT_ID production
# Enter: 0a36854052d818a17ee27bd1b2fb3ba3

vercel env rm CLOUDFLARE_ACCESS_KEY production
vercel env add CLOUDFLARE_ACCESS_KEY production
# Enter: your-actual-access-key-from-r2

vercel env rm CLOUDFLARE_SECRET_ACCESS_KEY production
vercel env add CLOUDFLARE_SECRET_ACCESS_KEY production
# Enter: your-actual-secret-key-from-r2

vercel env rm CLOUDFLARE_BUCKETNAME production
vercel env add CLOUDFLARE_BUCKETNAME production
# Enter: postiz-uploads

vercel env rm CLOUDFLARE_BUCKET_URL production
vercel env add CLOUDFLARE_BUCKET_URL production
# Enter: https://pub-xxxxx.r2.dev (your actual R2 URL)

# Redeploy to apply changes
vercel --prod
```

#### 2.2 Update Render Environment Variables

Using Render Dashboard:
1. Go to: https://dashboard.render.com/
2. Select `postiz-backend` service
3. Go to "Environment" tab
4. Update these variables:
   ```
   CLOUDFLARE_ACCOUNT_ID=0a36854052d818a17ee27bd1b2fb3ba3
   CLOUDFLARE_ACCESS_KEY=<your-access-key>
   CLOUDFLARE_SECRET_ACCESS_KEY=<your-secret-key>
   CLOUDFLARE_BUCKETNAME=postiz-uploads
   CLOUDFLARE_BUCKET_URL=https://pub-xxxxx.r2.dev
   CLOUDFLARE_REGION=auto
   STORAGE_PROVIDER=cloudflare
   FRONTEND_URL=https://postiz-app-jet.vercel.app
   ```
5. Click "Save Changes"
6. Service will automatically redeploy

---

### Step 3: Verify Database & Redis (Render)

#### 3.1 Check PostgreSQL Database
```bash
# Using Render CLI
render services list

# Check database status
# Should show: postiz-db (PostgreSQL) - Running
```

#### 3.2 Verify Database Connection
```bash
# Test backend can connect to database
curl https://postiz-backend-fbp3.onrender.com/

# Should return: "App is running!"
```

#### 3.3 Run Database Migrations
The migrations should run automatically on deploy via `migrate-db.sh`, but you can verify:

```bash
# Check if tables exist by testing an API endpoint
curl https://postiz-backend-fbp3.onrender.com/api/health

# Or check Render logs:
# Dashboard → postiz-backend → Logs
# Look for: "Prisma schema loaded" or "Database connected"
```

---

### Step 4: Test Full Application Flow

#### 4.1 Test Frontend-Backend Communication
```bash
# Test that frontend can reach backend
curl -I https://postiz-app-jet.vercel.app/api/health

# Should redirect to backend and return 200 OK
```

#### 4.2 Test Authentication Flow
1. Open browser: https://postiz-app-jet.vercel.app
2. You should see login/register page
3. Try to register a new account
4. Check email for activation (if RESEND_API_KEY is set)

#### 4.3 Test Social Media Account Connection
1. Login to your account
2. Go to "Integrations" or "Add Account"
3. Try connecting a social media account
4. This will test:
   - OAuth flow
   - Database writes
   - Storage for profile pictures (Cloudflare R2)

---

### Step 5: Add Social Media Provider Credentials

To enable social media posting, add these environment variables to **both Vercel and Render**:

#### Twitter/X
```bash
X_API_KEY=your-twitter-api-key
X_API_SECRET=your-twitter-api-secret
```
Get from: https://developer.twitter.com/en/portal/dashboard

#### LinkedIn
```bash
LINKEDIN_CLIENT_ID=your-linkedin-client-id
LINKEDIN_CLIENT_SECRET=your-linkedin-client-secret
```
Get from: https://www.linkedin.com/developers/apps

#### Facebook/Instagram
```bash
FACEBOOK_APP_ID=your-facebook-app-id
FACEBOOK_APP_SECRET=your-facebook-app-secret
```
Get from: https://developers.facebook.com/apps

#### YouTube
```bash
YOUTUBE_CLIENT_ID=your-youtube-client-id
YOUTUBE_CLIENT_SECRET=your-youtube-client-secret
```
Get from: https://console.cloud.google.com/apis/credentials

#### TikTok
```bash
TIKTOK_CLIENT_ID=your-tiktok-client-id
TIKTOK_CLIENT_SECRET=your-tiktok-client-secret
```
Get from: https://developers.tiktok.com/

#### Discord
```bash
DISCORD_CLIENT_ID=your-discord-client-id
DISCORD_CLIENT_SECRET=your-discord-client-secret
DISCORD_BOT_TOKEN_ID=your-discord-bot-token
```
Get from: https://discord.com/developers/applications

#### Reddit
```bash
REDDIT_CLIENT_ID=your-reddit-client-id
REDDIT_CLIENT_SECRET=your-reddit-client-secret
```
Get from: https://www.reddit.com/prefs/apps

---

## 🔍 Troubleshooting Guide

### Issue: Frontend shows "Cannot connect to server"
**Solution**:
1. Check backend is running: `curl https://postiz-backend-fbp3.onrender.com/`
2. Verify CORS settings allow frontend URL
3. Check Vercel env var `NEXT_PUBLIC_BACKEND_URL` is correct

### Issue: "Authentication failed" when adding social accounts
**Solution**:
1. Verify social media API credentials are set
2. Check callback URLs in social media app settings match your frontend URL
3. Example LinkedIn callback: `https://postiz-app-jet.vercel.app/integrations/linkedin/callback`

### Issue: "File upload failed"
**Solution**:
1. Verify Cloudflare R2 bucket exists
2. Check R2 API credentials are correct
3. Verify `STORAGE_PROVIDER=cloudflare` is set
4. Check R2 bucket has public access or custom domain configured

### Issue: "Database connection failed"
**Solution**:
1. Check Render PostgreSQL service is running
2. Verify `DATABASE_URL` environment variable is set
3. Check database migrations ran successfully
4. Look at Render logs for Prisma errors

---

## 📋 Quick Verification Checklist

Run these commands to verify everything is working:

```bash
# 1. Check all CLIs are authenticated
echo "=== Vercel ==="
vercel whoami

echo "=== Render ==="
render whoami

echo "=== Cloudflare ==="
wrangler whoami

# 2. Test deployments
echo "=== Frontend Test ==="
curl -I https://postiz-app-jet.vercel.app

echo "=== Backend Test ==="
curl https://postiz-backend-fbp3.onrender.com/

# 3. Verify Cloudflare R2
echo "=== R2 Buckets ==="
wrangler r2 bucket list

# 4. Check environment variables
echo "=== Vercel Env Vars ==="
vercel env ls

# 5. Test API endpoint
echo "=== API Test ==="
curl https://postiz-backend-fbp3.onrender.com/api/health
```

---

## 🎯 Next Steps to Make App Fully Operational

### Priority 1: Fix Cloudflare R2 (CRITICAL)
- [ ] Create R2 bucket: `wrangler r2 bucket create postiz-uploads`
- [ ] Generate R2 API tokens
- [ ] Update environment variables in Vercel
- [ ] Update environment variables in Render
- [ ] Test file upload functionality

### Priority 2: Add Social Media Credentials
- [ ] Choose which platforms to support
- [ ] Create developer apps on each platform
- [ ] Add API credentials to environment variables
- [ ] Test OAuth flow for each platform

### Priority 3: Optional Enhancements
- [ ] Setup email (Resend) for user activation
- [ ] Configure custom domain for frontend
- [ ] Configure custom domain for R2 bucket
- [ ] Enable monitoring/logging (Sentry already configured)
- [ ] Setup payment gateway (Stripe) if needed

---

## 📚 Useful Resources

- **Frontend URL**: https://postiz-app-jet.vercel.app
- **Backend URL**: https://postiz-backend-fbp3.onrender.com
- **Vercel Dashboard**: https://vercel.com/xyakuzapro8s-projects/postiz-app
- **Render Dashboard**: https://dashboard.render.com/
- **Cloudflare Dashboard**: https://dash.cloudflare.com/
- **Documentation**: https://docs.postiz.com/

---

## 🔐 Security Notes

1. **Never commit real credentials to Git**
2. **Rotate API keys regularly**
3. **Use strong JWT_SECRET** (32+ characters)
4. **Enable 2FA on all platform accounts**
5. **Review Cloudflare R2 bucket permissions**
6. **Check CORS settings** only allow your domains

---

## 📞 Support

If you encounter issues:
1. Check Render logs: Dashboard → Service → Logs
2. Check Vercel logs: Dashboard → Deployments → Click deployment → Runtime Logs
3. Review this guide's troubleshooting section
4. Check official docs: https://docs.postiz.com/
5. Discord support: https://discord.postiz.com

---

**Last Updated**: October 29, 2025
**Status**: Ready for R2 configuration and social media setup
