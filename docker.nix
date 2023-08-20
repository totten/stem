/**
 * Build a Docker image for the current profile
 *
 * To build an image and load it into Docker, run:
 *
 * - Build and load the image file
 *   $(nix-build docker.nix) | docker load
 *
 * - Start a container from this image
 *   docker run -v $(pwd):/stem -it stem:latest /bin/bash
 *
 * Or do this all as one step:
 *
 *   $(nix-build docker.nix) | docker load && docker run -v $(pwd):/stem -it stem:latest /bin/bash
 *
 * And you can enter the shell multiple times:
 *
 *   docker exec -it XXX /bin/bash
 *
 * Within shell, you still need do some navigating
 *
 *   cd /stem && STEM_HOME=$PWD loco shell
 *
 * TODO: Make the default env+cmd more like ^^^
 * TODO: Maybe split the images into separate files/build steps - so to reuse the heavy one
 */

{ pkgs ? import <nixpkgs> {} }:

let

  buildkit = (import ./buildkit.nix) { inherit pkgs; };
  basePkgs = buildkit.pins.v2305; ## Future: buildkit.pins.default
  profile = ((import ./profile.nix) { inherit buildkit; pkgs = basePkgs; isDocker = true; });
  dockerTools = basePkgs.dockerTools;

/*
  shell = basePkgs.mkShell {
    name = "stem";
    buildInputs = profile;
    shellHook = ''
      export STEM_HOME="$PWD"
      export PATH="$STEM_HOME/bin:$PATH"
      eval $(loco env --export)
      source ${basePkgs.bash-completion}/etc/profile.d/bash_completion.sh
    '';
  };
*/

    nonRootShadowSetup = { user, uid, gid ? uid }: with pkgs; [
      (
      writeTextDir "etc/shadow" ''
        root:!x:::::::
        ${user}:!:::::::
      ''
      )
      (
      writeTextDir "etc/passwd" ''
        root:x:0:0::/root:${runtimeShell}
        ${user}:x:${toString uid}:${toString gid}::/home/${user}:
      ''
      )
      (
      writeTextDir "etc/group" ''
        root:x:0:
        ${user}:x:${toString gid}:
      ''
      )
      (
      writeTextDir "etc/gshadow" ''
        root:x::
        ${user}:x::
      ''
      )
    ];

  baseImg = dockerTools.buildImage {
    name = "stem-base";
    tag = "latest";
    created = "now";

    copyToRoot = with dockerTools; [
      usrBinEnv
      binSh
      caCertificates
      #fakeNss
    ];
    
    runAsRoot = ''
      #!${pkgs.runtimeShell}
      ${dockerTools.shadowSetup}
      groupadd -g 1000 stem
      useradd -u 1000 -g stem stem
      mkdir /tmp
      chmod 1777 /tmp
    '';
  };

in dockerTools.streamLayeredImage {

  name = "stem";
  tag = "latest";
  created = "now";

  fromImage = baseImg;
#  fromImageName = null;
#  fromImageTag = "latest";

  contents = profile;

#  contents = with dockerTools; [
#    usrBinEnv
#    binSh
#    caCertificates
#    #fakeNss
#  # shell ];
#  ] ++ profile;
#  # ++ (nonRootShadowSetup {uid = 1000; user = "stem";});

  config = {
    Cmd = [ "${basePkgs.bashInteractive}/bin/bash" ];
    User = "1000:1000";
  };

/*
  #enableFakechroot = true;
*/
/*
  extraCommands = ''
    #!${basePkgs.stdenv.shell}
  '';
*/

}
