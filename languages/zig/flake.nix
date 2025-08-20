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
          name = "Zig";
          emoji = "⚡";
          languageTools = with baseLib.pkgs; [
            zig
            zls
          ];
        };
        lib.mkSolution =
          args:
          baseLib.mkSolution (
            {
              language = "zig";
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
              compiler = base.lib.${system}.pkgs.zig;
              fileExtensions = [ "zig" ];
              compileCmd = "export HOME=$TMPDIR ZIG_LOCAL_CACHE_DIR=$TMPDIR/zig-cache ZIG_GLOBAL_CACHE_DIR=$TMPDIR/zig-cache && mkdir -p $TMPDIR/zig-cache && zig build-exe *.zig -femit-bin=hello-zig --cache-dir $TMPDIR/zig-cache";
            } ({ pkgs = base.lib.${system}.pkgs; } // args);
          }
        );
    };
}
