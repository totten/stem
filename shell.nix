/**
 * Define a shell environment for working on CiviCRM.
 *
 * To run this, simply call `nix-shell`.
 *
 * SEE ALSO: ./nix/profile.nix
 */

{ pkgs ? import <nixpkgs> {} }:

let

  buildkit = (import ./nix/buildkit.nix) { inherit pkgs; };
  envPkgs = buildkit.pins.default;
  profile = (import ./nix/profile.nix) { inherit buildkit; };

  shell = envPkgs.mkShell {
    name = "stem";
    buildInputs = profile;
    shellHook = ''
      export STEM_HOME="$PWD"
      eval $(loco env --export)
      source ${envPkgs.bash-completion}/etc/profile.d/bash_completion.sh
    '';
  };

in shell
