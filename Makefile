SOURCE_WIN_ISO ?= input/winserver2025.iso
WIN_ISO        ?= winserver2025-final.iso
VIRTIO_ISO     ?= input/virtio-win.iso
VIRTIO_MSI     := /tmp/virtio-win-gt-x64.msi
OVMF_VARS      := /tmp/OVMF_VARS_win2025.fd

.PHONY: all build clean

all: build

# Repack the Windows ISO with distrobuilder (injects efisys_noprompt.bin and
# VirtIO drivers into boot.wim / install.wim for prompt-free UEFI boot).
$(WIN_ISO): $(SOURCE_WIN_ISO) $(VIRTIO_ISO)
	distrobuilder repack-windows $(SOURCE_WIN_ISO) $(WIN_ISO) --virtio-iso=$(VIRTIO_ISO)

# Extract the VirtIO MSI from the virtio ISO so Packer can attach it via cd_files.
$(VIRTIO_MSI): $(VIRTIO_ISO)
	$(eval TMPVIRTIO := $(shell mktemp -d))
	sudo mount -o loop,ro $(VIRTIO_ISO) $(TMPVIRTIO)
	cp $(TMPVIRTIO)/virtio-win-gt-x64.msi $(VIRTIO_MSI)
	sudo umount $(TMPVIRTIO)
	rmdir $(TMPVIRTIO)

# Copy a fresh OVMF VARS template — QEMU modifies it in place during the build.
$(OVMF_VARS):
	cp /usr/share/OVMF/OVMF_VARS_4M.fd $(OVMF_VARS)

build: $(WIN_ISO) $(VIRTIO_MSI) $(OVMF_VARS)
	packer build \
		-var "windows_iso_path=$(WIN_ISO)" \
		-var "virtio_msi_path=$(VIRTIO_MSI)" \
		.

clean:
	rm -f $(WIN_ISO) $(VIRTIO_MSI) $(OVMF_VARS)
	rm -rf output-windows-2025
