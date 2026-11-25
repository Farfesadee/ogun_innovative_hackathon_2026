# 🚀 QUICKSTART - Hackathon Day

## TL;DR - 3 Commands to Deploy

```bash
# 1. Create repo & push (run once at 9:00 AM)
gh repo create mathgenius-hackathon --public --source=. --push

# 2. Add GitHub Secrets (one-time, 5 min)
# Go to: GitHub Repo → Settings → Secrets → Actions → New Repository Secret
# Add all secrets from DEPLOYMENT_CHECKLIST.md

# 3. Deploy (auto on push, or manual)
git push origin main
# Watch: GitHub Actions → Deploy workflow
```

---

## 🔑 Secrets Cheat Sheet (Copy-Paste into GitHub Secrets)

```
NOBUS_API_TOKEN=           # From Nobus Dashboard → API Tokens
NOBUS_PROJECT_ID=          # From Nobus Project Settings
GROQ_API_KEY=your_groq_api_key_here
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_SERVICE_KEY=      # Supabase → Settings → API → service_role
SUPABASE_JWT_SECRET=       # Supabase → Settings → API → JWT Secret
DATABASE_URL=postgresql://mathgenius_admin:PASSWORD@host:5432/mathgenius?sslmode=require
SMTP_PASSWORD=your_smtp_password_here
ADMIN_EMAILS=your@gmail.com,teammate@gmail.com
ADMIN_EMAIL=help@mathgenius.guru
SMTP_PASSWORD=your_smtp_password_here
SMTP_REPLY_TO=help@mathgenius.guru
FRONTEND_URL=https://mathgenius.guru
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_SERVICE_KEY=      # Supabase → Settings → API
SUPABASE_JWT_SECRET=       # Supabase → Settings → API
DATABASE_URL=postgresql://mathgenius_admin:PASS@host:5432/mathgenius?sslmode=require
```

---

## ⚡ Hackathon Day Timeline

| Time | Action |
|------|--------|
| **09:00** | `gh repo create mathgenius-hackathon --public --source=. --push` |
| **09:10** | Add all GitHub Secrets (5 min) |
| **09:15** | `git push origin main` → Watch GitHub Actions |
| **09:20** | Verify: `curl https://api.mathgenius.guru/health` |
| **09:25** | Open `https://mathgenius.guru/admin` → Sign in |
| **09:30** | **START BUILDING** |

---

## 🎯 Demo Script (Memorize This)

```
1. LANDING: "Ask Euler" free tier → 5 free questions
2. SIGN UP → Onboarding → Dashboard (shows streak/XP)
3. TEACH: Ask Euler "Solve x^2 + 5x + 6 = 0" → Step-by-step
3. PRACTICE: Answer question → Get hint → "Share to Room"
4. ROOM: See community solutions, like one
5. ADMIN: /admin → Show flags, feedback, room moderation
```

---

## 🆘 Emergency Commands

```bash
# Check deploy status
gh run list --limit 5

# View logs
gh run view --log

# Re-deploy (if needed)
gh workflow run deploy.yml

# Check API health
curl https://api.mathgenius.guru/health

# Check frontend
curl -I https://mathgenius.guru

# Admin panel
open https://mathgenius.guru/admin
```

---

## 📱 Team Roles

| Role | Person | Focus |
|------|--------|-------|
| Deploy Lead | Teammate | Nobus, GitHub Actions, env vars |
| Frontend Lead | You | UI, onboarding, chat, admin |
| Backend Lead | Teammate | API, Groq, admin endpoints |
| DB/Infra | Shared | Supabase, Nobus, indexes |

---

## 📞 Emergency Contacts

| Issue | Contact |
|-------|---------|
| Nobus deploy fails | Teammate → Nobus: +234 703 448 4841 |
| Database connection | You → Check `DATABASE_URL` |
| Groq API fails | You → Check `GROQ_API_KEY` |
| Supabase Auth broken | You → Check Supabase logs |

---

**You've got this!** 🎯 The code is ready. Tonight = credentials. Tomorrow = build.

**Good luck!** 🚀