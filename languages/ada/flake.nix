{
  description = "Ada environment for AOC solutions";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    base = {
      url = "path:/Users/ritzau/src/slask/aoc-nix/languages/base";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      base,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        baseLib = base.lib.${system};
      in
      {
        devShells.default = baseLib.mkLanguageShell {
          name = "Ada";
          emoji = "🏛️";
          languageTools = with baseLib.pkgs; [
            gnat
            gprbuild
          ];
        };

        # Export mkSolution for Ada solutions to use
        lib = {
          # Wrapper that provides the language name automatically
          mkSolution =
            args:
            baseLib.mkSolution (
              {
                language = "ada";
                languageFlake = self;
              }
              // args
            );
          inherit (baseLib) pkgs;
        };
      }
    )
    // {
      # Complete solution outputs - eliminates all boilerplate
      mkStandardOutputs =
        {
          src ? ./.,
          pname ? "hello-ada",
          ...
        }@args:
        flake-utils.lib.eachDefaultSystem (
          system:
          let
            pkgs = self.lib.${system}.pkgs;
            # Default package that creates a wrapper script for Ada
            defaultPackage = pkgs.stdenv.mkDerivation {
              pname = pname;
              version = "0.1.0";
              src = src;
              nativeBuildInputs = [ pkgs.gnat ];
              buildPhase = ''
                # Find the ada file in the source directory
                adafile=$(find . -maxdepth 1 -name "*.adb" | head -1)
                if [ -n "$adafile" ]; then
                  gnatmake "$adafile"
                else
                  echo "No Ada files found in ${src}"
                  exit 1
                fi
              '';
              installPhase = ''
                mkdir -p $out/bin
                # Find the compiled executable (without .adb extension)
                exe=$(find . -maxdepth 1 -type f -executable ! -name "*.adb" ! -name "*.ali" ! -name "*.o" | head -1)
                if [ -n "$exe" ]; then
                  cp "$exe" $out/bin/${pname}
                else
                  echo "No executable found"
                  exit 1
                fi
              '';
            };
            # Remove src and pname from args to pass to mkSolution
            cleanArgs = builtins.removeAttrs args [
              "src"
              "pname"
            ];
          in
          self.lib.${system}.mkSolution (
            {
              package = defaultPackage;
            }
            // cleanArgs
          )
        );
    };
}
