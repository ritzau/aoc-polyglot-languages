{
  description = "Hello World Dart";

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
            dart
            flutter
          ];

          shellHook = ''
            echo "🎯 Hello Dart Environment"
            echo "Run: dart hello.dart"
          '';
        };

        apps.default = {
          type = "app";
          program = "${pkgs.dart}/bin/dart";
          args = [ "${./hello.dart}" ];
        };
      });
}