# Generalize the image with sysprep.
# The VM shuts down after sysprep completes; Packer detects the shutdown.
Write-Host "Starting sysprep - VM will shut down on completion"
& "$env:SystemRoot\System32\Sysprep\sysprep.exe" /oobe /generalize /shutdown /quiet
