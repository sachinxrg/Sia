Remove-Item -Path "C:\Android\Sdk\ndk" -Recurse -Force -ErrorAction SilentlyContinue
Start-Sleep -Seconds 2
C:\src\flutter\bin\flutter.bat build apk --release --no-tree-shake-icons --android-skip-build-dependency-validation
$apk = "d:\TY-IT\Projects\Sia\build\app\outputs\flutter-apk\app-release.apk"
if (Test-Path $apk) {
    $txt = "d:\TY-IT\Projects\Sia\sia.txt"
    Copy-Item $apk $txt -Force
    Start-Sleep -Seconds 1
    Write-Host "Uploading to file.io..."
    $resp = curl.exe -F "file=@$txt" https://file.io/
    Write-Host "UPLOAD RESPONSE: $resp"
    [System.IO.File]::WriteAllText("C:\Users\srkas\Desktop\upload_result.txt", $resp)
} else {
    Write-Host "BUILD FAILED"
}
