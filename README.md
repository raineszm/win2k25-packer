# Win2k25 for Openstack with Packer

This repo provides a packer template and associated makefile for building
Windows Server 2k25 qcow2 images for use on Openstack.

**Quality of life features include**:

- Installing virtio drivers
- Enabling SSH
- Installing CloudbaseInit
- Setup Admin accounts to use authorized_keys

## Requirements

In order for the Makefile to work, you'll need:

- make (obviously)
- packer
- qemu
- p7zip

I believe, packer also uses xorriso in the background during the build process.

## Usage

Before building, you'll need a copy of the Windows Server 2k25 ISO and the
virtio drivers ISO.

|ISO|Default Path|Make Variable|
|---|------------|-------------|
|Windows 2k25 ISO|`input/winserver2025.iso`|`SOURCE_WIN_ISO`|
|Virtio Drivers ISO|`input/virtio-win.iso`|`VIRTIO_ISO`|

Then you can simply run `make` to prepare the drivers and build the image.
It should work completely unattended. The final result will be in the `output/`
folder.

Alternatively, you can just unpack the drivers yourself into the `drivers/` folder
and just run `packer` yourself.
