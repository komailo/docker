{
  description = "A flake for Nanobot AI image";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config = {
            allowUnfree = true;
            permittedInsecurePackages = [
              "olm-3.2.16"
            ];
          };
        };
      in {
        packages.default = pkgs.symlinkJoin {
          name = "nanobot-toolchain";
          paths = [
            pkgs.python3
            pkgs.python3Packages.pip
            pkgs.nodejs_20
            pkgs.uv
            pkgs.sqlite
            pkgs.cmake
            pkgs.pkg-config
            pkgs.olm
            pkgs.gnumake
            pkgs.gcc
            pkgs.gnutar
            pkgs.gzip
            pkgs.bashInteractive
            pkgs.coreutils
            pkgs.curl
            pkgs.git
            pkgs.cacert # Essential for TLS
          ];
        };
      }
    );
}
