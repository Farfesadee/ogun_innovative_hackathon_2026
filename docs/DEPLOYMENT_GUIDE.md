# MathGenius - Ogun Digital Summit 2026 Deployment Guide

## 🎯 Quick Start (5 minutes)

### 1. Create New GitHub Repo (Hackathon Rule: Fresh Repo)
```bash
gh repo create mathgenius-hackathon --public --source=. --push
```

### 2. Add GitHub Secrets (Repo → Settings → Secrets → Actions)
| Secret | Value |
|--------|-------|
| `NOBUS_API_TOKEN` | From Nobus dashboard |
| `NOBUS_PROJECT_ID` | From Nobus project settings |
| `GROQ_API_KEY` | `your_groq_api_key_here` |
| `SUPABASE_URL` | `https://YOUR_PROJECT.supabase.co` |
| `SUPABASE_SERVICE_KEY` | Supabase service role key |
| `SUPABASE_JWT_SECRET` | Supabase JWT secret |
| `DATABASE_URL` | `postgresql://mathgenius_admin:PASSWORD@host:5432/mathgenius?sslmode=require` |
| `SMTP_PASSWORD` | `your_smtp_password_here` |
| `SMTP_PASSWORD` | `your_smtp_password_here` |
| `SUPABASE_SERVICE_KEY` | Supabase service role key |
| `SUPABASE_JWT_SECRET` | Supabase JWT secret |
| `ADMIN_EMAILS` | `your_gmail@gmail.com,teammate@gmail.com` |
| `SMTP_PASSWORD` | `your_smtp_password_here` |
| `SUPABASE_SERVICE_KEY` | From Supabase dashboard |

### 3. Deploy to Nobus (Your Teammate Handles This)

#### On Nobus Dashboard:
1. **Create Project**: `mathgenius-hackathon`
2. **Create PostgreSQL 16 Instance**:
   - Flavor: `standard` (2 vCPU, 4GB RAM)
   - Size: 20 GB
   - Zone: `nobus-wa-az1` (Nigeria)
   - Username: `mathgenius_admin`
   - **Password: AUTO-GENERATED - COPY IMMEDIATELY!**
   - Zone: `nobus-wa-az1` (Nigeria)
3. **Create Object Storage Bucket**: `mathgenius-uploads` (private)
4. **Get Credentials**:
   - API Token → GitHub Secret `NOBUS_API_TOKEN`
   - Project ID → `NOBUS_PROJECT_ID`

### 4. Deploy Commands (Run on Nobus)
```bash
# Frontend
cd frontend && npm ci && npm run build
nobus deploy --project mathgenius-frontend --dir dist

# Backend
cd backend
pip install -r requirements-prod.txt
nobus deploy --project mathgenius-backend --dir .
```

### 4. Verify Deployment
```bash
# Health checks
curl https://api.mathgenius.guru/health
curl https://mathgenius.guru/
# Admin panel (login with ADMIN_EMAILS email)
open https://mathgenius.guru/admin
```

---

## 📋 Pre-Hackathon Checklist (Tonight)

- [ ] Create `.env.production` from template (copy secrets_template/.env.production.template)
- [ ] Fill in ALL values - no placeholders left
- [ ] Test locally: `cd frontend && npm run build` and `cd backend && uvicorn app.main:app --reload`
- [ ] Create NEW GitHub repo: `gh repo create mathgenius-hackathon --public --source=. --push`
- [ ] Add ALL GitHub Secrets (see checklist above)
- [ ] Run Supabase SQL (tables below)
- [ ] Send teammate: repo link + this guide + password manager with secrets

---

## 🗄️ Supabase SQL (Run Tonight in Supabase SQL Editor)

