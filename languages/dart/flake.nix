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
      in
      {
        devShells.default = baseLib.mkLanguageShell {
          name = "Dart";
          emoji = "🎯";
          languageTools = with baseLib.pkgs; [ dart ];
        };
        lib.mkSolution =
          args:
          baseLib.mkSolution (
            {
              language = "dart";
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
            package = base.lib.${system}.buildFunctions.interpreter {
              interpreter = base.lib.${system}.pkgs.dart;
              fileExtensions = [ "dart" ];
            } ({ pkgs = base.lib.${system}.pkgs; } // args);
          }
        );
    };
}
