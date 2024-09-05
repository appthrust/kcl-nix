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
          version = "0.10.0-rc.1";

          src = pkgs.fetchurl {
            url = "https://github.com/kcl-lang/cli/releases/download/v${version}/kcl-v${version}-${getArch system}.tar.gz";
            sha256 = {
              x86_64-linux = "1lbmkiy3bnssp6sadpdy0bwydnlyy00ks884ba9rwadc7yrybrqv";
              aarch64-linux = "1mh3zsvyymap20vyfwh4vcygshykc7vfb13125357kv53l5hprgp";
              x86_64-darwin = "0a97zd56n1z7rp6bcfghxc44m5yjigf2pj3wx8npllifh191l0vg";
              aarch64-darwin = "1j1dhvidfmn9p2x1njw0c9ns5kq8cadfrrpn8vm2yvy7k20wfzsa";
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
          version = "0.10.0-rc.1";

          src = pkgs.fetchurl {
            url = "https://github.com/kcl-lang/kcl/releases/download/v${version}/kclvm-v${version}-${getArch system}.tar.gz";
            sha256 = {
              x86_64-linux = "1m0yv55h12sz85f1z16qalxi9pfax34335phxlfapjbb9gvpvmls";
              aarch64-linux = "01xr7cjjmhhaa3ypd0kr7495l8bl8iikvpjl30j9fryirnqcr3gf";
              x86_64-darwin = "0pyr61gl97m2n3fypjq8vqj7s8z0jkgwmsrp1dpchmhl71156j6n";
              aarch64-darwin = "1x9wjqbv5asrwkzk3rc9isfsvdsw92ryiz02bpa63c119c7j05a2";
            }.${system};
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
