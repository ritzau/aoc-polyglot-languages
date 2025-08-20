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
          name = "Fortran";
          emoji = "🏗️";
          languageTools = [ baseLib.pkgs.gfortran ];
        };
        lib.mkSolution =
          args:
          baseLib.mkSolution (
            {
              language = "fortran";
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
              compiler = base.lib.${system}.pkgs.gfortran;
              fileExtensions = [
                "f90"
                "f95"
                "f"
              ];
              compileCmd = "gfortran *.f90 -o hello-fortran || gfortran *.f95 -o hello-fortran || gfortran *.f -o hello-fortran";
            } ({ pkgs = base.lib.${system}.pkgs; } // args);
          }
        );
    };
}
