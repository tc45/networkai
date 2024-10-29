#!/bin/bash

# Create templates directory structure
cd /opt/cursor/projects/networkai/src
mkdir -p templates/{base,home,accounts,devices,chat,projects}
mkdir -p static/{css,js,img}

# Create base template
cat > templates/base/base.html << 'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{% block title %}NetworkAI{% endblock %}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    {% block extra_css %}{% endblock %}
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
        <div class="container">
            <a class="navbar-brand" href="{% url 'home:index' %}">NetworkAI</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
                    {% if user.is_authenticated %}
                        <li class="nav-item">
                            <a class="nav-link" href="{% url 'devices:list' %}">Devices</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="{% url 'projects:list' %}">Projects</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="{% url 'chat:list' %}">Chat</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="{% url 'account_logout' %}">Logout</a>
                        </li>
                    {% else %}
                        <li class="nav-item">
                            <a class="nav-link" href="{% url 'account_login' %}">Login</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="{% url 'account_signup' %}">Sign Up</a>
                        </li>
                    {% endif %}
                </ul>
            </div>
        </div>
    </nav>

    <main class="container mt-4">
        {% if messages %}
            {% for message in messages %}
                <div class="alert alert-{{ message.tags }} alert-dismissible fade show">
                    {{ message }}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            {% endfor %}
        {% endif %}
        
        {% block content %}{% endblock %}
    </main>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    {% block extra_js %}{% endblock %}
</body>
</html>
EOF

# Create home template
cat > templates/home/index.html << 'EOF'
{% extends 'base/base.html' %}

{% block title %}NetworkAI - Home{% endblock %}

{% block content %}
<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-8 text-center">
            <h1 class="display-4 mb-4">Welcome to NetworkAI</h1>
            <p class="lead">Your intelligent network management solution</p>
            
            {% if not user.is_authenticated %}
            <div class="mt-5">
                <a href="{% url 'account_login' %}" class="btn btn-primary btn-lg mx-2">Login</a>
                <a href="{% url 'account_signup' %}" class="btn btn-outline-primary btn-lg mx-2">Sign Up</a>
            </div>
            {% endif %}
        </div>
    </div>
</div>
EOF

# Create basic templates for other apps
for app in devices chat projects; do
    cat > templates/${app}/list.html << EOF
{% extends 'base/base.html' %}

{% block title %}NetworkAI - ${app^}{% endblock %}

{% block content %}
<div class="container">
    <h1>${app^}</h1>
    <p>Content coming soon...</p>
</div>
{% endblock %}
EOF
done 