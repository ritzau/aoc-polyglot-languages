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
          name = "TypeScript";
          emoji = "🔷";
          languageTools = with baseLib.pkgs; [
            nodejs_20
            typescript
          ];
        };
        lib.mkSolution =
          args:
          baseLib.mkSolution (
            {
              language = "typescript";
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
              compiler = base.lib.${system}.pkgs.typescript;
              fileExtensions = [ "ts" ];
              compileCmd = "tsc *.ts --outDir dist && node dist/*.js";
            } ({ pkgs = base.lib.${system}.pkgs; } // args);
          }
        );
    };
}
