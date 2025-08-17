{
  description = "Hello World Swift";

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
          ];

          shellHook = ''
            echo "🦉 Hello Swift Environment"
            echo "Run: swift hello.swift"
          '';
        };

        apps.default = {
          type = "app";
          program = "${pkgs.writeShellScript "run-swift" ''
            ${pkgs.swift}/bin/swift ${./hello.swift}
          ''}";
        };
      });
}
