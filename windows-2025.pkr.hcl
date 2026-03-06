packer {
  required_version = ">= 1.9.0"
  required_plugins {
    qemu = {
      version = ">= 1.1.0"
      source  = "github.com/hashicorp/qemu"
    }
  }
}

source "qemu" "windows_2025" {
  iso_url      = var.windows_iso_path
  iso_checksum = "none"  # repacked ISO is a host-local artifact; original verified in build.sh

  disk_interface   = "virtio-scsi"
  net_device       = "virtio-net"
  machine_type     = "q35"
  accelerator      = "kvm"
  format           = "qcow2"
  disk_size        = var.disk_size
  disk_cache       = "writeback"
  disk_compression = true

  memory = 4096
  cpus   = 4

  boot_wait = "1s"

  headless  = true
  boot_command = [
    "<enter>", "<enter>"
  ]

  # UEFI firmware; vars file is modified in-place by QEMU so build.sh supplies a fresh copy.
  efi_firmware_code = "/usr/share/OVMF/OVMF_CODE_4M.fd"
  efi_firmware_vars = var.ovmf_vars_path

  # floppy_files mounts autounattend.xml and the WinRM bootstrap script on A:\.
  floppy_files = [
    "floppy/autounattend.xml",
    "floppy/enable-winrm.ps1",
  ]

  # cd_files creates a small ISO from the listed files and attaches it as a
  # second CD-ROM. install-virtio.ps1 scans all drives for the MSI, so the
  # exact drive letter assigned here does not matter.
  cd_files = [
    # var.virtio_msi_path,
    var.cloudbase_msi_path,
    "conf/cloudbase-init.conf",
  ]

  cpu_model = "host"

  communicator   = "winrm"
  winrm_username = "Administrator"
  winrm_password = var.admin_password
  winrm_timeout  = "2h"

  output_directory = var.output_directory
  vm_name          = "windows-server-2025.qcow2"
  shutdown_command = "shutdown /s /t 0 /f /d p:4:1 /c \"Packer Shutdown\""
}

build {
  sources = ["source.qemu.windows_2025"]

  # Install and configure OpenSSH server
  provisioner "powershell" {
    script = "scripts/install-openssh.ps1"
  }

  # # Install VirtIO drivers from mounted ISO
  # provisioner "powershell" {
  #   script = "scripts/install-virtio.ps1"
  # }

  # Install Cloudbase-Init and apply config
  provisioner "powershell" {
    script = "scripts/install-cloudbase.ps1"
  }

  # Sysprep to generalize — VM shuts down after this
  provisioner "powershell" {
    script = "scripts/sysprep.ps1"
  }
}
