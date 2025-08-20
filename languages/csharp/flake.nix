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
          name = "C#";
          emoji = "🔷";
          languageTools = with baseLib.pkgs; [
            dotnet-sdk_8
            mono
            omnisharp-roslyn
          ];
        };
        lib.mkSolution =
          args:
          baseLib.mkSolution (
            {
              language = "csharp";
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
              compiler = base.lib.${system}.pkgs.mono;
              fileExtensions = [ "cs" ];
              compileCmd = "mcs -out:hello-csharp.exe *.cs";
            } ({ pkgs = base.lib.${system}.pkgs; } // args);
          }
        );
    };
}
