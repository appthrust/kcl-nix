{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    kclpkgs.url = "..";
  };

  outputs = { self, nixpkgs, flake-utils, kclpkgs }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        kcl = kclpkgs.default.${system};
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = [
            kcl.cli
            kcl.language-server
            kcl.kubectl-kcl
          ];
        };
      }
    );
}