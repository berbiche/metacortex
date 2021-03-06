# Metacortex

NixOps definition of my homelab!

I'm learning NixOps so the code quality (code reuse, layout strategy, etc.) is mediocre.

## Structure

- `deployments` - Includes all NixOPS deployments definitions.
- `host` - Definition of an `host` within the network. A `host` can have multiples `roles`.
  A `host` still has configurable variables that must be configured within a deployment.
- `nix` - NixOS package source managed using Niv
- `roles` - Contains definitions of specific roles a `host` can have

## Commands

Usage of the provided `shell.nix` using either `nix-shell` or `lorri` is recommended.

The NIX_PATH environment variable is modified to add a custom root path for use with imports.

### Deploy

TODO

## Things to Learn

My roadmap to making a good use out of NixOps

### HOWTOs

- [ ] Define a directory structure
  - Per-host?
  - Per-functionality (akin to a role in Ansible)?

- [ ] Reuse code as much as possible

- [ ] Define a new host easily

- [ ] Keep track of the host inventory

  NixOps has the `nixops export` command.
  NixOps preserves the deployment state in `$HOME/.nixops/deployments.nixops` by default.

- [ ] Document the infrastructure
  - [ ] Using a custom structure that exposes a `comment = types.str;` alongside
        preprocessing to remove the comments
  - [ ] Dynamically generate the documentation
  - [ ] ???

## Helpful commands

- Debug systemd-networkd links/networks configuration: `SYSTEMD_LOG_LEVEL=debug udevadm test-builtin net_setup_link /sys/class/net/${DEVICE}`

## Links

- [The nixops defaults module](https://nixos.mayflower.consulting/blog/2018/11/08/the-nixops-default-module/)
- [Writing NixOS Modules](https://nixos.org/nixos/manual/index.html#sec-writing-modules)
- [Discovering Nix: Provisioning a static webserver with NixOps](https://sevdev.hu/posts/2017-12-26-discovering-nix-deploying-a-simple-nginx-with-nixops.html)
- [NixOps deployment configuration for IOHK devops](https://github.com/input-output-hk/iohk-ops)
- [krops vs. NixOps](https://tech.ingolf-wagner.de/nixos/krops/)
- [Secure, Declarative Key Management with NixOps, Pass, and nix-plugins](https://elvishjerricco.github.io/2018/06/24/secure-declarative-key-management.html)
- [How to set persistent NIC device name via udev](https://access.redhat.com/solutions/112643)
- [Network Interface Names](https://wiki.debian.org/NetworkInterfaceNames#CUSTOM_SCHEMES_USING_.LINK_FILES)
- [NixOps - Managing Keys](https://releases.nixos.org/nixops/nixops-1.7/manual/manual.html#idm140737322342384)
- [ArchLinux: systemd-networkd](https://wiki.archlinux.org/index.php/Systemd-networkd)
