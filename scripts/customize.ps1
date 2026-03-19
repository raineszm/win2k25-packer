# Set the port and speed
bcdedit /emssettings EMSPORT:1 EMSBAUDRATE:115200

# Turn it on for the current OS entry
bcdedit /ems {current} ON

Write-Host "Emergency Management Services (EMS) enabled on COM1"

# Allow Ping
netsh advfirewall firewall add rule name="ICMP Allow incoming V4 echo request" protocol=icmpv4:8,any dir=in action=allow
Write-Host "ICMP echo requests allowed through the firewall"

# Disable SConfig on boot
Set-SConfig -AutoLaunch $false
Write-Host "SConfig auto-launch disabled on boot"
