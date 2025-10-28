# 🚀 Postiz User Guide - Complete Setup & Features

**Your Postiz Instance**: https://postiz-app-jet.vercel.app  
**Backend API**: https://postiz-backend-fbp3.onrender.com

---

## 🎯 Getting Started

### Step 1: First Login

1. **Visit Your Postiz**:
   ```
   https://postiz-app-jet.vercel.app
   ```

2. **Register Your Account**:
   - Click "Sign Up" or "Register"
   - Enter your email and password
   - Since RESEND email is not configured, you'll be **auto-activated**
   - You'll be logged in automatically

3. **Dashboard Overview**:
   - After login, you'll see the main dashboard
   - Left sidebar: Navigation menu
   - Main area: Your posts and calendar
   - Top right: Account settings

---

## 🔗 Connecting Social Media Accounts

### Supported Platforms (14+):

✅ **Currently Supported**:
1. **X (Twitter)** - Posts, threads, media
2. **LinkedIn** - Personal & Company pages
3. **Facebook** - Pages & Groups
4. **Instagram** - Feed posts, stories
5. **YouTube** - Videos, shorts
6. **TikTok** - Videos
7. **Pinterest** - Pins, boards
8. **Reddit** - Posts to subreddits
9. **Threads** - Meta's Twitter alternative
10. **Bluesky** - Decentralized social
11. **Mastodon** - Fediverse
12. **Discord** - Channels via webhooks
13. **Slack** - Channels via webhooks
14. **Dribbble** - Design posts

### How to Connect an Account:

#### Method 1: Via Dashboard

1. **Go to Integrations**:
   - Click "Integrations" in left sidebar
   - Or visit: `https://postiz-app-jet.vercel.app/integrations`

2. **Select Platform**:
   - Click on the social media icon you want to connect
   - Example: Click "X (Twitter)"

3. **Authenticate**:
   - You'll be redirected to the platform's OAuth page
   - Login to your social media account
   - Authorize Postiz to post on your behalf

4. **Confirmation**:
   - You'll be redirected back to Postiz
   - The account will appear in your integrations list
   - Green checkmark = connected successfully

#### Setting Up Social Media API Keys (Required First!)

Before connecting accounts, you need to add API keys to your Render backend:

**For X (Twitter)**:
1. Go to: https://developer.twitter.com/en/portal/dashboard
2. Create an app and get API Key & Secret
3. Add to Render Environment:
   ```
   X_API_KEY=your-key-here
   X_API_SECRET=your-secret-here
   ```

**For LinkedIn**:
1. Go to: https://www.linkedin.com/developers/apps
2. Create an app and get Client ID & Secret
3. Add to Render:
   ```
   LINKEDIN_CLIENT_ID=your-client-id
   LINKEDIN_CLIENT_SECRET=your-secret
   ```

**For other platforms**: See `SOCIAL_MEDIA_SETUP.md` in your project folder

---

## ✨ Key Features

### 1. **Post Scheduling** 📅

**Schedule Single Posts**:
- Click "Create Post" or "+" button
- Write your content
- Add media (images, videos)
- Select platforms to post to
- Choose date/time or "Post Now"
- Click "Schedule"

**Best Times Feature**:
- AI suggests optimal posting times
- Based on your audience engagement
- Maximizes reach and interactions

### 2. **Multi-Platform Posting** 🌐

**Cross-Post to Multiple Platforms**:
- Write once, post everywhere
- Select multiple platforms in post composer
- Platform-specific optimizations:
  - X: Thread support, character limits
  - Instagram: Hashtag optimization
  - LinkedIn: Professional formatting

**Platform Customization**:
- Customize content per platform
- Different images for different networks
- Platform-specific hashtags

### 3. **Content Calendar** 📆

**Visual Schedule Management**:
- See all scheduled posts in calendar view
- Drag & drop to reschedule
- Color-coded by platform
- Week/Month views

**Bulk Actions**:
- Select multiple posts
- Reschedule in bulk
- Delete or duplicate posts

### 4. **AI Content Assistant** 🤖

**AI-Powered Features**:
- **Content Generation**: Generate post ideas
- **Hashtag Suggestions**: Relevant hashtags for your niche
- **Caption Writing**: AI writes engaging captions
- **Image Generation**: Create images with AI (if configured)

**Using AI Assistant**:
- Click the ✨ AI button in post composer
- Select "Generate Content"
- Provide a topic or keywords
- AI generates suggestions
- Edit and customize

### 5. **Thread Creator** 🧵

**Create Twitter/X Threads**:
- Click "Create Thread" in post composer
- Add multiple tweet cards
- Reorder tweets with drag & drop
- Preview before scheduling
- Auto-numbering (1/5, 2/5, etc.)

### 6. **Media Management** 📸

**Upload & Manage Media**:
- Drag & drop images/videos
- Supports: JPG, PNG, GIF, MP4
- Image editing tools:
  - Crop, resize, rotate
  - Filters and adjustments
  - Text overlays

**Media Library**:
- Store frequently used media
- Organize in folders
- Quick access for reuse

### 7. **Analytics & Insights** 📊

**Track Performance**:
- Views, likes, shares, comments
- Engagement rate
- Best performing posts
- Platform comparison

