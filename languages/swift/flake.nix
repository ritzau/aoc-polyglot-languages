{
  description = "Swift environment for AOC solutions";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            swift
            swiftPackages.Foundation
            swiftformat
          ];

          shellHook = ''
            echo "🦉 Swift AOC Environment"
            echo "Available commands:"
            echo "  swift solution.swift"
            echo "  swiftc solution.swift -o solution"
            echo "  swift package init --type executable"
            echo "  swiftformat solution.swift"
          '';
        };
      });
}