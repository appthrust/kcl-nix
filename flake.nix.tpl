{
  description = "KCL toolchain flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };

        getArch = system:
          if system == "x86_64-linux" then "linux-amd64"
          else if system == "aarch64-linux" then "linux-arm64"
          else if system == "x86_64-darwin" then "darwin-amd64"
          else if system == "aarch64-darwin" then "darwin-arm64"
          else throw "Unsupported system: $${system}";

        cli = pkgs.stdenv.mkDerivation rec {
          pname = "kcl-cli";
          version = "$cli_version";

          src = pkgs.fetchurl {
            url = "https://github.com/kcl-lang/cli/releases/download/v$${version}/kcl-v$${version}-$${getArch system}.tar.gz";
            sha256 = {
              x86_64-linux = "$cli_hash_x86_64_linux";
              aarch64-linux = "$cli_hash_aarch64_linux";
              x86_64-darwin = "$cli_hash_x86_64_darwin";
              aarch64-darwin = "$cli_hash_aarch64_darwin";
            }.$${system};
          };

          dontUnpack = true;

          installPhase = ''
            mkdir -p $out/bin
            tar -xzf $src -C $out/bin
            # Ensure the file is named 'kcl'
            if [ ! -f $out/bin/kcl ]; then
              mv $out/bin/kcl-cli $out/bin/kcl || true
            fi
            chmod +x $out/bin/kcl
          '';
        };

        language-server = pkgs.stdenv.mkDerivation rec {
          pname = "kcl-language-server";
          version = "$kcl_version";

          src = pkgs.fetchurl {
            url = "https://github.com/kcl-lang/kcl/releases/download/v$${version}/kclvm-v$${version}-$${getArch system}.tar.gz";
            sha256 = {
              x86_64-linux = "$language_server_hash_x86_64_linux";
              aarch64-linux = "$language_server_hash_aarch64_linux";
              x86_64-darwin = "$language_server_hash_x86_64_darwin";
              aarch64-darwin = "$language_server_hash_aarch64_darwin";
            }.$${system};
          };

          installPhase = ''
            mkdir -p $out/bin
            cp bin/kcl-language-server $out/bin/
          '';
        };

      in
      {
        default = {
          inherit cli language-server;
        };
      }
    );
}
