/**
 * Inherit from buildkit's nix configuration. Add a few extra packages.
 */

{ pkgs ? import <nixpkgs> {} }:

let

  buildkit = (import ./buildkit.nix) { inherit pkgs; };

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
  ##
  ## Helper functions
  ##   (buildkit.funcs.fetchPhar { name = ...; url = ...; sha256 = ...; })

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
      export STEM_HOME="$PWD"
      export PATH="$STEM_HOME/bin:$PATH"
      eval $(loco env --export)
      source ${pkgs.bash-completion}/etc/profile.d/bash_completion.sh
    '';
  }
