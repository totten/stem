{ buildkit, isDocker ? false }:

let

  pkgs = buildkit.pins.default;

  dockerAddons = [
    pkgs.nano
    pkgs.joe
    pkgs.ps
  ];

in

  ## Define the packages that we want. This may use:
  ##
  ## Profiles (curated set of packages used by CI)
  ##   buildkit.profiles.min  (Low versions of PHP/MySQL)
  ##   buildkit.profiles.max  (High versions of PHP/MySQL)
  ##   buildkit.profiles.edge (Future versions of PHP/MySQL)
  ##   buildkit.profiles.dfl
  ##   buildkit.profiles.alt
  ##
  ## Specific packages from buildkit
  ##   buildkit.pkgs.php73
  ##   buildkit.pkgs.php81
  ##   buildkit.pkgs.composer
  ##
  ## Specific packages from upstream releases of nixpkgs (as used by buildkit)
  ##   buildkit.pins.v2205.composer
  ##   buildkit.pins.v2305.composer
  ##   buildkit.pins.v2305.php81
  ##
  ## Helper functions
  ##   (buildkit.funcs.fetchPhar { name = ...; url = ...; sha256 = ...; })

  buildkit.profiles.dfl ++ [
    buildkit.pkgs.composer
    buildkit.pkgs.pogo
    buildkit.pkgs.loco
    buildkit.pkgs.phpunit8
    buildkit.pkgs.phpunit9
    buildkit.pkgs.coworker
    buildkit.pkgs.cv
    buildkit.pkgs.civix

    pkgs.bash-completion
    pkgs.bashInteractive
    pkgs.gzip
    
  ] ++ (if isDocker then dockerAddons else [])
