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
          name = "Go";
          emoji = "🐹";
          languageTools = with baseLib.pkgs; [
            go
            gopls
            golangci-lint
            gotools
            air
          ];
        };
        lib.mkSolution =
          args:
          baseLib.mkSolution (
            {
              language = "go";
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
            package = base.lib.${system}.buildFunctions.buildSystem (
              buildArgs:
              base.lib.${system}.pkgs.buildGoModule (
                {
                  version = "0.1.0";
                  vendorHash = null;
                }
                // buildArgs
              )
            ) ({ pkgs = base.lib.${system}.pkgs; } // args);
          }
        );
    };
}
