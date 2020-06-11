{ lib, ... }:

let
  inherit (lib) mkOption types;

  options.metacortex.host.niobe = mkOption {
    description = "Niobe host configuration";
    type = types.submodule {
      options = {
        internal0 = mkOption {
          description = "Name of the default internal interface";
          default = "internal0";
          internal = true;
          readOnly = true;
        };
        external0 = mkOption {
          description = "Name of the default external interface";
          default = "external0";
          internal = true;
          readOnly = true;
        };
        stateVersion = mkOption {
          description = "The NixOS stateVersion running on the target";
          example = "20.09";
          type = types.str;
          readOnly = true;
        };
        ipv4addr = mkOption {
          description = "The ipv4 address of the default interface";
          example = "10.50.50.1";
          type = types.str;
          readOnly = true;
        };
        ipv4gateway = mkOption {
          description = "The ipv4 gateway of the default interface";
          example = "10.50.50.1";
          type = types.nullOr types.str;
          readOnly = true;
        };
        ipv4prefix = mkOption {
          description = "The ipv4 bitmask for the address";
          example = 24;
          type = types.ints.between 8 32;
          readOnly = true;
        };
        ipv4route = mkOption {
          description = "The ipv4 route for this interface";
          example = "10.50.50.1";
          type = types.nullOr types.str;
        };
        ipv6addr = mkOption {
          description = "The ipv6 address of the default interface";
          example = "2001:1470:fffd:2098::";
          type = types.nullOr types.str;
        };
        ipv6prefix = mkOption {
          description = "The ipv6 prefix for the address";
          example = 64;
          type = types.nullOr (types.ints.between 48 128);
        };
        ipv6route = mkOption {
          description = "The ipv6 route for this interface";
          example = "";
          type = types.nullOr types.str;
        };
        timeZone = mkOption {
          description = "The host timezone";
          example = "America/Montreal";
          type = types.str;
          readOnly = true;
        };
      };
    };
  };
in
{
  inherit options;
}
