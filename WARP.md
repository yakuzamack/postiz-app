# WARP.md - AlWeam-MC.RAK Project Documentation

## Project Overview

**Project Name:** AlWeam-MC.RAK  
**Original Base:** Postiz (Social Media Scheduling Tool)  
**Repository:** https://github.com/yakuzamack/postiz-app  
**License:** AGPL-3.0  
**Status:** 🚀 In Active Development & Deployment

### What is AlWeam-MC.RAK?

AlWeam-MC.RAK is a rebranded and customized version of Postiz - an open-source AI-powered social media scheduling and management platform. This fork has been customized for the AlWeam Media Centre in Ras Al Khaimah (RAK), UAE.

## 🏗️ Project Architecture

### Monorepo Structure (NX-based)

```
postiz-app/
├── apps/                          # Application packages
│   ├── backend/                   # NestJS API server
│   ├── frontend/                  # Next.js web application
│   ├── workers/                   # Background job processors (BullMQ)
│   ├── cron/                      # Scheduled task handlers
│   ├── extension/                 # Browser extension
│   ├── sdk/                       # SDK for integrations
│   └── commands/                  # CLI utilities
│
├── libraries/                     # Shared libraries
│   ├── nestjs-libraries/         # Backend shared code
│   │   └── src/database/prisma/  # Database schema & migrations
│   ├── react-shared-libraries/   # Frontend shared components
│   └── helpers/                  # Utility functions
│
├── .env                          # Local environment config
├── .env.production              # Production environment config
├── docker-compose.dev.yaml      # Local development services
├── render.yaml                  # Render.com deployment config
└── migrate-db.sh               # Database migration script
```

## 🛠️ Tech Stack

### Core Technologies

- **Monorepo:** NX Workspace
- **Frontend:** Next.js 14 (React 18) + TailwindCSS
- **Backend:** NestJS (Node.js)
- **Database:** PostgreSQL 17 + Prisma ORM
- **Cache/Queue:** Redis + BullMQ
- **Package Manager:** pnpm 10.6.1
- **Node Version:** 22.x

### Key Dependencies

#### Frontend
- Next.js 14.2.30
- React 18.3.1
- TailwindCSS 4.1.7
- TipTap (Rich text editor)
- Uppy (File uploads)
- Chart.js (Analytics)
- i18next (Internationalization)

#### Backend
- NestJS 10.x
- Prisma 6.5.0
- BullMQ 5.12.12 (Job queue)
- JWT Authentication
- AWS S3 SDK (Cloudflare R2)

#### AI/Automation
- OpenAI SDK
- LangChain
- Mastra (AI agents)
- CopilotKit

## 📦 Application Components

### 1. Backend (`apps/backend`)
- **Port:** 3000 (local) / 10000 (Render)
- **Purpose:** REST API, authentication, business logic
- **Features:**
  - User authentication & authorization
  - Social media integration management
  - Post scheduling & publishing
  - Analytics & reporting
  - Webhook handlers

### 2. Frontend (`apps/frontend`)
- **Port:** 4200 (local)
- **Purpose:** User interface & dashboard
- **Features:**
  - Social media post composer
  - Content calendar
  - Analytics dashboard
  - Team collaboration
  - Settings & integrations

### 3. Workers (`apps/workers`)
- **Purpose:** Background job processing
- **Features:**
  - Post publishing to social platforms
  - Image processing
  - Scheduled tasks execution
  - Queue management

### 4. Cron (`apps/cron`)
- **Schedule:** Every 5 minutes
- **Purpose:** Periodic tasks
- **Features:**
  - Check scheduled posts
  - Sync social media accounts
  - Clean up expired data
  - Health checks

## 🗄️ Database Schema

**Primary Database:** PostgreSQL (Prisma)

### Key Tables
- `User` - User accounts
- `Organization` - Team/workspace management
- `Integration` - Social media connections
- `Post` - Scheduled/published posts
- `Media` - Uploaded files & images
- `Analytics` - Performance metrics

**Schema Location:** `libraries/nestjs-libraries/src/database/prisma/schema.prisma`

## 🌐 Deployment Architecture

### Production Stack

#### Render.com Services
1. **postiz-backend** (Web Service)
   - URL: https://postiz-backend-fbp3.onrender.com
   - Plan: Standard
   - Region: Oregon
   - Build: `pnpm install && ./migrate-db.sh && pnpm build:backend`
   - Start: `pnpm start:prod:backend`

2. **postiz-workers** (Background Worker)
   - Plan: Standard
   - Region: Oregon
   - Processes: Post publishing, media processing

3. **postiz-cron** (Cron Job)
   - Plan: Starter
   - Schedule: */5 * * * * (every 5 minutes)

4. **postiz-db** (PostgreSQL)
   - Plan: Basic 256MB
   - Version: 17
   - Database: postiz_ks6t
   - User: postiz

5. **postiz-redis** (Key-Value Store)
   - Plan: Standard
   - Version: 8.1.4
   - Policy: allkeys-lru

#### Vercel (Frontend - Future)
- Currently deploying to Render
- Can be migrated to Vercel for better Next.js performance

### Environment Variables

**Required:**
- `DATABASE_URL` - PostgreSQL connection string
- `REDIS_URL` - Redis connection string
- `JWT_SECRET` - Authentication secret
- `FRONTEND_URL` - Frontend URL
- `NEXT_PUBLIC_BACKEND_URL` - Backend API URL
- `BACKEND_INTERNAL_URL` - Internal backend URL

**Optional (Social Media APIs):**
- Twitter/X, LinkedIn, Reddit, Facebook, Instagram
- TikTok, Pinterest, YouTube, Discord, Slack
- Threads, Mastodon, Bluesky

