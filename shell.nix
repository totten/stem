/**
 * Define a shell environment for working on CiviCRM.
 *
 * To run this, simply call `nix-shell`.
 *
 * NOTE: The main substance is defined by `profile.nix`.
 */

{ pkgs ? import <nixpkgs> {} }:

let

  buildkit = (import ./buildkit.nix) { inherit pkgs; };
  basePkgs = buildkit.pins.v2305; ## Future: buildkit.pins.default
  profile = (import ./profile.nix) { inherit buildkit; pkgs = basePkgs; };

  shell = basePkgs.mkShell {
    name = "stem";
    buildInputs = profile;
    shellHook = ''
      export STEM_HOME="$PWD"
      eval $(loco env --export)
      source ${basePkgs.bash-completion}/etc/profile.d/bash_completion.sh
    '';
  };

in shell
