{
  description = "Hello World JavaScript";

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
            nodejs_20
          ];

          shellHook = ''
            echo "🟨 Hello JavaScript Environment"
            echo "Run: node hello.js"
          '';
        };

        apps.default = {
          type = "app";
          program = "${pkgs.nodejs_20}/bin/node";
          args = [ "${./hello.js}" ];
        };
      });
}
