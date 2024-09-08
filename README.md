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

## Automated Updates

This repository includes a GitHub Actions workflow that automatically checks for new KCL releases daily. When a new version is available, it updates the `flake.nix` file using a template (`flake.nix.tpl`) and a Python script (`update_flake.py`), then creates a pull request with the changes. This ensures that the flake always provides the latest KCL tools.

The `update_flake.py` script handles fetching the latest KCL version, calculating hashes for different architectures, and generating the updated `flake.nix` file.

### Contributing to flake.nix

The `flake.nix` file is automatically generated from the `flake.nix.tpl` template. If you need to make changes to the flake configuration, please modify the template file instead of directly editing `flake.nix`. The automated update process will use your changes in the template to generate the new `flake.nix` file.

If you need to modify the update process itself, you can edit the `update_flake.py` script.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request. Remember to modify `flake.nix.tpl` instead of `flake.nix` when making changes to the flake configuration.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- KCL developers and contributors
- Nix and flakes community

For more information about KCL, visit the [official KCL documentation](https://kcl-lang.io/).
