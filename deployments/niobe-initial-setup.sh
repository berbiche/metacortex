#! /usr/bin/env bash
set -Eeuo pipefail

DISK=${DISK:-/dev/sda}

trap "echo 'Error: exiting script'" ERR

echo '
THIS IS THE INITIAL SETUP FILE FOR THE "niobe" HOST

This script will configure the filesystem.

This script is meant to be run through SSH in the NixOS live disk.

This script accept the DISK environment variable to define where to setup:
1. GPT table (which will effectively wipe the disk partition table)
2. Disk partitions (boot and root)
3. Filesystems (boot and root)

A configuration.nix file can be uploaded in the same folder as this script,
otherwise a default configuration file will be created.

The default configuration created enables OpenSSH on port 22.
The device is available at 172.31.10.15.

The default password for root is "root".

Current date: '"$(date +'%x')"

if [ ! "x$1" == "xyes" ]; then
    echo "Do you wish to proceed and clean up the filesystem?"
    select yn in "Yes" "No"; do
        case $yn in
            Yes ) break;;
            No ) exit;;
        esac
    done
fi


echo "Proceeding with installation."
echo "1. Initializing drive partition on disk ${DISK}"
umount ${DISK}* || true
wipefs -a $DISK
parted $DISK -- mklabel gpt
parted $DISK -- mkpart ESP fat32 1MiB 512MiB
parted $DISK -- mkpart primary 512MiB 100%
parted $DISK -- print
partprobe $DISK
parted $DISK -- set 1 boot on
lsblk -f $DISK

# Create filesystem
echo "2. Creating FS"
mkfs.ext4 -L nixos ${DISK}2
mkfs.fat -F 32 -n boot ${DISK}1
partprobe $DISK
lsblk -f $DISK

# Mount and install
echo "3. Mounting FS"
mkdir -p /mnt
mount /dev/disk/by-label/nixos /mnt
mkdir -p /mnt/boot
mount /dev/disk/by-label/boot /mnt/boot

echo "4. Installing NixOS"
mkdir -p /mnt/etc/nixos
if [[ ! -f "configuration.nix" ]]; then
    >&2 echo "Missing configuration.nix file. Creating a default configuration.nix"
    cat >configuration.nix <<-EOF
    { config, pkgs, ... }:
    {
        imports = [ ./hardware-configuration.nix ];

        system.stateVersion = "20.09";
        boot.loader.systemd-boot.enable = true;
        boot.loader.efi.canTouchEfiVariables = false;
        networking.hostName = "temporary";

        networking.useDHCP = false;
        networking.interfaces.enp1s0.ipv4.addresses = [ { address = "172.31.10.15"; prefixLength = 16; } ];

        networking.firewall.enable = true;
        networking.firewall.allowPing = true;
        networking.firewall.allowedTCPPorts = [ 22 ];

        services.openssh.enable = true;
        services.openssh.passwordAuthentication = true;
        services.openssh.permitRootLogin = "yes";

        users.users.root.initialPassword = "root";
    }
EOF
fi
mv -v configuration.nix /mnt/etc/nixos/configuration.nix
nixos-generate-config --root /mnt

echo "5. Building NixOS"
if [[ ! "x$1" == "xyes" ]]; then
    echo "Do you wish to proceed and clean up the filesystem?"
    select yn in "Yes" "No"; do
        case $yn in
            Yes ) break;;
            No )
                echo "Not building NixOS"
                exit;;
        esac
    done
fi
nixos-install --no-root-passwd --root /mnt
