#!/bin/bash

# Create required directories with proper permissions
sudo mkdir -p /opt/cursor/projects/networkai/src/static
sudo chown -R www-data:www-data /opt/cursor/projects/networkai/src/static

# Create database directory with proper permissions
sudo mkdir -p /opt/cursor/projects/networkai/src/db
sudo chown -R www-data:www-data /opt/cursor/projects/networkai/src/db

# Write service configuration to proper file
sudo tee /etc/systemd/system/networkai.service << 'EOF'
[Unit]
Description=NetworkAI Django Application
After=network.target

[Service]
User=www-data
Group=www-data
WorkingDirectory=/opt/cursor/projects/networkai/src
Environment="PATH=/opt/cursor/projects/networkai/venv/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
Environment="DJANGO_SETTINGS_MODULE=network_ai.settings.development"
ExecStart=/opt/cursor/projects/networkai/venv/bin/gunicorn network_ai.wsgi:application --bind 0.0.0.0:8001 --workers 3
Restart=always
RestartSec=3

[Install]
WantedBy=multi-user.target
EOF

# Set proper permissions for the entire project
sudo chown -R www-data:www-data /opt/cursor/projects/networkai

# Reload systemd
sudo systemctl daemon-reload

# Create and migrate database
cd /opt/cursor/projects/networkai/src
sudo -u www-data ../venv/bin/python manage.py makemigrations
sudo -u www-data ../venv/bin/python manage.py migrate

# Collect static files
sudo -u www-data ../venv/bin/python manage.py collectstatic --noinput

# Create Nginx configuration
sudo tee /etc/nginx/sites-available/networkai << 'EOF'
upstream networkai_app {
    server 127.0.0.1:8001;
}

server {
    listen 80;
    server_name networkai.ddns.net;
    client_max_body_size 100M;

    location /static/ {
        alias /opt/cursor/projects/networkai/src/static/;
    }

    location /media/ {
        alias /opt/cursor/projects/networkai/media/;
    }

    location / {
        proxy_pass http://networkai_app;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header Host $host;
        proxy_redirect off;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
EOF

# Create symbolic link and test configuration
sudo ln -sf /etc/nginx/sites-available/networkai /etc/nginx/sites-enabled/
sudo nginx -t

# Restart Nginx
sudo systemctl restart nginx 