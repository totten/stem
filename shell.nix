/**
 * Inherit from buildkit's nix configuration. Add a few extra packages.
 */

{ pkgs ? import <nixpkgs> {} }:

let

  buildkit = import (pkgs.fetchFromGitHub {
    owner = "civicrm";
    repo = "civicrm-buildkit";
    rev = "04b338a52bbf0bdc21edafe564b875138c1db12c";
    sha256 = "sha256-zTt9TZ7fZ+xjDicTfRiEalnK4Y8ijd89cN1sT8FA1eQ=";
    ## TODO: See if we can track master without needing to lock-in revisions
  });

  ## If you're trying to patch buildkit at the sametime, then use a local copy:
  # buildkit = import ((builtins.getEnv "HOME") + "/buildkit/default.nix");
  # buildkit = import ((builtins.getEnv "HOME") + "/bknix/default.nix");

in

  ## Now, we define a shell with the packages that we want. This may use:
  ##
  ## Profiles (curated set of packages used by CI)
  ##   buildkit.profiles.min  (Low versions of PHP/MySQL)
  ##   buildkit.profiles.max  (High versions of PHP/MySQL)
  ##   buildkit.profiles.edge (Future versions of PHP/MySQL)
  ##   buildkit.profiles.dfl
  ##   buildkit.profiles.alt
  ##
  ## Specific packages (from buildkit)
  ##   buildkit.pkgs.php73
  ##   buildkit.pkgs.php81
  ##   buildkit.pkgs.composer
  ##
  ## Specific packages (from upstream releases of nixpkgs)
  ##   buildkit.dists.v2205.composer
  ##   buildkit.dists.v2305.composer
  ##   buildkit.dists.v2305.php81

  pkgs.mkShell {
    nativeBuildInputs = buildkit.profiles.dfl ++ [
      buildkit.pkgs.composer
      buildkit.pkgs.pogo
      buildkit.pkgs.loco
      buildkit.pkgs.phpunit8
      buildkit.pkgs.phpunit9
      buildkit.pkgs.cv
      buildkit.pkgs.civix
      pkgs.bash-completion
    ];
    shellHook = ''
      export SKIT_HOME="$PWD"
      export PATH="$SKIT_HOME/bin:$PATH"
      eval $(loco env --export)
      source ${pkgs.bash-completion}/etc/profile.d/bash_completion.sh
    '';
  }
