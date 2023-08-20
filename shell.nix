/**
 * Inherit from buildkit's nix configuration. Add a few extra packages.
 */

{ pkgs ? import <nixpkgs> {} }:

let

  buildkit = import (pkgs.fetchFromGitHub {
    owner = "totten";
    repo = "civicrm-buildkit";
    rev = "153371e9bdcb22392b878cca545df0888fb61925";
    sha256 = "sha256-rdwmA4uqIqfqXu2f+ewVH0Gs/BzcB13p8oRbbTdUsAs=";
    ## TODO: See if we can track master without needing to lock-in revisions
  });

  ## If you're trying to patch buildkit at the sametime, then use a local copy:
  # buildkit = import ((builtins.getEnv "HOME") + "/buildkit/default.nix");
  # buildkit = import ((builtins.getEnv "HOME") + "/bknix/default.nix");
  
  fetchPhar = buildkit.funcs.fetchPhar;

in

  pkgs.mkShell {
    nativeBuildInputs = buildkit.profiles.dfl ++ [

      buildkit.pkgs.composer
      buildkit.pkgs.pogo
      buildkit.pkgs.loco
      buildkit.pkgs.phpunit8
      buildkit.pkgs.phpunit9
      
      ## TODO: Move these to buildkit:nix/pkgs/default.nix
      (fetchPhar {
        name = "cv";
        url = "https://download.civicrm.org/cv/cv-0.3.47.phar";
        sha256 = "sha256-q/pzWbB8IhD/rV3d/o3nQCNXc9RTGoG02cq7+YXUkc4=";
      })
      (fetchPhar {
        name = "civix";
        url = "https://download.civicrm.org/civix/civix-23.08.0.phar";
        sha256 = "sha256-HaniHKvnI406AwDU696/abpAmnhUT7y4vnrg7K6jMV0=";
      })

      pkgs.bash-completion
    ];
    shellHook = ''
      export SKIT_HOME="$PWD"
      export PATH="$SKIT_HOME/bin:$PATH"
      eval $(loco env --export)
      source ${pkgs.bash-completion}/etc/profile.d/bash_completion.sh
    '';
  }
