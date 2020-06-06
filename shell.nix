let
  sources = import ./nix/sources.nix;
  pkgs = import sources.nixpkgs {};
  src = (import sources.gitignore {}).gitignoreSource ./.;

  pre-commit-hook = (import sources.pre-commit-hooks).run {
    inherit src;
    hooks = {
      nixpkgs-fmt.enable = true;
      shellCheck.enable = false; # Not working
    };
    excludes = [ "nix/sources.nix$" ];
  };
in
pkgs.mkShell {
  inherit (pre-commit-hook) shellHook;
  buildInputs = [ pkgs.nixops ];
}
