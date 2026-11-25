# Nobus Cloud Deployment for MathGenius

## Quick Start

### Prerequisites
- Nobus Cloud account with API token
- Project created on Nobus dashboard
- PostgreSQL instance created (see below)

### Required Environment Variables

Create a `.env` file with these variables:

```bash
# Nobus
NOBUS_API_TOKEN=your_nobus_api_token
NOBUS_PROJECT_ID=your_project_id

# Database (from Nobus PostgreSQL instance creation)
DATABASE_URL=postgresql://mathgenius_admin:PASSWORD@host:5432/mathgenius?sslmode=require

# AI
GROQ_API_KEY=your_groq_api_key_here

# Supabase (for Auth + Storage + Realtime)
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_SERVICE_KEY=your_service_role_key
SUPABASE_JWT_SECRET=your_jwt_secret

# Email
SMTP_HOST=mathgenius.guru
SMTP_PORT=465
SMTP_USER=noreply@mathgenius.guru
SMTP_PASSWORD=your_password
SMTP_REPLY_TO=help@mathgenius.guru

# Admin
ADMIN_EMAILS=your_email@gmail.com,teammate@gmail.com
ADMIN_EMAIL=help@mathgenius.guru
SMTP_REPLY_TO=help@mathgenius.guru
FRONTEND_URL=https://mathgenius.guru
ENVIRONMENT=production
```

### Deployment Commands

```bash
# Make executable
chmod +x deploy.sh

# Run deployment
./deploy.sh
```

Or manually:

```bash
# Frontend
cd frontend
npm ci && npm run build
nobus deploy --project mathgenius-frontend --dir dist

# Backend
cd ../backend
pip install -r requirements-prod.txt
nobus deploy --project mathgenius-backend --dir .
```

## Nobus Dashboard Setup

### 1. Create PostgreSQL Instance
- Go to Nobus Dashboard → Database Services
- Create PostgreSQL 16 instance
- Flavor: `standard` (2 vCPU, 4GB RAM)
- Size: 20 GB
- Zone: `nobus-wa-az1` (Nigeria)
- Username: `mathgenius_admin`
- Password: **Auto-generated - COPY IMMEDIATELY!**
- Encryption: Enabled

### 2. Create Object Storage Bucket
- Name: `mathgenius-uploads`
- Public: No
- Versioning: Enabled

### 3. Get Credentials
- API Token: Settings → API Tokens → Create
- Project ID: From project URL or settings
- Database credentials: Shown once at creation - **SAVE IMMEDIATELY!**

### Database Connection String Format
```
postgresql://mathgenius_admin:PASSWORD@cluster-id.nobus-db.io:5432/mathgenius?sslmode=require
```

## GitHub Actions Secrets

Add these secrets to your GitHub repository (Settings → Secrets → Actions):

| Secret | Value |
|--------|-------|
| `NOBUS_API_TOKEN` | Your Nobus API token |
| `NOBUS_PROJECT_ID` | Your Nobus project ID |
| `GROQ_API_KEY` | `your_groq_api_key_here` |
| `SUPABASE_URL` | `https://your-project.supabase.co` |
| `SUPABASE_SERVICE_KEY` | Your Supabase service role key |
| `SUPABASE_JWT_SECRET` | Your Supabase JWT secret |
| `DATABASE_URL` | Your PostgreSQL connection string |
| `SMTP_PASSWORD` | Your noreply mailbox password |
| `ADMIN_EMAILS` | `your@gmail.com,teammate@gmail.com` |
| `ADMIN_EMAIL` | `help@mathgenius.guru` |
| `SMTP_REPLY_TO` | `help@mathgenius.guru` |
| `FRONTEND_URL` | `https://mathgenius.guru` |
| `SUPABASE_SERVICE_KEY` | Your Supabase service role key |
| `SUPABASE_JWT_SECRET` | Your Supabase JWT secret |
| `SUPABASE_URL` | Your Supabase URL |

## Verification

After deployment, verify:

```bash
# Health checks
curl https://api.mathgenius.guru/health
curl https://mathgenius.guru/

# Admin panel (login with ADMIN_EMAILS email)
open https://mathgenius.guru/admin
```

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Deploy fails | Check Nobus logs in dashboard |
| DB connection fails | Verify DATABASE_URL format and SSL mode |
| Groq API fails | Check GROQ_API_KEY in env vars |
| SMTP fails | Verify SMTP_PASSWORD matches mailbox password |
| CORS errors | Check ALLOWED_ORIGINS in backend config |

## Support

- Nobus Support: +234 703 448 4841
- Nobus Docs: https://nobus.io/documentation
- Render Dashboard (if using Render for any service): https://dashboard.render.com