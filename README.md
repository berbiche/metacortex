# Metacortex

NixOps definition of my homelab!

I'm learning NixOps so the code quality (code reuse, layout strategy, etc.) is mediocre.

## Structure

- `deployments` - Includes all NixOPS deployments definitions.
- `host` - Definition of an `host` within the network. A `host` can have multiples `roles`.
  A `host` still has configurable variables that must be configured within a deployment.
- `nix` - NixOS package source managed using Niv
- `roles` - Contains definitions of specific roles a `host` can have

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
