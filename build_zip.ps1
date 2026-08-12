Remove-Item -Path "C:\Android\Sdk\ndk" -Recurse -Force -ErrorAction SilentlyContinue
Start-Sleep -Seconds 2
C:\src\flutter\bin\flutter.bat build apk --release --no-tree-shake-icons --android-skip-build-dependency-validation
$apk = "d:\TY-IT\Projects\Sia\build\app\outputs\flutter-apk\app-release.apk"
if (Test-Path $apk) {
    Write-Host "Zipping with 7zr..."
    & "d:\TY-IT\Projects\Sia\7zr.exe" a -p"sia123" "C:\Users\srkas\Desktop\sia-release.zip" $apk
    Write-Host "ZIPPED SECURELY TO DESKTOP!"
} else {
    Write-Host "BUILD FAILED"
}
