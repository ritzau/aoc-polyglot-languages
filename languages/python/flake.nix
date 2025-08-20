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
        python = baseLib.pkgs.python311;
      in
      {
        devShells.default = baseLib.mkLanguageShell {
          name = "Python";
          emoji = "🐍";
          languageTools = with python.pkgs; [
            python
            pip
            pytest
            black
            isort
            mypy
            numpy
            matplotlib
            networkx
            sympy
          ];
        };
        lib.mkSolution =
          args:
          baseLib.mkSolution (
            {
              language = "python";
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
              interpreter = base.lib.${system}.pkgs.python311;
              fileExtensions = [ "py" ];
            } ({ pkgs = base.lib.${system}.pkgs; } // args);
          }
        );
    };
}
