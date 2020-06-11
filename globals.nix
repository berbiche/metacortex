with builtins;
let
  pkgs = import (import ./nix/sources.nix).nixpkgs {};
  lib = pkgs.lib;

  config = pkgs.callPackage ./config.nix {};
in
{
  inherit pkgs;

  # Makes a hostname within the metacortex lan
  mkHostname = name: { hostName = name; domain = "metacortex.lan"; };

  # The list of roles that can be imported and configured
  roles-list = lib.pipe (builtins.readDir ./roles) [
    (attrNames)
    (map (role: <root> + "/roles/${role}"))
  ];

  inherit (config) public-ssh-keys;
}
