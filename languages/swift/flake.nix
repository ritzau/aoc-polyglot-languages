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
          name = "Swift";
          emoji = "🦉";
          languageTools = with baseLib.pkgs; [ swift ];
        };
        lib.mkSolution =
          args:
          baseLib.mkSolution (
            {
              language = "swift";
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
              compiler = base.lib.${system}.pkgs.swift;
              fileExtensions = [ "swift" ];
              compileCmd = "swiftc *.swift -o hello-swift";
            } ({ pkgs = base.lib.${system}.pkgs; } // args);
          }
        );
    };
}
