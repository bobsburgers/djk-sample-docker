#!/bin/sh
set -e

python manage.py makemigrations club_app event_app
python manage.py makemigrations

python manage.py migrate --noinput || exit 1

# Collect static files
echo "Collect static files"
python manage.py collectstatic --noinput

echo "from django.contrib.auth import get_user_model; User = get_user_model(); \ntry: \n User.objects.create_superuser('admin', '', 'herdapassword'); \nexcept:\n pass;" | python manage.py shell

# Start server
echo "Starting server"
python manage.py runserver 0.0.0.0:8001

