{
  description = "Hello World Java";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    java-lang = {
      url = "path:/Users/ritzau/src/slask/aoc-nix/languages/java";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
  };

  outputs = { self, nixpkgs, flake-utils, java-lang }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        # Use the language flake's dev shell directly
        devShells.default = java-lang.devShells.${system}.default;

        apps.default = {
          type = "app";
          program = "${pkgs.writeShellScript "run-java" ''
            cd ${./.}
            ${pkgs.jdk21}/bin/javac Hello.java
            ${pkgs.jdk21}/bin/java Hello
          ''}";
        };
      });
}
