winrm quickconfig -q
winrm set winrm/config/winrs '@{MaxMemoryPerShellMB="512"}'
winrm set winrm/config '@{MaxTimeoutms="1800000"}'
winrm set winrm/config/service '@{AllowUnencrypted="true"}'
winrm set winrm/config/service/auth '@{Basic="true"}'
Set-Service WinRM -StartupType Automatic
netsh advfirewall firewall add rule name="WinRM HTTP" protocol=TCP dir=in localport=5985 action=allow
