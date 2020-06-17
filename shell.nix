let
  sources = import ./nix/sources.nix;
  pkgs = import sources.nixpkgs {};
  src = (import sources.gitignore {}).gitignoreSource ./.;

  pre-commit-hook = (import sources.pre-commit-hooks).run {
    inherit src;
    hooks = {
      nixpkgs-fmt.enable = true;
      shellcheck.enable = true;
    };
    excludes = [ "nix/sources.nix$" "shell.nix$" ];
  };

  nixops = (import sources.nixops).default;

  path = builtins.getEnv("NIX_PATH");
in
pkgs.mkShell {
  inherit (pre-commit-hook) shellHook;

  NIX_PATH = "root=${toString ./.}:nixpkgs=${sources.nixpkgs.outPath}:/nix/var/nix/profiles/per-user/root/channels";

  buildInputs = [ nixops ];
}
