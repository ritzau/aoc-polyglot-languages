{
  description = "Haskell environment for AOC solutions";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        haskellPackages = pkgs.haskell.packages.ghc964;
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            haskellPackages.ghc
            haskellPackages.cabal-install
            haskellPackages.ghcid
            haskellPackages.haskell-language-server
            haskellPackages.hlint
            haskellPackages.ormolu
          ];

          shellHook = ''
            echo "λ Haskell AOC Environment"
            echo "Available commands:"
            echo "  runhaskell Solution.hs  - Run the solution"
            echo "  ghcid                   - Interactive development"
            echo "  hlint Solution.hs       - Linting"
            echo "  ormolu Solution.hs      - Format code"
          '';
        };
      });
}