SOURCE_WIN_ISO ?= input/winserver2025.iso
VIRTIO_ISO     ?= input/virtio-win.iso
OVMF_VARS      := /tmp/OVMF_VARS_win2025.fd
# Drivers are extracted into cd_content/drivers/ so the secondary CD has a
# clean E:\drivers\ subdirectory alongside the cloudbase files at E:\ root.
DRIVERS_DIR    := drivers

.PHONY: all build clean

all: build

# Extract 2k25/amd64 drivers from the VirtIO ISO.
# 7z handles ISO9660 without sudo. cd_dirs = ["cd_content"] puts the contents
# of cd_content/ at E:\ root, so drivers appear at E:\drivers\.
$(DRIVERS_DIR): $(VIRTIO_ISO)
	mkdir -p $(DRIVERS_DIR)
	7z x $(VIRTIO_ISO) -o$(DRIVERS_DIR) -aoa \
	    "vioscsi/2k25/amd64/*" \
	    "NetKVM/2k25/amd64/*" \
	    "Balloon/2k25/amd64/*" \
	    "vioserial/2k25/amd64/*" \
	    "viorng/2k25/amd64/*" \
	    "vioinput/2k25/amd64/*" \
	    "viogpudo/2k25/amd64/*" \
	    "viostor/2k25/amd64/*"

# Copy a fresh OVMF VARS template — QEMU modifies it in-place during the build.
$(OVMF_VARS):
	cp /usr/share/OVMF/OVMF_VARS_4M.fd $(OVMF_VARS)

build: $(DRIVERS_DIR) $(OVMF_VARS)
	packer build \
	    -var "windows_iso_path=$(SOURCE_WIN_ISO)" \
	    .

clean:
	rm -f $(OVMF_VARS)
	rm -rf output/ cd_content/
