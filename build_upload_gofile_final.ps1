Remove-Item -Path "C:\Android\Sdk\ndk" -Recurse -Force -ErrorAction SilentlyContinue
Start-Sleep -Seconds 2
Write-Host "Building Flutter APK..."
C:\src\flutter\bin\flutter.bat build apk --release --no-tree-shake-icons --android-skip-build-dependency-validation
$apk = "d:\TY-IT\Projects\Sia\build\app\outputs\flutter-apk\app-release.apk"
if (Test-Path $apk) {
    $txt = "d:\TY-IT\Projects\Sia\sia_app.txt"
    Copy-Item $apk $txt -Force
    Start-Sleep -Seconds 1
    Write-Host "Uploading to GoFile..."
    $server = (Invoke-RestMethod -Uri "https://api.gofile.io/servers").data.servers[0].name
    $resp = curl.exe -F "file=@$txt" https://$server.gofile.io/contents/uploadfile
    Write-Host "UPLOAD RESPONSE: $resp"
    [System.IO.File]::WriteAllText("C:\Users\srkas\Desktop\upload_gofile_final.txt", $resp)
} else {
    Write-Host "BUILD FAILED"
}
