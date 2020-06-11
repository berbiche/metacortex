{ target }:

with (import <root/globals.nix>);
let
  # Nix GC configuration (32GB filesystem so it has to be aggressive)
  minimum-free-gb-gc = 2;
  maximum-free-gb-gc = 5;

  mkRouter = cfg:
  { config, pkgs, lib, ... }:
    {
      deployment.targetEnv = "none";
      deployment.targetHost = target;
      deployment.targetPort = 22;
      networking = cfg.hostName // { inherit (cfg) hostId; };

      # Import roles here
      imports = [
        ./parameters.nix
        ./hardware.nix
      ] ++ roles-list;

      metacortex.host.niobe = {
        stateVersion = "20.03";
        ipv4addr = cfg.ipv4addr;
        ipv4prefix = cfg.ipv4prefix;
        ipv4gateway = cfg.ipv4gateway;
        timeZone = "America/Montreal";
      };
    };
in
{
  network.description = "Niobe router network configuration";
  network.enableRollback = true;

  defaults = { pkgs, ... }:
    {
      nix = {
        gc = {
          automatic = true;
          dates = "weekly";
        };
        extraOptions = ''
          min-free = ${toString (minimum-free-gb-gc * 1024 * 1024 * 1024)}
          max-free = ${toString (maximum-free-gb-gc * 1024 * 1024 * 1024)}
        '';
      };
    };

  niobe = mkRouter
    {
      hostName = mkHostname "niobe";
      hostId = "7d19f2a4";
      ipv4addr = "172.31.10.20";
      ipv4prefix = 24;
      ipv4gateway = "172.31.10.1";
    };
}
