$msi  = "E:\CloudbaseInitSetup_x64.msi"
$conf = "E:\cloudbase-init.conf"

if (-not (Test-Path $msi)) {
    Write-Error "Could not find $msi"
    exit 1
}
if (-not (Test-Path $conf)) {
    Write-Error "Could not find $conf"
    exit 1
}

Write-Host "Installing Cloudbase-Init..."
$result = Start-Process msiexec -Wait -PassThru -ArgumentList "/i `"$msi`" /qn /norestart /l*v C:\cloudbase-install.log"
if ($result.ExitCode -ne 0) {
    Write-Error "Cloudbase-Init install failed with exit code $($result.ExitCode)"
    Get-Content C:\cloudbase-install.log | Select-Object -Last 50
    exit $result.ExitCode
}
Write-Host "Cloudbase-Init installed"

# Deploy our configuration
$confDest = "C:\Program Files\Cloudbase Solutions\Cloudbase-Init\conf\cloudbase-init.conf"
Copy-Item $conf $confDest -Force
Write-Host "Deployed cloudbase-init.conf to $confDest"

# Ensure the service starts automatically (installer may have already set this)
Set-Service cloudbase-init -StartupType Automatic
Write-Host "Cloudbase-Init service set to Automatic start"
