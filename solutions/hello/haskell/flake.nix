{
  description = "Hello World Haskell";

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
          ];

          shellHook = ''
            echo "λ Hello Haskell Environment"
            echo "Run: runhaskell Hello.hs"
          '';
        };

        apps.default = {
          type = "app";
          program = "${pkgs.writeShellScript "run-haskell" ''
            ${haskellPackages.ghc}/bin/runhaskell ${./Hello.hs}
          ''}";
        };
      });
}