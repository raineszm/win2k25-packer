# Install OpenSSH Server capability
# If not already present (Included by defualt on Windows Server 2025 and later)
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0

# Configure sshd to autostart and then enable
Set-Service sshd -StartupType Automatic
Start-Service sshd

New-NetFirewallRule -Name "OpenSSH-Server-In" -DisplayName "OpenSSH Server (sshd)" `
    -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22

Write-Host "Setting powershell 7 as default shell for SSH"
$pwshPath = (Get-Command pwsh.exe -ErrorAction SilentlyContinue).Source

# Fallback to the default install location if Get-Command fails
if (-not $pwshPath) {
    $pwshPath = "C:\Program Files\PowerShell\7\pwsh.exe"
}

$regPath = "HKLM:\SOFTWARE\OpenSSH"
if (-not (Test-Path $regPath)) {
    New-Item -Path $regPath -Force | Out-Null
}

Set-ItemProperty -Path $regPath -Name "DefaultShell" -Value $pwshPath

# Patch sshd_config: remove the 'Match Group administrators' block so that
# per-user authorized_keys is used for all accounts including Administrator.
# Cloudbase-Init's SetUserSSHPublicKeysPlugin writes to %USERPROFILE%\.ssh\authorized_keys.
$sshdConfig = "C:\ProgramData\ssh\sshd_config"
if (Test-Path $sshdConfig) {
    $content = Get-Content $sshdConfig -Raw

    # Remove the Match Group administrators block (and the AuthorizedKeysFile line inside it)
    $content = $content -replace '(?ms)Match Group administrators\s*\r?\n\s*AuthorizedKeysFile\s+__PROGRAMDATA__/ssh/administrators_authorized_keys\s*\r?\n?', ''

    Set-Content -Path $sshdConfig -Value $content -Encoding UTF8
    Write-Host "Patched sshd_config: removed Match Group administrators block"
} else {
    Write-Warning "sshd_config not found at $sshdConfig - skipping patch"
}

Restart-Service sshd
Write-Host "OpenSSH Server installed and configured"
