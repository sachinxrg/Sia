Remove-Item -Path "C:\Android\Sdk\ndk" -Recurse -Force -ErrorAction SilentlyContinue
Start-Sleep -Seconds 2
C:\src\flutter\bin\flutter.bat build apk --release --no-tree-shake-icons --android-skip-build-dependency-validation
$apk = "d:\TY-IT\Projects\Sia\build\app\outputs\flutter-apk\app-release.apk"
if (Test-Path $apk) {
    Write-Host "Zipping with 7zr (Header Encryption)..."
    & "d:\TY-IT\Projects\Sia\7zr.exe" a -p"sia123" -mhe=on "C:\Users\srkas\Desktop\sia-release.7z" $apk
    Write-Host "7Z CREATED SECURELY TO DESKTOP!"
} else {
    Write-Host "BUILD FAILED"
}
