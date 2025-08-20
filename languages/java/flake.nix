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
          name = "Java";
          emoji = "☕";
          languageTools = with baseLib.pkgs; [
            jdk21
            gradle
            maven
          ];
        };
        lib.mkSolution =
          args:
          baseLib.mkSolution (
            {
              language = "java";
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
              compiler = base.lib.${system}.pkgs.jdk21;
              fileExtensions = [ "java" ];
              compileCmd = "javac *.java && jar cfe hello-java.jar Main *.class";
            } ({ pkgs = base.lib.${system}.pkgs; } // args);
          }
        );
    };
}
