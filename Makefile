SOURCE_WIN_ISO ?= input/winserver2025.iso
WIN_ISO        ?= winserver2025-final.iso
VIRTIO_ISO     ?= input/virtio-win.iso
OVMF_VARS      := /tmp/OVMF_VARS_win2025.fd
DISTRO_BUILDER ?= distorbuilder

.PHONY: all build clean

all: build

# Repack the Windows ISO with distrobuilder (injects efisys_noprompt.bin and
# VirtIO drivers into boot.wim / install.wim for prompt-free UEFI boot).
$(WIN_ISO): $(SOURCE_WIN_ISO) $(VIRTIO_ISO)
	sudo $(DISTRO_BUILDER) repack-windows $(SOURCE_WIN_ISO) $(WIN_ISO) --drivers=$(VIRTIO_ISO) \
		--windows-version=2k25

# Copy a fresh OVMF VARS template — QEMU modifies it in place during the build.
$(OVMF_VARS):
	cp /usr/share/OVMF/OVMF_VARS_4M.fd $(OVMF_VARS)

build: $(WIN_ISO) $(OVMF_VARS)
	packer build \
		-var "windows_iso_path=$(WIN_ISO)" \
		.

clean:
	rm -f $(WIN_ISO) $(OVMF_VARS)
	rm -rf output/
