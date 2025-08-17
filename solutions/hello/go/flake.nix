{
  description = "Hello World Go";

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
            go_1_21
          ];

          shellHook = ''
            echo "🐹 Hello Go Environment"
            echo "Run: go run main.go"
          '';
        };

        packages.default = pkgs.buildGoModule {
          pname = "hello-go";
          version = "0.1.0";
          src = ./.;
          vendorHash = null;
        };

        apps.default = {
          type = "app";
          program = "${self.packages.${system}.default}/bin/hello-go";
        };
      });
}
