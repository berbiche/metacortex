{ config, pkgs, lib, modulesPath, ... }:

let
  host = config.metacortex.host.niobe;

  external0-MAC = "7c:d3:0a:25:4c:7f";
  internal0-MAC = "00:e0:4d:3b:fa:b5";

  external0 = host.external0;
  internal0 = host.internal0;
in
{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];
  system.stateVersion = host.stateVersion;

  nixpkgs.config.allowUnfree = true;

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "ahci"
    "ohci_pci"
    "ehci_pci"
    "pata_atiixp"
    "usb_storage"
    "sd_mod"
  ];
  boot.initrd.kernelModules = [];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # This is a 4 core machine
  nix.maxJobs = 2;

  fileSystems = {
    "/" = {
      label = "nixos";
      fsType = "ext4";
      options = [ "noatime" "nodiratime" ];
    };
    "/boot" = {
      label = "boot";
      fsType = "vfat";
    };
  };

  swapDevices = [];

  networking.useDHCP = false;
  networking.useNetworkd = true;
  # Modem DHCP
  #networking.interfaces.${eth-outside-world}.useDHCP = true;
  # Persistent eth name
  # Enable systemd-networkd
  systemd.network.enable = true;
  systemd.network.links."10-${external0}" = {
    matchConfig = { MACAddress = external0-MAC; };
    linkConfig = { Name = external0; };
  };
  systemd.network.networks.${external0} = {
    matchConfig = { Name = external0; };
    # No ipv6 support from the ISP right now
    DHCP = "ipv4";
    dhcpV4Config = {
      SendHostname = false;
      UseDNS = false;
    };
  };
  systemd.network.links."10-${internal0}" = {
    matchConfig = { MACAddress = internal0-MAC; };
    linkConfig = { Name = internal0; };
  };
  systemd.network.networks.${internal0} = {
    matchConfig = { Name = internal0; };
    address = [
      "${host.ipv4addr}/${toString host.ipv4prefix}"
    ];
    routes = [
      {
        routeConfig = { Destination = "0.0.0.0/0"; Gateway = host.ipv4gateway; };
      }
    ];
  };
  networking.firewall.interfaces.${internal0}.allowedTCPPorts = [ 22 ];

  time.timeZone = host.timeZone;

  services.openssh = {
    enable = true;
    listenAddresses = [ { addr = host.ipv4addr; port = 22; } ];
    passwordAuthentication = true; # temporary
    permitRootLogin = "yes";
  };

  # Open ports in the firewall
  networking.firewall = {
    enable = true;
    allowPing = true;
  };

  users.users.root.initialPassword = "root";
}