**Reports**:
- Daily/Weekly/Monthly reports
- Export to PDF/CSV
- Custom date ranges

### 8. **Team Collaboration** 👥

**Multi-User Support**:
- Invite team members
- Role-based permissions:
  - **Admin**: Full access
  - **Editor**: Create & schedule posts
  - **Viewer**: View only

**Collaboration Features**:
- Internal comments on posts
- Approval workflows
- Activity log

### 9. **RSS Feed Integration** 📰

**Auto-Post from RSS**:
- Add RSS feed URLs
- Auto-schedule new articles
- Customize post format
- Set posting frequency

### 10. **URL Shortener** 🔗

**Built-in Link Shortening**:
- Shorten long URLs
- Track click-through rates
- Custom branded short links
- Integration with bit.ly, TinyURL

### 11. **Post Templates** 📝

**Reusable Content**:
- Save frequently used formats
- Quick template selection
- Variables for dynamic content
- Time-saving for recurring posts

### 12. **Hashtag Manager** #️⃣

**Organize Hashtags**:
- Create hashtag groups
- Save hashtag sets by topic
- One-click hashtag insertion
- Popular hashtag suggestions

### 13. **Best Time to Post** ⏰

**Optimal Scheduling**:
- AI analyzes your audience
- Suggests best posting times
- Platform-specific recommendations
- Timezone-aware

### 14. **Bulk Upload** 📤

**Mass Scheduling**:
- Upload CSV with posts
- Schedule multiple posts at once
- Batch processing
- Error handling & validation

---

## 🎨 Pro Tips & Best Practices

### Content Strategy

1. **Mix Content Types**:
   - 40% educational
   - 30% entertaining
   - 20% promotional
   - 10% personal

2. **Posting Frequency**:
   - X/Twitter: 3-5 times/day
   - LinkedIn: 1-2 times/day
   - Instagram: 1-2 times/day
   - Facebook: 1-2 times/day

3. **Best Times** (General):
   - B2C: 12pm-1pm, 5pm-6pm
   - B2B: 8am-10am, 12pm-1pm
   - Weekends: 9am-11am

### Engagement Tactics

1. **Use Questions**: Increase engagement
2. **Add CTAs**: Call-to-action in every post
3. **Visual Content**: Posts with images get 2x engagement
4. **Hashtags**: 3-5 relevant hashtags optimal
5. **Respond Quickly**: Reply to comments within 1 hour

### Productivity Hacks

1. **Batch Content**: Create a week's content in one session
2. **Use Templates**: Save time with reusable formats
3. **Schedule Ahead**: Always have 7 days queued
4. **Analyze & Optimize**: Review analytics weekly
5. **Repurpose Content**: Same content, different formats

---

## 🔧 Advanced Settings

### User Settings
- Profile information
- Notification preferences
- Timezone settings
- Language selection

### Organization Settings
- Team member management
- Billing & subscription
- API access keys
- Webhook integrations

### Integration Settings
- Connected accounts
- OAuth tokens
- Permissions management
- Reconnect accounts

---

## 🆘 Troubleshooting

### Common Issues

**Account Won't Connect**:
- Check API keys in Render environment variables
- Verify OAuth redirect URLs
- Re-authorize the connection
- Check platform API status

**Posts Not Publishing**:
- Verify account is still connected
- Check platform posting limits
- Verify media file sizes
- Review error logs in dashboard

**Media Upload Fails**:
- Check Cloudflare R2 is configured
- Verify file size (max 50MB)
- Check file format support
- Review browser console errors

**Analytics Not Showing**:
- Wait 24 hours for initial data
- Verify account permissions
- Check platform API access
- Refresh the page

---

## 📚 Additional Resources

### Documentation
- **Official Docs**: https://docs.postiz.com
- **API Reference**: https://docs.postiz.com/public-api
- **Video Tutorials**: https://youtube.com/@postizofficial

### Community
- **Discord**: https://discord.postiz.com
- **GitHub Issues**: https://github.com/gitroomhq/postiz-app/issues

### Updates
- **Changelog**: Check GitHub releases
- **Feature Requests**: Submit via GitHub discussions
- **Roadmap**: See project board

---

## 🎯 Quick Start Checklist

- [ ] Register account at https://postiz-app-jet.vercel.app
- [ ] Add social media API keys to Render
- [ ] Connect your first social media account
- [ ] Create your first post
- [ ] Schedule posts for the week
- [ ] Set up analytics tracking
- [ ] Invite team members (optional)
- [ ] Configure notification preferences
- [ ] Create post templates
- [ ] Set up RSS feeds (optional)

---

## 💡 Need Help?

**Your Instance URLs**:
- Frontend: https://postiz-app-jet.vercel.app
- Backend: https://postiz-backend-fbp3.onrender.com
- Render Dashboard: https://dashboard.render.com
- Vercel Dashboard: https://vercel.com/xyakuzapro8s-projects/postiz-app

**Support**:
- Check `DEPLOYMENT_STATUS.md` for deployment issues
- Check `SOCIAL_MEDIA_SETUP.md` for API setup
- Visit Postiz Discord for community help
- Check GitHub for bug reports

---

**Enjoy your fully deployed Postiz instance! 🚀**
