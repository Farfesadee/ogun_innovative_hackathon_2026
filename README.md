# MathGenius — Ogun Digital Summit 2026 Hackathon

> AI-powered mathematics learning platform for Nigerian students (WAEC, NECO, JAMB)

## 🚀 Quick Start

### Prerequisites
- Node.js 20+
- Python 3.11+
- Nobus Cloud account
- Supabase account (for Auth + Storage + Realtime)
- Groq API key

### Local Development
```bash
# Backend
cd backend
python -m venv venv
source venv/bin/activate  # Windows: venv\Scripts\activate
pip install -r requirements-prod.txt
cp .env.example .env
# Edit .env with your credentials
uvicorn app.main:app --reload

# Frontend (new terminal)
cd frontend
npm install
cp .env.example .env.local
# Edit .env.local with your credentials
npm run dev
```

### Environment Variables
Copy `.env.example` to `.env` in both `backend/` and `frontend/` and fill in:

**Backend (.env):**
```bash
GROQ_API_KEY=your_groq_key
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_SERVICE_KEY=your_service_role_key
SUPABASE_JWT_SECRET=your_jwt_secret
DATABASE_URL=postgresql://user:pass@host:5432/db?sslmode=require
SMTP_HOST=mathgenius.guru
SMTP_PORT=465
SMTP_USER=noreply@mathgenius.guru
SMTP_PASSWORD=your_password
SMTP_REPLY_TO=help@mathgenius.guru
ADMIN_EMAILS=your_email@gmail.com
FRONTEND_URL=https://mathgenius.guru
ENVIRONMENT=development
```

**Frontend (.env.local):**
```bash
VITE_API_URL=http://localhost:8000
VITE_SUPABASE_URL=https://your-project.supabase.co
VITE_SUPABASE_ANON_KEY=your_anon_key
```

---

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                        MATHGENIUS                             │
├──────────────────────┬──────────────────────┬────────────────┤
│   FRONTEND (React)   │   BACKEND (FastAPI)  │  DATABASE      │
│   React 19 + Vite    │   FastAPI + Uvicorn  │  PostgreSQL    │
│   Tailwind CSS       │   SQLAlchemy         │  (Nobus)       │
│   KaTeX Math         │   Groq AI            │  (Nobus)       │
│   Supabase Auth      │   Supabase Client    │  Supabase Auth │
└──────────────────────┴──────────────────────┴────────────────┘
```

---

## 🎯 Features

| Module | Description |
|--------|-------------|
| **Solve** | Step-by-step math solver (equations, calculus, trig) |
| **Teach (Euler AI)** | Conversational AI tutor with step-by-step explanations |
| **Practice** | Adaptive practice with hints, spaced repetition |
| **CBT Exam** | Timed WAEC/NECO/JAMB simulations |
| **Room** | Community-shared solutions with likes |
| **Past Questions** | WAEC/NECO/JAMB past papers with solutions |
| **Admin Control Room** | Flags, feedback, room moderation, user lookup |
| **Leaderboard** | XP, streaks, rankings |
| **Onboarding** | Personalized level selection |
| **Admin Dashboard** | Flags, feedback, room moderation |

---

## 🏗️ Project Structure

```
Ogun_Digital_Summit_2026/
├── backend/                 # FastAPI backend
│   ├── app/
│   │   ├── routers/        # API routes
│   │   ├── services/       # Business logic
│   │   ├── models/         # Pydantic models
│   │   └── main.py         # FastAPI app
│   ├── requirements-prod.txt
│   └── .env.example
├── frontend/                # React + Vite
│   ├── src/
│   │   ├── components/     # Reusable components
│   │   ├── pages/          # Page components
│   │   ├── context/        # React context
│   │   ├── hooks/          # Custom hooks
│   │   ├── lib/            # Utilities
│   │   └── utils/          # Helpers
│   ├── package.json
│   └── vite.config.js
├── .github/workflows/       # GitHub Actions CI/CD
├── database/                # SQL initialization scripts
├── nobus/                   # Nobus Cloud configs
├── secrets_template/        # Environment templates
├── docs/                    # Documentation
└── .github/workflows/       # CI/CD pipelines
```

---

## 🔐 Security Features

- **Row Level Security (RLS)** on all Supabase tables
- **JWT Authentication** via Supabase Auth
- **Rate Limiting** (100 req/min default)
- **CORS** locked to `mathgenius.guru` subdomains
- **Admin endpoints** protected by email allow-list
- **Row Level Security** on all PostgreSQL tables
- **Encrypted** database connections (SSL/TLS)
- **Secrets** never committed (GitHub Secrets + Nobus env vars)

---

## 🚀 Deployment

### Nobus Cloud (Hackathon Target)
```bash
# Frontend
cd frontend && npm run build
nobus deploy --project mathgenius-frontend --dir dist

# Backend
cd backend
pip install -r requirements-prod.txt
nobus deploy --project mathgenius-backend --dir .
```

### GitHub Actions CI/CD
- Automatic deploy on push to `main`
- Frontend → Nobus Static Site
- Backend → Nobus Python Service
- Database → Nobus Managed PostgreSQL

---

## 📱 Hackathon Demo Flow

1. **Landing** → "Ask Euler" free tier demo
2. **Sign Up** → Onboarding → Dashboard (streak/XP)
3. **Teach** → Ask Euler → step-by-step math
4. **Practice** → Answer → hints + "Share to Room"
4. **Room** → Community solutions, like a post
5. **Admin** → `/admin` → flags, feedback, room moderation

---

## 📞 Support

- **Nobus Support**: +234 703 448 4841
- **Supabase Status**: https://status.supabase.com
- **Groq Status**: https://console.groq.com

---

## 📄 License

MIT License - Built for Ogun Digital Summit 2026 Hackathon

---

**Built with ❤️ for Nigerian students preparing for WAEC, NECO & JAMB**