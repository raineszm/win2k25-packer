variable "windows_iso_path" {
  type        = string
  description = "Path to the Windows Server 2025 ISO"
}

variable "cloudbase_msi_path" {
  type        = string
  description = "Path to the Cloudbase-Init MSI installer"
}

variable "pwsh_msi_path" {
  type        = string
  description = "Path to the PowerShell 7 MSI installer"
  default     = "input/PowerShell-7.4.1-win-x64.msi"
}

variable "admin_password" {
  type        = string
  sensitive   = true
  description = "Administrator password used during build"
}

variable "output_directory" {
  type        = string
  description = "Directory for the output qcow2 image"
}

variable "disk_size" {
  type        = string
  description = "Disk size in MB"
}

variable "windows_image_name" {
  type        = string
  description = "Windows image name to install (e.g. SERVERSTANDARDCORE or SERVERSTANDARD)"
  default     = "Windows Server 2025 SERVERSTANDARDCORE"
}

variable "ovmf_vars_path" {
  type        = string
  description = "Path to a writable copy of OVMF_VARS for the build (modified in place by QEMU)"
  default     = "/tmp/OVMF_VARS_win2025.fd"
}
