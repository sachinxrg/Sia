Remove-Item -Path "C:\Android\Sdk\ndk" -Recurse -Force -ErrorAction SilentlyContinue
Start-Sleep -Seconds 2
C:\src\flutter\bin\flutter.bat build apk --release --no-tree-shake-icons --android-skip-build-dependency-validation
$apk = "d:\TY-IT\Projects\Sia\build\app\outputs\flutter-apk\app-release.apk"
if (Test-Path $apk) {
    $bytes = [System.IO.File]::ReadAllBytes($apk)
    $half = [math]::Floor($bytes.Length / 2)
    [System.IO.File]::WriteAllBytes("C:\Users\srkas\Desktop\sia-release.part1", $bytes[0..($half-1)])
    [System.IO.File]::WriteAllBytes("C:\Users\srkas\Desktop\sia-release.part2", $bytes[$half..($bytes.Length-1)])
    Write-Host "SPLIT AND COPIED TO DESKTOP!"
} else {
    Write-Host "BUILD FAILED"
}
