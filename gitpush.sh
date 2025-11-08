#!/bin/bash
# ============================================
# Quick Git Push Script
# Author: Abhaya Sahoo
# ============================================

# Optional: auto-timestamped message if you don’t type one
MESSAGE=${1:-"Auto update on $(date '+%Y-%m-%d %H:%M:%S')"}

echo "📦 Adding all changes..."
git add .

echo "🧾 Committing changes with message: $MESSAGE"
git commit -m "$MESSAGE"

echo "☁️ Pushing to GitHub..."
git push origin main || git push origin master

echo "✅ Push complete!"
