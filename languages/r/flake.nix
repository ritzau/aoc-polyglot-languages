{
  description = "R environment for AOC solutions";

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
          name = "R";
          emoji = "📊";
          languageTools = with baseLib.pkgs; [
            R
          ];
        };

        # Export mkSolution for R solutions to use
        lib = {
          # Wrapper that provides the language name automatically
          mkSolution =
            args:
            baseLib.mkSolution (
              {
                language = "r";
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
          pname ? "hello-r",
          ...
        }@args:
        flake-utils.lib.eachDefaultSystem (
          system:
          let
            pkgs = self.lib.${system}.pkgs;
            # Default package that creates a wrapper script for R
            defaultPackage = pkgs.writeShellApplication {
              name = pname;
              runtimeInputs = [ pkgs.R ];
              text = ''
                # Find the R file in the source directory
                rfile=$(find ${src} -maxdepth 1 -name "*.R" -o -name "*.r" | head -1)
                if [ -n "$rfile" ]; then
                  exec Rscript "$rfile" "$@"
                else
                  echo "No R files found in ${src}"
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
