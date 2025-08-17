{
  description = "JavaScript/TypeScript environment for AOC solutions";

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
            nodePackages.npm
            nodePackages.typescript
            nodePackages.ts-node
            nodePackages.eslint
            nodePackages.prettier
            nodePackages."@types/node"
          ];

          shellHook = ''
            echo "🟨 JavaScript/TypeScript AOC Environment"
            echo "Available commands:"
            echo "  node solution.js        - Run JS solution"
            echo "  ts-node solution.ts     - Run TS solution"
            echo "  npm test                - Run tests"
            echo "  eslint solution.ts      - Lint code"
            echo "  prettier solution.ts    - Format code"
          '';
        };
      });
}
