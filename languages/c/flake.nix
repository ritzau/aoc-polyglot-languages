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
          name = "C";
          emoji = "🔧";
          languageTools = with baseLib.pkgs; [
            gcc
            clang
            gnumake
            gdb
            pkg-config
            clang-tools
          ];
        };
        lib.mkSolution =
          args:
          baseLib.mkSolution (
            {
              language = "c";
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
            package = base.lib.${system}.buildFunctions.makeBuild {
              buildInputs = with base.lib.${system}.pkgs; [ gcc ];
            } ({ pkgs = base.lib.${system}.pkgs; } // args);
          }
        );
    };
}
