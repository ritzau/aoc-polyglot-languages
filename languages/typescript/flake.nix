{
  description = "TypeScript environment for AOC solutions";

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
            nodePackages.eslint
            nodePackages.prettier
            nodePackages."@types/node"
            bun
            deno
          ];

          shellHook = ''
            echo "📘 TypeScript AOC Environment"
            echo "Available commands:"
            echo "  ts-node solution.ts"
            echo "  tsc solution.ts && node solution.js"
            echo "  bun run solution.ts"
            echo "  deno run solution.ts"
            echo "  prettier --write solution.ts"
          '';
        };
      });
}
