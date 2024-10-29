#!/bin/bash


# Set ownership for the project directory
sudo chown -R $USER:$USER /opt/cursor/projects/networkai

# Set up virtual environment
python3.12 -m venv venv
source venv/bin/activate

# Create and install requirements
cat > requirements.txt << 'EOF'
Django==5.0.2
python-dotenv==1.0.0
python-decouple==3.8
gunicorn==21.2.0
psycopg2-binary==2.9.9
django-allauth==0.61.0
django-encrypted-model-fields==0.6.5
ansible==9.1.0
ansible-runner==2.3.4
openai==1.12.0
netmiko==4.3.0
pytest==8.0.0
pytest-django==4.7.0
black==24.1.1
flake8==7.0.0
coverage==7.4.1
django-crispy-forms==2.1
crispy-bootstrap5==2023.10
EOF

pip install -r requirements.txt 