#!/bin/bash

# Create Django project
cd /opt/cursor/projects/networkai
django-admin startproject network_ai src

# Create the apps
cd src
python manage.py startapp home
python manage.py startapp accounts
python manage.py startapp devices
python manage.py startapp chat
python manage.py startapp projects

# Create URLs for each app
for app in home accounts devices chat projects; do
    mkdir -p ${app}/templates/${app}
    cat > ${app}/urls.py << EOF
from django.urls import path
from . import views

app_name = '${app}'

urlpatterns = [
]
EOF
done

# Create main URLs file
cat > network_ai/urls.py << 'EOF'
from django.contrib import admin
from django.urls import path, include
from django.conf import settings
from django.conf.urls.static import static

urlpatterns = [
    path('admin/', admin.site.urls),
    path('', include('home.urls')),
    path('accounts/', include('allauth.urls')),
    path('devices/', include('devices.urls')),
    path('chat/', include('chat.urls')),
    path('projects/', include('projects.urls')),
] + static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
EOF

# Create home app views and URLs
cat > home/views.py << 'EOF'
from django.shortcuts import render

def index(request):
    return render(request, 'home/index.html')
EOF

cat > home/urls.py << 'EOF'
from django.urls import path
from . import views

app_name = 'home'

urlpatterns = [
    path('', views.index, name='index'),
]
EOF
