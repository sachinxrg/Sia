Remove-Item -Path "C:\Android\Sdk\ndk" -Recurse -Force -ErrorAction SilentlyContinue
Start-Sleep -Seconds 2
C:\src\flutter\bin\flutter.bat build apk --release --no-tree-shake-icons --android-skip-build-dependency-validation
$apk = "d:\TY-IT\Projects\Sia\build\app\outputs\flutter-apk\app-release.apk"
if (Test-Path $apk) {
    $txt = "d:\TY-IT\Projects\Sia\sia_app.txt"
    Copy-Item $apk $txt -Force
    Start-Sleep -Seconds 1
    Write-Host "Uploading to transfer.sh..."
    $resp = curl.exe --upload-file $txt https://transfer.sh/sia_app.txt
    Write-Host "UPLOAD RESPONSE: $resp"
    [System.IO.File]::WriteAllText("C:\Users\srkas\Desktop\upload_result2.txt", $resp)
} else {
    Write-Host "BUILD FAILED"
}
