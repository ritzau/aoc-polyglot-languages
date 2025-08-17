{
  description = "Hello World TypeScript";

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
            nodePackages.typescript
            nodePackages.ts-node
          ];

          shellHook = ''
            echo "📘 Hello TypeScript Environment"
            echo "Run: ts-node hello.ts"
          '';
        };

        apps.default = {
          type = "app";
          program = "${pkgs.writeShellScript "run-typescript" ''
            ${pkgs.nodePackages.ts-node}/bin/ts-node ${./hello.ts}
          ''}";
        };
      });
}