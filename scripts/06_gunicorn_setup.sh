#!/bin/bash

# Create Gunicorn systemd service file
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

# Reload systemd and start service
sudo systemctl daemon-reload
sudo systemctl enable networkai
sudo systemctl start networkai 