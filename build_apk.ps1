$ScriptDir = $PSScriptRoot
if (-not $ScriptDir) { $ScriptDir = "d:\TY-IT\Projects\Sia" }

Write-Host "Checking NDK environment..." -ForegroundColor Cyan
if (Test-Path "C:\Android\Sdk\ndk\28.2.13676358") {
    if (-not (Test-Path "C:\Android\Sdk\ndk\28.2.13676358\source.properties")) {
        Write-Host "Cleaning corrupted NDK cache..." -ForegroundColor Yellow
        Get-Process -Name java, gradle -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
        Remove-Item -Path "C:\Android\Sdk\ndk" -Recurse -Force -ErrorAction SilentlyContinue
    }
}

Write-Host "Building Release APK..." -ForegroundColor Green
C:\src\flutter\bin\flutter.bat build apk --release --no-tree-shake-icons

$BuildApkPath = Join-Path $ScriptDir "build\app\outputs\flutter-apk\app-release.apk"
$FinalApkPath = Join-Path $ScriptDir "sia-release.apk"

if (Test-Path $BuildApkPath) {
    Copy-Item $BuildApkPath $FinalApkPath -Force
    Write-Host "SUCCESS: APK created at $FinalApkPath" -ForegroundColor Green
    Get-Item $FinalApkPath | Select-Object FullName, Length, LastWriteTime
    explorer.exe /select,"$FinalApkPath"
} else {
    Write-Host "ERROR: Build failed or APK was not found." -ForegroundColor Red
}