```sql
-- Flags (user-reported questions)
create table if not exists public.question_flags (
  id uuid default gen_random_uuid() primary key,
  user_id uuid not null, user_email text, username text,
  question_text text not null, topic text, exam_type text,
  source text, level text, reason text, note text,
  status text default 'open',
  created_at timestamptz default now()
);
alter table public.question_flags enable row level security;
create policy "Own rows" on public.question_flags for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

-- Room solutions (community answers)
create table if not exists public.room_solutions (
  id uuid default gen_random_uuid() primary key,
  user_id uuid not null, username text,
  question_text text not null, solution_text text not null,
  topic text default '', exam_type text default '', source text default '',
  likes_count int default 0, status text default 'open',
  created_at timestamptz default now()
);
create table if not exists public.room_likes (
  user_id uuid not null, solution_id uuid not null references public.room_solutions(id) on delete cascade,
  created_at timestamptz default now(),
  primary key (user_id, solution_id)
);
alter table public.room_solutions enable row level security;
alter table public.room_likes enable row level security;

-- Bookmarks
create table if not exists public.bookmarks (
  id uuid default gen_random_uuid() primary key,
  user_id uuid not null, type text, title text, content text,
  expression text, result text, topic text,
  created_at timestamptz default now()
);
alter table public.bookmarks enable row level security;
create policy "Own rows" on public.bookmarks for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

-- Newsletter
create table if not exists public.newsletter_subscribers (
  id uuid default gen_random_uuid() primary key,
  email text unique not null, created_at timestamptz default now()
);
alter table public.newsletter_subscribers enable row level security;
create policy "Anyone can subscribe" on public.newsletter_subscribers for insert with check (true);

-- Onboarding flag
alter table public.profiles add column if not exists onboarded boolean default false;

-- Teach feedback & sessions
create table if not exists public.teach_feedback (
  id uuid default gen_random_uuid() primary key,
  message_id text, user_id uuid, topic text, level text,
  question text, response_preview text, rating text, comment text,
  created_at timestamptz default now()
);
create table if not exists public.teach_sessions (
  id uuid default gen_random_uuid() primary key,
  user_id uuid, topic text, question text, response_length int,
  level text, created_at timestamptz default now()
);
```

---

## 🔐 Security Checklist (Do Not Skip)

- [ ] **No secrets in repo** - all in GitHub Secrets
- [ ] **Supabase RLS enabled** on all tables with `auth.uid()` policies
- [ ] **CORS locked** - `allow_origin_regex: https://([a-z0-9-]+\.)*mathgenius\.guru`
- [ ] **Admin endpoints locked** - `ADMIN_EMAILS` enforced server-side
- [ ] **Rate limits** - 100 req/min on API (already in code)
- [ ] **HTTPS only** - Nobus handles TLS

---

## 📞 Emergency Contacts

| Issue | Who | Contact |
|-------|-----|---------|
| Nobus deploy fails | Teammate | Nobus support: +234 703 448 4841 |
| Database connection fails | You | Check `DATABASE_URL` format |
| Groq API fails | You | Check `GROQ_API_KEY` in env |
| Supabase Auth broken | You | Check Supabase dashboard logs |

---

## 🎯 Tomorrow's Timeline

| Time | Action |
|------|--------|
| **09:00** | Create repo, push, enable GitHub Actions |
| **09:15** | Deploy to Nobus, verify health endpoints |
| **09:30** | Verify Admin room, welcome email, Room posts |
| **10:00** | Feature work begins - commit every 30 min |
| **12:00** | Deploy, demo to teammate |
| **15:00** | Deploy, polish UI, fix bugs |
| **17:00** | Final deploy, freeze features, demo prep |

---

## 🎯 Demo Script (Practice Tonight)

1. **Landing** → "Ask Euler" free tier demo
2. **Sign up** → Onboarding → Dashboard (streak/XP)
3. **Teach** → Ask Euler → step-by-step math
4. **Practice** → Answer → hints + "Share to Room"
5. **Room** → Community solutions, like a post
6. **Admin** → `/admin` → flags, feedback, room moderation
6. **Profile** → Bookmarks, referrals, role switch

---

## 📁 Folder Structure (This Repo)

```
Ogun_Digital_Summit_2026/
├── backend/           # FastAPI backend
│   ├── app/           # FastAPI app
│   ├── requirements-prod.txt
│   ├── .env.example
│   └── start.sh
├── frontend/          # React + Vite
│   ├── src/
│   ├── package.json
│   └── vite.config.js
├── .github/workflows/ # GitHub Actions CI/CD
├── nobus/             # Nobus configs
├── secrets_template/  # .env.production.template
├── docs/              # Documentation
├── .github/workflows/ # CI/CD
├── .gitignore
├── docker-compose.yml
├── Dockerfile
├── render.yaml
└── README.md
```

---

## 🚨 Emergency Contacts

| Issue | Who | Contact |
|-------|-----|---------|
| Nobus deploy fails | Teammate | Nobus support: +234 703 448 4841 |
| Database connection fails | You | Check `DATABASE_URL` format |
| Groq API fails | You | Check `GROQ_API_KEY` in env |
| Supabase Auth broken | You | Check Supabase dashboard logs |

---

## 🎯 Final Words

**You've built a solid product.** Tonight is about making deployment boring so tomorrow you build features.

**Sleep well. You've got this.** 🚀