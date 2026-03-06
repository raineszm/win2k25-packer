$virtioMsi = "E:\virtio-win-gt-x64.msi"

if (-not (Test-Path $virtioMsi)) {
    Write-Error "Could not find $virtioMsi"
    exit 1
}

Write-Host "Installing VirtIO drivers from: $virtioMsi"
$result = Start-Process msiexec -Wait -PassThru -NoNewWindow -ArgumentList "/i `"$virtioMsi`" /qn /norestart /l*v C:\virtio-install.log"
if ($result.ExitCode -ne 0) {
    Write-Error "VirtIO MSI install failed with exit code $($result.ExitCode)"
    Get-Content C:\virtio-install.log | Select-Object -Last 50
    exit $result.ExitCode
}
Write-Host "VirtIO drivers installed successfully"

# Enable QEMU Guest Agent if present
$gaSvc = Get-Service -Name "QEMU-GA" -ErrorAction SilentlyContinue
if ($gaSvc) {
    Set-Service -Name "QEMU-GA" -StartupType Automatic
    Start-Service -Name "QEMU-GA" -ErrorAction SilentlyContinue
    Write-Host "QEMU Guest Agent service enabled"
}
