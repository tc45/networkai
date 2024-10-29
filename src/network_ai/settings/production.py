from .base import *

DEBUG = False
ALLOWED_HOSTS = ['networkai.ddns.net']

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.sqlite3',
        'NAME': BASE_DIR / 'src' / 'db.sqlite3',
    }
}

SECURE_SSL_REDIRECT = True
SESSION_COOKIE_SECURE = True
CSRF_COOKIE_SECURE = True
