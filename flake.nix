{
  inputs = {
    # Use a github flake URL for real packages
    # cargo2nix.url = "github:cargo2nix/cargo2nix/release-0.11.0";
    flake-utils.follows = "cargo2nix/flake-utils";
    nixpkgs.follows = "cargo2nix/nixpkgs";

    cargo2nix. url = "github:cargo2nix/cargo2nix";
  };

  outputs = { flake-utils, nixpkgs, cargo2nix, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let

        pkgs = import nixpkgs {
          inherit system;
          overlays = [ cargo2nix.overlays.default ];
        };

        rustPkgs = pkgs.rustBuilder.makePackageSet {
          rustVersion = "1.75.0";
          packageFun = import ./Cargo.nix;
        };
      in
      rec {
        packages = {
          madsim-br = (rustPkgs.workspace.madsim-br { });
          default = packages.madsim-br;
        };
      }
    );
}
