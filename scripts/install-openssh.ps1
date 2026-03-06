# Install OpenSSH Server capability
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0

# Configure and start sshd
Set-Service sshd -StartupType Automatic
Start-Service sshd

# Add firewall rule for SSH
New-NetFirewallRule -Name "OpenSSH-Server-In" -DisplayName "OpenSSH Server (sshd)" `
    -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22

# Set PowerShell as the default SSH shell
$regPath = "HKLM:\SOFTWARE\OpenSSH"
if (-not (Test-Path $regPath)) {
    New-Item -Path $regPath -Force | Out-Null
}
Set-ItemProperty -Path $regPath -Name DefaultShell -Value "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe"

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
