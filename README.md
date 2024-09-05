# KCL Nix Flake

This repository provides a Nix flake for the KCL (Kubernetes Configuration Language) toolchain, including the KCL CLI and KCL Language Server.

## Features

- Easy installation and usage of KCL tools through Nix
- Cross-platform support (Linux and macOS, both x86_64 and aarch64)
- Reproducible builds and development environments
- Seamless integration with other Nix-based projects

## Prerequisites

- Nix package manager with flakes enabled

## Usage

To use this flake in your project, add it to your `flake.nix` inputs:

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    kclpkgs.url = "github:appthrust/kcl-nix";
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
          ];
        };
      }
    );
}
```

Then, you can enter a development shell with KCL tools available:

```bash
nix develop
```

## Available Tools

- `kcl`: The KCL Command Line Interface
- `kcl-language-server`: The KCL Language Server

## Versioning

This flake currently provides KCL tools version 0.10.0-rc.1. To update to a newer version, modify the `version` and `sha256` values in the `flake.nix` file.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- KCL developers and contributors
- Nix and flakes community

For more information about KCL, visit the [official KCL documentation](https://kcl-lang.io/).
