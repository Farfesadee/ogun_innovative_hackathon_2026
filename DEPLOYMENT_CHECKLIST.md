# 🎯 Ogun Digital Summit 2026 - Deployment Checklist

## 📅 Tonight (Before Hackathon)

### 1. Repository Setup
- [ ] Create new GitHub repo: `gh repo create mathgenius-hackathon --public --source=. --push`
- [ ] Verify all code pushes to `main` branch

### 2. Environment Variables
- [ ] Copy `secrets_template/.env.production.template` → `.env.production`
- [ ] Fill in **ALL** values (no placeholders!)
- [ ] Test locally:
  - `cd backend && uvicorn app.main:app --reload`
  - `cd frontend && npm run build`

### 3. Database Setup (Run in Supabase SQL Editor)
- [ ] Run `database/init.sql` in Supabase SQL Editor
- [ ] Verify all tables created in Supabase dashboard

### 4. GitHub Secrets (Repo → Settings → Secrets → Actions)
| Secret | Required | Source |
|--------|----------|--------|
| `NOBUS_API_TOKEN` | ✅ | Nobus Dashboard → API Tokens |
| `NOBUS_PROJECT_ID` | ✅ | Nobus Project Settings |
| `GROQ_API_KEY` | ✅ | `your_groq_api_key_here` |
| `SUPABASE_URL` | ✅ | Supabase Dashboard → Settings → API |
| `SUPABASE_SERVICE_KEY` | ✅ | Supabase Dashboard → Settings → API |
| `SUPABASE_JWT_SECRET` | ✅ | Supabase Dashboard → Settings → API |
| `DATABASE_URL` | ✅ | From Nobus PostgreSQL creation |
| `SMTP_PASSWORD` | ✅ | `your_smtp_password_here` |
| `ADMIN_EMAILS` | ✅ | `your_gmail@gmail.com,teammate@gmail.com` |
| `ADMIN_EMAIL` | ✅ | `help@mathgenius.guru` |
| `SMTP_PASSWORD` | ✅ | `your_smtp_password_here` |
| `SMTP_REPLY_TO` | ✅ | `help@mathgenius.guru` |
| `FRONTEND_URL` | ✅ | `https://mathgenius.guru` |
| `SUPABASE_URL` | ✅ | `https://your-project.supabase.co` |
| `SUPABASE_SERVICE_KEY` | ✅ | Supabase Dashboard |
| `SUPABASE_JWT_SECRET` | ✅ | Supabase Dashboard |
| `DATABASE_URL` | ✅ | From Nobus PostgreSQL creation |
| `SMTP_PASSWORD` | ✅ | `your_smtp_password_here` |
| `SUPABASE_SERVICE_KEY` | ✅ | Supabase Dashboard |
| `SUPABASE_JWT_SECRET` | ✅ | Supabase Dashboard |

### 5. Supabase Setup (Keep for Auth + Storage)
- [ ] Create Supabase project
- [ ] Enable Google OAuth provider
- [ ] Set Site URL: `https://mathgenius.guru`
- [ ] Add Redirect URLs: `https://mathgenius.guru/**`, `http://localhost:5173/**`
- [ ] Run `database/init.sql` in SQL Editor
- [ ] Note down: Project URL, Anon Key, Service Role Key, JWT Secret

### 6. Nobus Setup (Teammate Handles)
- [ ] Create Nobus account at nobus.io
- [ ] Create project: `mathgenius-hackathon`
- [ ] Create PostgreSQL 16 instance:
  - Flavor: `standard` (2 vCPU, 4GB)
  - Size: 20 GB
  - Zone: `nobus-wa-az1`
  - Username: `mathgenius_admin`
  - **Password: AUTO-GENERATED - COPY IMMEDIATELY!**
- [ ] Create Object Storage bucket: `mathgenius-uploads` (private)
- [ ] Get API Token → GitHub Secret `NOBUS_API_TOKEN`
- [ ] Get Project ID → GitHub Secret `NOBUS_PROJECT_ID`

### 7. DNS (Already Done - Verify)
- [ ] `mathgenius.guru` → CNAME to Nobus/Render
- [ ] `www.mathgenius.guru` → CNAME to `mathgenius.guru`
- [ ] `api.mathgenius.guru` → CNAME to backend service

---

## 🎯 Hackathon Day (Tomorrow)

### 09:00 - Repo & Deploy
- [ ] Push to GitHub (triggers GitHub Actions)
- [ ] Verify GitHub Actions pass
- [ ] Verify Nobus deploy succeeds

### 09:30 - Verify
- [ ] `curl https://api.mathgenius.guru/health` → `{"status":"healthy"}`
- [ ] `curl https://mathgenius.guru/` → Loads React app
- [ ] Open `https://mathgenius.guru/admin` → "Restricted area" (good!)

### 09:30 - Admin Access
- [ ] Sign in with email in `ADMIN_EMAILS`
- [ ] Visit `/admin` → See control room
- [ ] Test: Create flag, like a post, check feedback

### 10:00 - Start Building
- [ ] Commit every 30 minutes
- [ ] Push triggers auto-deploy
- [ ] Test after each deploy

---

## 🚨 Emergency Contacts

| Issue | Contact |
|-------|---------|
| Nobus deploy fails | Teammate + Nobus: +234 703 448 4841 |
| Database connection | Check `DATABASE_URL` format |
| Groq API fails | Check `GROQ_API_KEY` in env |
| Supabase Auth broken | Check Supabase dashboard logs |

---

## 🎯 Final Verification (Before Hackathon Starts)

- [ ] All GitHub Secrets added
- [ ] Supabase tables created
- [ ] Nobus PostgreSQL created
- [ ] GitHub Actions passing
- [ ] Admin panel accessible
- [ ] Welcome email sends
- [ ] Teach chat works
- [ ] Room posts save
- [ ] Flags submit
- [ ] Admin sees flags/feedback

---

**You're ready!** 🎉

The code is production-ready. Tonight is about credentials and deployment config. Tomorrow you build features.

**Good luck!** 🚀