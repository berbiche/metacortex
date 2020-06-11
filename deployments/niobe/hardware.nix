{ config, pkgs, lib, modulesPath, ... }:

let
  host = config.metacortex.host.niobe;

  lan1-MAC = "7c:d3:0a:25:4c:7f";
  lan10-MAC = "00:e0:4d:3b:fa:b5";

  eth-outside-world = "lan1";
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
  systemd.network.links."10-${eth-outside-world}" = {
    matchConfig = { MACAddress = lan1-MAC; };
    linkConfig = { Name = eth-outside-world; };
  };
  systemd.network.networks."10-${eth-outside-world}" = {
    matchConfig = { Name = eth-outside-world; };
    DHCP = true;
    dhcpV4Config = {
      SendHostname = false;
      UseDNS = false;
    };
  };
  systemd.network.links."10-lan10" = {
    matchConfig = { MACAddress = lan10-MAC; };
    linkConfig = { Name = "lan10"; };
  };
  systemd.network.networks."10-lan10" = {
    matchConfig = { Name = "lan10"; };
    address = [
      "${host.ipv4addr}/${toString host.ipv4prefix}"
    ];
    routes = [ { routeConfig = { Destination = "0.0.0.0/0"; Gateway = host.ipv4gateway; }; } ];
  };
  networking.firewall.interfaces.lan10.allowedTCPPorts = [ 22 ];

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