**Storage (Cloudflare R2):**
- `CLOUDFLARE_ACCOUNT_ID`
- `CLOUDFLARE_ACCESS_KEY`
- `CLOUDFLARE_SECRET_ACCESS_KEY`
- `CLOUDFLARE_BUCKETNAME`
- `CLOUDFLARE_BUCKET_URL`

## 🎨 Rebranding Changes

### Completed
- ✅ Changed project name from "Postiz" to "AlWeam-MC.RAK"
- ✅ Updated package.json names
- ✅ Replaced logos with AlWeam logo (from https://alweamcentre.com/logo.jpg)
- ✅ Updated page titles and metadata
- ✅ Modified auth layouts and components
- ✅ Environment variable prefixes (POSTIZ_ → ALWEAM_)

### Files Modified
- `package.json` (root and apps)
- `apps/frontend/src/app/(app)/auth/layout.tsx`
- `apps/frontend/src/components/layout/layout.settings.tsx`
- Multiple component files referencing "Postiz"
- Environment variable references

## 🚀 Development Workflow

### Local Development Setup

```bash
# Install dependencies
pnpm install

# Start local services (PostgreSQL + Redis)
docker compose -f docker-compose.dev.yaml up -d

# Run database migrations
pnpm run prisma-db-push

# Generate Prisma client
pnpm run prisma-generate

# Start all services in dev mode
pnpm run dev
```

### Individual Service Development

```bash
# Backend only
pnpm run dev:backend

# Frontend only
pnpm run dev:frontend

# Workers only
pnpm run dev:workers

# Cron only
pnpm run dev:cron
```

### Database Management

```bash
# Push schema changes
pnpm run prisma-db-push

# Reset database (WARNING: deletes all data)
pnpm run prisma-reset

# Open Prisma Studio
pnpm dlx prisma studio --schema ./libraries/nestjs-libraries/src/database/prisma/schema.prisma
```

### Build for Production

```bash
# Build all apps
pnpm run build

# Build specific apps
pnpm run build:backend
pnpm run build:frontend
pnpm run build:workers
pnpm run build:cron
```

## 📝 Scripts Reference

| Script | Description |
|--------|-------------|
| `pnpm dev` | Start all services in development mode |
| `pnpm build` | Build all applications |
| `pnpm start:prod:backend` | Start backend in production |
| `pnpm start:prod:frontend` | Start frontend in production |
| `pnpm prisma-generate` | Generate Prisma client |
| `pnpm prisma-db-push` | Push schema to database |
| `./migrate-db.sh` | Run database migrations (used in CI/CD) |

## 🔧 Configuration Files

### Key Configuration Files
- `.env` - Local development environment
- `.env.production` - Production environment template
- `render.yaml` - Render.com infrastructure as code
- `docker-compose.dev.yaml` - Local services (PostgreSQL, Redis)
- `next.config.js` - Next.js configuration
- `nest-cli.json` - NestJS configuration
- `nx.json` - NX monorepo configuration
- `tsconfig.json` - TypeScript configuration

## 🐛 Known Issues & Solutions

### Issue 1: Database Tables Not Found
**Error:** `The table 'public.User' does not exist in the current database`

**Solution:** Ensure migrations run during build:
```bash
./migrate-db.sh
```
This is now automated in the `render.yaml` build command.

### Issue 2: Logo Display Issues
**Fixed:** Removed old Postiz SVG, replaced with AlWeam logo with proper sizing.

### Issue 3: Memory Limits on Render Free Tier
**Solution:** Workers and Cron are disabled by default. Upgrade to Standard plan to enable.

## 📊 Monitoring & Logs

### Render Dashboard
- Backend: https://dashboard.render.com/web/srv-d3vfknje5dus73abjh00
- View logs, metrics, and deployment history

### Render CLI
```bash
# List all services
render services list -o json

# View service logs
render logs srv-d3vfknje5dus73abjh00

# Get service details
render services get srv-d3vfknje5dus73abjh00 -o json
```

## 🔐 Security Notes

- All passwords and API keys stored as environment variables
- JWT tokens for authentication
- OAuth flows for social media platforms
- HTTPS enforced in production
- Rate limiting enabled
- SQL injection protection via Prisma ORM

## 📚 Additional Documentation

- [Setup Guide](SETUP_COMPLETE.md)
- [Deployment Summary](DEPLOYMENT_SUMMARY.md)
- [Render Deployment](RENDER_DEPLOYMENT.md)
- [Vercel Deployment](VERCEL_DEPLOYMENT.md)
- [User Guide](POSTIZ_USER_GUIDE.md)
- [Social Media Setup](SOCIAL_MEDIA_SETUP.md)

## 🤝 Contributing

This is a private fork for AlWeam Media Centre. For contributions:
1. Create feature branch from `main`
2. Make changes and test locally
3. Push to trigger auto-deploy on Render
4. Verify deployment in production

## 🎯 Supported Social Platforms

- ✅ Twitter/X
- ✅ LinkedIn
- ✅ Facebook
- ✅ Instagram
- ✅ TikTok
- ✅ YouTube
- ✅ Pinterest
- ✅ Reddit
- ✅ Discord
- ✅ Slack
- ✅ Threads
- ✅ Mastodon
- ✅ Bluesky
- ✅ Dribbble

## 📞 Support

**Repository:** https://github.com/yakuzamack/postiz-app  
**Original Project:** https://github.com/gitroomhq/postiz-app  
**Documentation:** https://docs.postiz.com

---

**Last Updated:** 2025-10-28  
**Version:** 1.0.0  
**Maintained by:** AlWeam Media Centre Team
