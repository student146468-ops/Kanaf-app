$ErrorActionPreference = 'Stop'

$projectRoot = Split-Path -Parent $PSScriptRoot
Set-Location $projectRoot

$localIp = (Get-NetIPAddress -AddressFamily IPv4 |
    Where-Object { $_.IPAddress -notlike '127.*' -and $_.IPAddress -notlike '169.254*' } |
    Select-Object -First 1 -ExpandProperty IPAddress)

if (-not $localIp) {
    throw 'Could not find a LAN IPv4 address for this laptop.'
}

$apiBaseUrl = "http://$localIp`:8000/api"
Write-Host "Building debug APK with API_BASE_URL=$apiBaseUrl"

flutter build apk --debug --dart-define=API_BASE_URL=$apiBaseUrl

$apkPath = Join-Path $projectRoot 'build/app/outputs/flutter-apk/app-debug.apk'
$readyApkDir = Join-Path $projectRoot 'READY_APK'
$readyApkPath = Join-Path $readyApkDir 'Kanaf.apk'
New-Item -ItemType Directory -Force -Path $readyApkDir | Out-Null
Copy-Item -Force -Path $apkPath -Destination $readyApkPath

Write-Host "APK ready: $apkPath"
Write-Host "READY_APK copy: $readyApkPath"
