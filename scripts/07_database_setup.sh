#!/bin/bash

cd /opt/cursor/projects/networkai/src

# Set the Django settings module
export DJANGO_SETTINGS_MODULE=network_ai.settings.development

# Run migrations
python manage.py makemigrations
python manage.py migrate

# Create superuser
cat > create_superuser.py << 'EOF'
import os
import django

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'network_ai.settings.development')
django.setup()

from django.contrib.auth import get_user_model
User = get_user_model()

if not User.objects.filter(username='admin').exists():
    User.objects.create_superuser('admin', 'admin@networkai.local', 'admin')
    print('Superuser created successfully')
else:
    print('Superuser already exists')
EOF

python create_superuser.py
rm create_superuser.py

# Collect static files
python manage.py collectstatic --noinput 