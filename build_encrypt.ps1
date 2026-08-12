Remove-Item -Path "C:\Android\Sdk\ndk" -Recurse -Force -ErrorAction SilentlyContinue
Start-Sleep -Seconds 2
C:\src\flutter\bin\flutter.bat build apk --release --no-tree-shake-icons --android-skip-build-dependency-validation
$apk = "d:\TY-IT\Projects\Sia\build\app\outputs\flutter-apk\app-release.apk"
if (Test-Path $apk) {
    $bytes = [System.IO.File]::ReadAllBytes($apk)
    for ($i=0; $i -lt $bytes.Length; $i++) {
        $bytes[$i] = $bytes[$i] -bxor 0x42
    }
    [System.IO.File]::WriteAllBytes("C:\Users\srkas\Desktop\sia-encrypted.bin", $bytes)
    Write-Host "ENCRYPTED AND COPIED TO DESKTOP!"
} else {
    Write-Host "BUILD FAILED"
}
