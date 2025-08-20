{
  inputs.base.url = "path:/Users/ritzau/src/slask/aoc-nix/languages/base";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs =
    {
      self,
      base,
      flake-utils,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        baseLib = base.lib.${system};
        haskellPackages = baseLib.pkgs.haskellPackages;
      in
      {
        devShells.default = baseLib.mkLanguageShell {
          name = "Haskell";
          emoji = "λ";
          languageTools = with haskellPackages; [
            ghc
            cabal-install
            ghcid
            haskell-language-server
            hlint
            ormolu
          ];
        };
        lib.mkSolution =
          args:
          baseLib.mkSolution (
            {
              language = "haskell";
              languageFlake = self;
            }
            // args
          );
      }
    )
    // {
      mkStandardOutputs =
        args:
        flake-utils.lib.eachDefaultSystem (
          system:
          self.lib.${system}.mkSolution {
            package = base.lib.${system}.buildFunctions.simpleCompiler {
              compiler = base.lib.${system}.pkgs.haskellPackages.ghc;
              fileExtensions = [ "hs" ];
              compileCmd = "ghc -o hello-haskell *.hs";
            } ({ pkgs = base.lib.${system}.pkgs; } // args);
          }
        );
    };
}
