# Social Media Integration Guide

## How to Add Social Media Accounts to Postiz

### Prerequisites
- Postiz app deployed and running
- Access to social media developer portals
- Admin access to social media accounts you want to connect

---

## 1. Twitter/X Integration

### Get API Credentials:
1. Go to https://developer.twitter.com/en/portal/dashboard
2. Create a new app or use existing
3. Go to **Keys and tokens**
4. Copy:
   - API Key → `X_API_KEY`
   - API Secret → `X_API_SECRET`

### Set OAuth Redirect:
- Add to Twitter app settings:
  ```
  https://your-app.vercel.app/api/auth/callback/twitter
  ```

### Add to Environment Variables:
```bash
X_API_KEY=your_api_key
X_API_SECRET=your_api_secret
```

---

## 2. LinkedIn Integration

### Get API Credentials:
1. Go to https://www.linkedin.com/developers/apps
2. Create new app
3. Go to **Auth** tab
4. Copy:
   - Client ID → `LINKEDIN_CLIENT_ID`
   - Client Secret → `LINKEDIN_CLIENT_SECRET`

### Set OAuth Redirect:
```
https://your-app.vercel.app/api/auth/callback/linkedin
```

### Add to Environment Variables:
```bash
LINKEDIN_CLIENT_ID=your_client_id
LINKEDIN_CLIENT_SECRET=your_client_secret
```

---

## 3. Facebook/Instagram Integration

### Get API Credentials:
1. Go to https://developers.facebook.com/apps
2. Create new app (Type: Business)
3. Add **Facebook Login** product
4. Copy App ID and Secret

### Set OAuth Redirect:
```
https://your-app.vercel.app/api/auth/callback/facebook
```

### Add to Environment Variables:
```bash
FACEBOOK_APP_ID=your_app_id
FACEBOOK_APP_SECRET=your_app_secret
```

**Note**: Instagram requires Facebook Business account and approved app

---

## 4. YouTube Integration

### Get API Credentials:
1. Go to https://console.cloud.google.com/
2. Create new project
3. Enable **YouTube Data API v3**
4. Create OAuth 2.0 credentials
5. Copy Client ID and Secret

### Set OAuth Redirect:
```
https://your-app.vercel.app/api/auth/callback/youtube
```

### Add to Environment Variables:
```bash
YOUTUBE_CLIENT_ID=your_client_id
YOUTUBE_CLIENT_SECRET=your_client_secret
```

---

## 5. TikTok Integration

### Get API Credentials:
1. Go to https://developers.tiktok.com/
2. Create new app
3. Request **Content Posting API** access
4. Copy Client Key and Secret

### Set OAuth Redirect:
```
https://your-app.vercel.app/api/auth/callback/tiktok
```

### Add to Environment Variables:
```bash
TIKTOK_CLIENT_ID=your_client_key
TIKTOK_CLIENT_SECRET=your_client_secret
```

---

## 6. Pinterest Integration

### Get API Credentials:
1. Go to https://developers.pinterest.com/apps/
2. Create new app
3. Copy App ID and Secret

### Set OAuth Redirect:
```
https://your-app.vercel.app/api/auth/callback/pinterest
```

### Add to Environment Variables:
```bash
PINTEREST_CLIENT_ID=your_app_id
PINTEREST_CLIENT_SECRET=your_app_secret
```

---

## 7. Reddit Integration

### Get API Credentials:
1. Go to https://www.reddit.com/prefs/apps
2. Create new app (Type: web app)
3. Copy Client ID and Secret

### Set OAuth Redirect:
```
https://your-app.vercel.app/api/auth/callback/reddit
```

### Add to Environment Variables:
```bash
REDDIT_CLIENT_ID=your_client_id
REDDIT_CLIENT_SECRET=your_client_secret
```

---

## 8. Discord Integration

### Get API Credentials:
1. Go to https://discord.com/developers/applications
2. Create new application
3. Go to **OAuth2** tab
4. Copy Client ID and Secret

### Set OAuth Redirect:
```
https://your-app.vercel.app/api/auth/callback/discord
```

### Add to Environment Variables:
```bash
DISCORD_CLIENT_ID=your_client_id
DISCORD_CLIENT_SECRET=your_client_secret
```

---

## 9. Slack Integration

### Get API Credentials:
1. Go to https://api.slack.com/apps
2. Create new app
3. Add OAuth scopes: `chat:write`, `channels:read`
4. Copy Client ID, Secret, and Signing Secret

### Set OAuth Redirect:
```
https://your-app.vercel.app/api/auth/callback/slack
```

### Add to Environment Variables:
```bash
SLACK_ID=your_client_id
SLACK_SECRET=your_client_secret
SLACK_SIGNING_SECRET=your_signing_secret
```

---

## 10. Mastodon Integration

### Get API Credentials:
1. Go to your Mastodon instance (e.g., mastodon.social)
2. Settings → Development → New Application
3. Copy Client ID and Secret

### Add to Environment Variables:
```bash
MASTODON_URL=https://mastodon.social
MASTODON_CLIENT_ID=your_client_id
MASTODON_CLIENT_SECRET=your_client_secret
```

---

## 11. Bluesky Integration

Bluesky doesn't require OAuth - users connect with their credentials directly in the app.

---

## 12. Threads Integration

### Get API Credentials:
1. Go to https://developers.facebook.com/apps
2. Use same app as Facebook
3. Enable Threads API access

### Add to Environment Variables:
```bash
THREADS_APP_ID=your_app_id
THREADS_APP_SECRET=your_app_secret
```

---

## After Adding Credentials

### 1. Add to Vercel:
Go to **Vercel Dashboard → Your Project → Settings → Environment Variables**

Paste all your credentials and **redeploy**.

### 2. Connect in Postiz UI:
1. Login to your deployed Postiz app
2. Go to **Settings → Integrations** (or **Channels**)
3. Click **Connect** for each platform
4. Authorize via OAuth popup
5. Platform will redirect back to Postiz

### 3. Start Posting:
- Create new post
- Select connected accounts
- Schedule or publish immediately

---

## Troubleshooting

**OAuth fails?**
- Check redirect URLs match exactly
- Verify environment variables are set
- Redeploy after adding variables

**Can't see integration option?**
- Environment variables not set
- Need to redeploy for changes to take effect

**"Invalid credentials" error?**
- Double-check API keys
- Ensure no extra spaces in environment variables
- Regenerate keys if needed

---

## Quick Checklist

- [ ] Get API credentials from platform
- [ ] Add to Vercel environment variables
- [ ] Set OAuth redirect URL in platform settings
- [ ] Redeploy Vercel app
- [ ] Connect in Postiz UI
- [ ] Test posting
