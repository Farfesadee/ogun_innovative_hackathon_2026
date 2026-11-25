#!/bin/bash
# Nobus Cloud Deployment Script for MathGenius
# Run this script after setting up environment variables

set -e

echo "🚀 MathGenius Nobus Cloud Deployment"
echo "===================================="

# Check required environment variables
required_vars=(
    "NOBUS_API_TOKEN"
    "NOBUS_PROJECT_ID"
    "DATABASE_URL"
    "GROQ_API_KEY"
    "SUPABASE_URL"
    "SUPABASE_SERVICE_KEY"
    "SUPABASE_JWT_SECRET"
    "SMTP_PASSWORD"
    "ADMIN_EMAILS"
)

echo "🔍 Checking required environment variables..."
for var in "${required_vars[@]}"; do
    if [ -z "${!var}" ]; then
        echo "❌ Missing required environment variable: $var"
        exit 1
    fi
done
echo "✅ All required environment variables set"

# Deploy Frontend
echo ""
echo "📦 Building and deploying frontend..."
cd frontend
npm ci
npm run build
echo "📤 Deploying frontend to Nobus..."
nobus deploy --project mathgenius-frontend --dir dist
echo "✅ Frontend deployed"

# Deploy Backend
echo ""
echo "🐍 Deploying backend..."
cd ../backend
pip install -r requirements-prod.txt
echo "📤 Deploying backend to Nobus..."
nobus deploy --project mathgenius-backend --dir .
echo "✅ Backend deployed"

echo ""
echo "🎉 Deployment complete!"
echo ""
echo "🔍 Verification:"
echo "  Frontend: https://mathgenius.guru"
echo "  Backend:  https://api.mathgenius.guru/health"
echo "  Admin:    https://mathgenius.guru/admin"