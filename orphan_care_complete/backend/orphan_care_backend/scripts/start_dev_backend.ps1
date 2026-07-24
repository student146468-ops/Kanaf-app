$ErrorActionPreference = 'Stop'

$projectRoot = Split-Path -Parent $PSScriptRoot
Set-Location $projectRoot

$env:DEBUG = 'debug'
$env:SECRET_KEY = 'django-insecure-kanaf-local-development-key-change-before-production'
$localIp = (Get-NetIPAddress -AddressFamily IPv4 |
    Where-Object { $_.IPAddress -notlike '127.*' -and $_.IPAddress -notlike '169.254*' } |
    Select-Object -First 1 -ExpandProperty IPAddress)

$env:ALLOWED_HOSTS = "localhost,127.0.0.1,0.0.0.0,$localIp"
$env:CSRF_TRUSTED_ORIGINS = "http://localhost:8000,http://127.0.0.1:8000,http://$localIp`:8000"
$env:CORS_ALLOWED_ORIGIN_REGEXES = '^http://localhost:\d+$,^http://127\.0\.0\.1:\d+$'

Write-Host "Kanaf backend local URL: http://127.0.0.1:8000"
Write-Host "Kanaf backend phone URL: http://$localIp`:8000"

python manage.py migrate --noinput
python manage.py runserver 0.0.0.0:8000 --noreload
