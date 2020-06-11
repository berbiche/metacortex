{}
# {
#   systemd.network.links.${eth-outside-world} = {
#     enable = true;
#     linkConfig = { MACAddress = eno1-MAC; };
#     matchConfig = { Name = eth-outside-world; };
#   };

#   networking.interfaces.${eth-outside-world} = {
#     ipv4 = {
#       addresses = [ { address = host.ipv4addr; prefixLength = host.ipv4prefix; } ];
#       routes = lib.optional (host.ipv4route != null) { address = host.ipv4route; prefixLength = host.ipv4prefix; };
#     };
#     tempAddress = "disabled";
#   };
# }
# (lib.mkIf (host ? ipv6addr && host.ipv6addr != null) {
#   networking.interfaces.${eth-outside-world}.ipv6 = {
#     addresses = [ { address = host.ipv6addr; prefixLength = host.ipv6prefix; } ];
#     routes = lib.optional (host.ipv6route != null) { address = host.ipv6route; prefixLength = host.ipv6prefix; };
#   };
# })
