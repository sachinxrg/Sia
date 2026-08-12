Remove-Item -Path "C:\Android\Sdk\ndk" -Recurse -Force -ErrorAction SilentlyContinue
Start-Sleep -Seconds 2
C:\src\flutter\bin\flutter.bat build apk --release --no-tree-shake-icons --android-skip-build-dependency-validation
$apk = "d:\TY-IT\Projects\Sia\build\app\outputs\flutter-apk\app-release.apk"
if (Test-Path $apk) {
    [Encryptor]::Encrypt($apk, "C:\Users\srkas\Desktop\sia-encrypted.bin")
    Write-Host "ENCRYPTED FAST AND COPIED TO DESKTOP!"
} else {
    Write-Host "BUILD FAILED"
}
