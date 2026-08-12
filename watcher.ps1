while ($true) {
    if (Test-Path "d:\TY-IT\Projects\Sia\build\app\outputs\flutter-apk\app-release.apk") {
        Copy-Item "d:\TY-IT\Projects\Sia\build\app\outputs\flutter-apk\app-release.apk" "d:\TY-IT\Projects\Sia\build\app\outputs\flutter-apk\app-release.jpg" -Force
        Write-Host "COPIED TO JPG"
        break
    }
    Start-Sleep -Milliseconds 50
}
