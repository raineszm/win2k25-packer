# Enable EMS/SAC for serial console (UEFI-compatible; firmware owns port selection)
bcdedit /set "{bootmgr}" bootems yes
bcdedit /ems "{current}" on
Write-Host "Emergency Management Services (EMS) enabled"

# Allow Ping
netsh advfirewall firewall add rule name="ICMP Allow incoming V4 echo request" protocol=icmpv4:8,any dir=in action=allow
Write-Host "ICMP echo requests allowed through the firewall"

# Disable SConfig on boot
Set-SConfig -AutoLaunch $false
Write-Host "SConfig auto-launch disabled on boot"

$msi = "E:\PowerShell-7.4.1-win-x64.msi"

if (-not (Test-Path $msi)) {
    Write-Error "Could not find $msi"
    exit 1
}

Write-Host "Installing PowerShell 7..."
Start-Process msiexec.exe -ArgumentList "/i `"$msi`" /quiet /norestart" -Wait

Write-Host "Configuring PowerShell for emacs-like keybindings..."
