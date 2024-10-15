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
          version = "0.10.2-rc.1";

          src = pkgs.fetchurl {
            url = "https://github.com/kcl-lang/cli/releases/download/v${version}/kcl-v${version}-${getArch system}.tar.gz";
            sha256 = {
              x86_64-linux = "00yf692wz0jhq7fsdnx44mrxwxap3s97byghf42xg0w762hlaaqw";
              aarch64-linux = "151c62p9wc4bfc8dbm15mjjghh0vay4kgillk832dfjicybz0b8v";
              x86_64-darwin = "0a6iyaz19j7yl31ysv6x0vbwbg20lcq21zgql2spxg8m9xj0x05m";
              aarch64-darwin = "1hz4kbxwly9mr2kd7i0y77vqafynf6pb19xrnncxyq9mm5fmx327";
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
          version = "0.10.3";

          src = pkgs.fetchurl {
            url = "https://github.com/kcl-lang/kcl/releases/download/v${version}/kclvm-v${version}-${getArch system}.tar.gz";
            sha256 = {
              x86_64-linux = "1qd03hwskk93dcpsk8199q5nxrjry45yik4ik5invpr1046d22rx";
              aarch64-linux = "12pxnjf3k0kza2lzgysq51pz8lm46ildxnl7w4wpimrzcg71fhjh";
              x86_64-darwin = "03zbfl85fjq2bhb3z82hp0v6yn1lfq7fa2i379ffky0jwzbbd38c";
              aarch64-darwin = "1g7gyyca0p4l42ny1xfi0if58q7aqmws37b0qjkdlp66fnvc024c";
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
