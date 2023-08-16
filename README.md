# skit: CiviCRM Standalone + Buildkit

Quickly spin-up an instance of CiviCRM. Based on buildkit.

> Note: Unlike the full buildkit, `skit` only starts one site. It doesn't
> provide full the range of `civibuild` options.

## Requirements

Requires the `nix` package manager, which is compatible with Linux, MacOS, and Windows (WSL2).

## Quick start

* Install `nix` package manager (https://nixos.org/download)

    NOTE: This generally requires 1-3 commands. You will need to restart your shell afterward.

* Enable support for pre-built binaries

    ```bash
    nix-env -iA cachix -f https://cachix.org/api/v1/install
    cachix use bknix
    ```

    NOTE: This step is not strictly necessary. However, it will speed-up the process significantly.

* Download the `skit` project. Choose a storage folder like `$HOME/src/skit`.

    ```bash
    git clone "https://FIXME" "$HOME/src/skit"
    ```

* Review the new configuration (`env.yml`). You may need to customize the IP address, port numbers, etc. 
  This is particularly true if you use Windows (WSL2) or other forms of virtualization.

* Start MySQL, PHP, Apache, etc.

    ```bash
    ./bin/skit start
    ```

    NOTE: If this is the first time using buildkit or skit, then it will download MySQL, PHP, Apache, etc.
    These downloads are only used within `skit` -- they don't affect your main operating system.

* Create CiviCRM site

    ```bash
    ./bin/skit create
    ```
