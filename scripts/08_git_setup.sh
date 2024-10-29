#!/bin/bash

cd /opt/cursor/projects/networkai

# Create .gitignore
cat > .gitignore << 'EOF'
# Python
__pycache__/
*.py[cod]
*$py.class
*.so
.Python
build/
develop-eggs/
dist/
downloads/
eggs/
.eggs/
lib/
lib64/
parts/
sdist/
var/
wheels/
*.egg-info/
.installed.cfg
*.egg

# Django
*.log
local_settings.py
db.sqlite3
db.sqlite3-journal
media/

# Virtual Environment
venv/
ENV/

# Environment variables
.env

# IDE
.idea/
.vscode/
*.swp
*.swo

# OS
.DS_Store
Thumbs.db
EOF

# Initialize git repository
git init
git config --global --add safe.directory /opt/cursor/projects/networkai
git branch -M main

# Make initial commit
git add .
git commit -m "Initial commit: Project setup"

# Set up GitHub repository (if gh CLI is installed)
if command -v gh &> /dev/null; then
    if ! gh auth status &> /dev/null; then
        echo "Please authenticate with GitHub:"
        gh auth login
    fi
    
    # Create GitHub repository
    gh repo create tc45/networkai --public --source=. --remote=origin --push
else
    echo "GitHub CLI not installed. Please manually create and push to repository."
fi

# Fix permissions
sudo chown -R www-data:www-data / 