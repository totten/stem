/**
 * Build a Docker image (with the packages from `profile.nix`).
 *
 * NOTE: `docker.nix` does not provide an optimal workflow for customization.
 * Even with `streamLayerdImage`, it tends to involve hefty layers that will
 * eat through disk. `shell.nix` is much more agreeable to iterative tweaking.
 * `docker.nix` would be useful after customization -- for sharing prebuilt
 * images.
 *
 * To build an image and load it into Docker, run these commands:
 *
 * 1. Build and load the image file
 *    $(nix-build nix/docker.nix) | docker load
 *
 * 2. Start a container from this image
 *    docker run -v $(pwd):/stem -it stem:latest
 *
 * Or do it all as one step:
 *
 *   $(nix-build nix/docker.nix) | docker load && docker run -v $(pwd):/stem -it stem:latest
 *
 * You can open additional shells into the same system:
 *
 *   docker exec -it XXX loco shell
 */

{ pkgs ? import <nixpkgs> {} }:

let

  buildkit = (import ./buildkit.nix) { inherit pkgs; };
  envPkgs = buildkit.pins.v2305; ## Future: buildkit.pins.default
  profile = ((import ./profile.nix) { inherit buildkit; isDocker = true; });
  dockerTools = envPkgs.dockerTools;

  baseImg = dockerTools.buildImage {
    name = "stem-base";
    tag = "latest";
    created = "now";

    copyToRoot = with dockerTools; [
      usrBinEnv
      binSh
      caCertificates
    ];
    
    runAsRoot = ''
      #!${envPkgs.runtimeShell}
      ${dockerTools.shadowSetup}
      groupadd -g 1000 stem
      useradd -u 1000 --home-dir /stem -g stem stem
      mkdir /tmp
      chmod 1777 /tmp
      mkdir /stem
      chown 1000:1000 /stem
    '';

  };

  runImg = dockerTools.streamLayeredImage {
    name = "stem";
    tag = "latest";
    created = "now";
    fromImage = baseImg;
    contents = profile;

    config = {
      User = "1000:1000";
      Env = [ "STEM_HOME=/stem" "TZDIR=${buildkit.pkgs.tzdata}" ];
      WorkingDir = "/stem";
      # Cmd = [ "${envPkgs.bashInteractive}/bin/bash" ];
      Cmd = [ "${buildkit.pkgs.loco}/bin/loco" "shell" ];
      # Cmd = [ "${buildkit.pkgs.loco}/bin/loco" "run" ];
      ## 1. Need to test more with 'loco run'
      ## 2. Can we bake-in the volume list and port list?
      ##    Easy if we just hard-code to match loco.yml defaults.
      ##    Harder if we need to support customized `env.yml`.
      ##    Worst case, I guess one could do a wrapper command
      ##    ("stem docker start" ==> "docker run -it stem:latest -v FOO -p FOO")
      ##    or maybe auto-gen a thin container (`Dockerfile` => `FROM stem:latest EXPOSE nnn`).
      ##    In any case, needs to be tested.
    };
  };

in runImg
