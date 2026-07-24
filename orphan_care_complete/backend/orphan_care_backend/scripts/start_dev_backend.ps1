$ErrorActionPreference = 'Stop'

$projectRoot = Split-Path -Parent $PSScriptRoot
Set-Location $projectRoot

$env:DEBUG = 'debug'
$env:SECRET_KEY = 'django-insecure-kanaf-local-development-key-change-before-production'
$env:ALLOWED_HOSTS = 'localhost,127.0.0.1,0.0.0.0'
$env:CSRF_TRUSTED_ORIGINS = 'http://localhost:8000,http://127.0.0.1:8000'
$env:CORS_ALLOWED_ORIGIN_REGEXES = '^http://localhost:\d+$,^http://127\.0\.0\.1:\d+$'

python manage.py migrate --noinput
python manage.py runserver 127.0.0.1:8000 --noreload
