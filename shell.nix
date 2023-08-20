/**
 * Inherit from buildkit's nix configuration. Add a few extra packages.
 */

{ pkgs ? import <nixpkgs> {} }:

let

  buildkit = (import ./buildkit.nix) { inherit pkgs; };
  basePkgs = buildkit.pins.v2305; ## Future: buildkit.pins.default
  profile = (import ./profile.nix) { inherit buildkit; pkgs = basePkgs; };

in

  basePkgs.mkShell {
    buildInputs = [ profile ];
    shellHook = ''
      export STEM_HOME="$PWD"
      export PATH="$STEM_HOME/bin:$PATH"
      eval $(loco env --export)
      source ${basePkgs.bash-completion}/etc/profile.d/bash_completion.sh
    '';
  }
