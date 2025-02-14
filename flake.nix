# WARNING: This file is automatically generated. Do not edit directly.
# Instead, modify the flake.nix.tpl file and run the update script.

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
          else throw "Unsupported system: ${system}";

        cli = pkgs.stdenv.mkDerivation rec {
          pname = "kcl-cli";
          version = "0.11.1";

          src = pkgs.fetchurl {
            url = "https://github.com/kcl-lang/cli/releases/download/v${version}/kcl-v${version}-${getArch system}.tar.gz";
            sha256 = {
              x86_64-linux = "1xkwd9azvrgy4kg02ifgv4ji40a6a6h0b4hwpn9dil0vnahy5rj0";
              aarch64-linux = "16abqqi41d1hkzf719950xl3rdm09w3m4mwg4rpcx3c7nb2iy5gi";
              x86_64-darwin = "08q1y24m72420cnqvy96v33z8q97x79dkbpscsfw4n9wpbrsqnqm";
              aarch64-darwin = "014sdv1qsab9f9bgakzjymr4lv1ab5fjg2njp1g8zb08kzmzhv1p";
            }.${system};
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
          version = "0.11.1";

          src = pkgs.fetchurl {
            url = "https://github.com/kcl-lang/kcl/releases/download/v${version}/kclvm-v${version}-${getArch system}.tar.gz";
            sha256 = {
              x86_64-linux = "05clvf25qdrkyhjqwvq46b7sa2yh6d168b6w7j650knjnf1dg2q1";
              aarch64-linux = "087sqwrm3q9k4xbj8jfq0m7xdb8bf5r7nhbqfckcqcj7i68w7zrs";
              x86_64-darwin = "1v94x7wc3gfzanb8s6phvj8hvfimw0l77c2dl1br96qwmb9n6dil";
              aarch64-darwin = "1vim7bn0wfv5l4vsi5zzvcqr6l9ys1yrrdydiysb7z1ssmfmaksg";
            }.${system};
          };

          installPhase = ''
            mkdir -p $out/bin
            cp bin/kcl-language-server $out/bin/
          '';
        };

        getArchKubectlKcl = system:
          if system == "x86_64-linux" then "linux-amd64"
          else if system == "aarch64-linux" then "linux-arm64"
          else if system == "x86_64-darwin" then "macos-amd64"
          else if system == "aarch64-darwin" then "macos-arm64"
          else throw "Unsupported system: ${system}";

        kubectl-kcl = pkgs.stdenv.mkDerivation rec {
          pname = "kubectl-kcl";
          version = "0.9.0";

          src = pkgs.fetchurl {
            url = "https://github.com/kcl-lang/kubectl-kcl/releases/download/v${version}/kubectl-kcl-${getArchKubectlKcl system}.tgz";
            sha256 = {
              x86_64-linux = "1242dvx9ph52yxq988n0fvsbm9wpchi4pwpwj2zbscw1hgy0apq8";
              aarch64-linux = "1d0yby7niw7npp5v5f91q20g2z4flnzkp6ydhc0sjwls3lwrj8g9";
              x86_64-darwin = "1qyrmfwabz0aa3bavjrijmq21gk1marks6b1k2vg1vy68z68pll7";
              aarch64-darwin = "1vz529yi5dz0wi0ymbg3q52ixqdfzv9czk8iwp94q5ffjqcvdf9j";
            }.${system};
          };

          installPhase = ''
            mkdir -p $out/bin
            cp bin/kubectl-kcl $out/bin/
          '';
        };

      in
      {
        default = {
          inherit cli language-server kubectl-kcl;
        };
      }
    );
}
