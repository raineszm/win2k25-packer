variable "windows_iso_path" {
  type        = string
  description = "Path to the Windows Server 2025 ISO"
}

variable "virtio_msi_path" {
  type        = string
  description = "Path to the virtio-win-gt-x64.msi installer (extracted from virtio-win ISO by build.sh)"
  default     = "/tmp/virtio-win-gt-x64.msi"
}

variable "cloudbase_msi_path" {
  type        = string
  description = "Path to the Cloudbase-Init MSI installer"
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

variable "ovmf_vars_path" {
  type        = string
  description = "Path to a writable copy of OVMF_VARS for the build (modified in place by QEMU)"
  default     = "/tmp/OVMF_VARS_win2025.fd"
}
