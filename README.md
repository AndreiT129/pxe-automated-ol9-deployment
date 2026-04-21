# PXE Automated Linux Deployment (Oracle Linux 9, UEFI)

## Overview

This project implements a **UEFI-based PXE provisioning system** to automate the installation of Oracle Linux 9.

It enables a physical server to boot over the network and perform a **fully unattended minimal installation** using DHCP, TFTP, GRUB, HTTP, and Kickstart.

---

## How It Works (PXE Boot Flow)

```
Client (Physical Server)
    ↓ DHCP (gets IP + boot file)
    ↓ TFTP (downloads GRUB)
    ↓ GRUB (loads kernel + initrd)
    ↓ HTTP (fetches OS + Kickstart)
    ↓ Automated Installation
```

---

## Technologies Used

* Oracle Linux 9
* DHCP (ISC DHCP Server)
* TFTP
* Apache HTTP Server
* GRUB2 (UEFI PXE boot)
* Kickstart (automated installation)

---

## Project Structure

```
dhcp/       → DHCP configuration
tftp/       → GRUB PXE boot configuration
kickstart/  → Automated installation file
docs/       → Additional notes (optional)
```

---

## Key Components

### DHCP

Provides:

* IP address to the client
* PXE boot file (`grubx64.efi`)

Example:

```
next-server 192.168.99.225;

if option arch = 00:07 {
    filename "EFI/BOOT/grubx64.efi";
}
```

---

### TFTP

Serves boot-related files:

* GRUB EFI binary
* GRUB configuration
* Linux kernel (`vmlinuz`)
* initramfs (`initrd.img`)

Directory:

```
/var/lib/tftpboot/EFI/BOOT/
```

---

### GRUB (PXE Bootloader)

Loads the installer and defines boot parameters:

```
menuentry "Install Oracle Linux 9 Minimal" {
    linuxefi /EFI/BOOT/vmlinuz inst.repo=http://192.168.99.225/ol9 \
        inst.ks=http://192.168.99.225/ks/ol9-minimal.ks \
        ip=dhcp
    initrdefi /EFI/BOOT/initrd.img
}
```

---

### HTTP Repository

Hosts the OS installation files and Kickstart:

* `/ol9/` → Oracle Linux installation repo (BaseOS, AppStream)
* `/ks/` → Kickstart file

Created by mounting the Oracle Linux ISO and copying its contents.

---

### Kickstart (Automation)

Automates the entire installation process:

* Sets language, timezone, networking
* Wipes disk and configures partitions
* Installs minimal OS

Partitioning design:

* `/boot/efi` → UEFI boot partition
* `/boot` → kernel
* LVM:

  * `swap`
  * `/` (uses remaining disk space)

---

## Features

* UEFI PXE boot support
* Fully unattended OS installation
* Minimal CLI-based deployment
* Custom LVM partitioning (no `/home`)
* Reproducible setup

---

## Troubleshooting

Common issues encountered:

| Issue                  | Cause                         |
| ---------------------- | ----------------------------- |
| TFTP permission denied | SELinux or file permissions   |
| No boot filename       | DHCP misconfiguration         |
| PXE timeout            | firewall or service issue     |
| Installer fails        | incorrect HTTP/Kickstart path |

Debugging was performed using:

```
journalctl -f
```

---

## Key Learnings

* PXE boot process (DHCP → TFTP → GRUB → HTTP)
* UEFI vs BIOS boot differences
* Automated provisioning with Kickstart
* Integration of multiple network services
* Troubleshooting low-level boot and network issues

---

## Future Improvements

* Multi-OS PXE boot menu
* Static IP assignment via DHCP reservations
* Post-install automation scripts
* Integration with configuration management tools
