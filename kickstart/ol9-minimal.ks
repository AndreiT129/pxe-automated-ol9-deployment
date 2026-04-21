#version=RHEL9

install
url --url="http://192.168.99.235/ol9"

lang en_US.UTF-8
keyboard us
timezone Europe/Bucharest --isUtc

network --bootproto=dhcp --device=link --activate

rootpw --plaintext topex

firewall --enabled
selinux --enforcing

# -----------------------------
# UEFI BOOTLOADER
# -----------------------------
bootloader --location=efi

# -----------------------------
# DISK HANDLING
# -----------------------------
clearpart --all --initlabel

# -----------------------------
# CUSTOM PARTITIONING
# -----------------------------

part /boot/efi --fstype="efi" --size=600

part /boot --fstype="xfs" --size=1024

part pv.01 --grow

volgroup ol pv.01

logvol swap --vgname=ol --name=swap --size=2048
logvol / --vgname=ol --name=root --fstype="xfs" --grow

reboot

%packages
@^minimal-environment
%end
