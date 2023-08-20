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
  This is particularly so if you use Windows WSL2 or other forms of virtualization.

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

    After this, you will find CiviCRM source code in `./web/core`. You can login with the
    hostname and administrator specified by `env.yml`.

* Interact with the shell

    ```bash
    ./bin/skit shell
    ```

## Appendix: Buildkit version

This project uses `civicrm-buildkit.git`. You can identify or change the version by editing `buildkit.nix`.

To update to the latest `civicrm-buildkit.git`, run `./tools/update.sh`.

## Appendix: Commands

`skit` is a smaller wrapper for other commands.

Some commands are simple aliases:

| Skit Command    | Real Command   |
| --              | --             |
| `skit shell`    | `nix-shell`    |
| `skit start`    | `loco start`   |
| `skit stop`     | `loco stop`    |
| `skit status`   | `loco status`  |
| `skit clean`    | `loco clean`   |

A few commands are work-a-likes:

| Skit Command     | Comparable Command   |
| --               | --             |
| `skit create`    | `civibuild create NAME --type standalone-dev`   |
| `skit download`  | `civibuild download NAME --type standalone-dev` |
| `skit install`   | `civibuild install NAME --type standalone-dev`  |
