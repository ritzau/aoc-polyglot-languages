{
  description = "COBOL environment for AOC solutions";

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
          name = "COBOL";
          emoji = "🏢";
          languageTools = with baseLib.pkgs; [
            gnucobol
          ];
        };

        # Export mkSolution for COBOL solutions to use
        lib = {
          # Wrapper that provides the language name automatically
          mkSolution =
            args:
            baseLib.mkSolution (
              {
                language = "cobol";
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
          pname ? "hello-cobol",
          ...
        }@args:
        flake-utils.lib.eachDefaultSystem (
          system:
          let
            pkgs = self.lib.${system}.pkgs;
            # Default package that creates a wrapper script for COBOL
            defaultPackage = pkgs.writeShellApplication {
              name = pname;
              runtimeInputs = [ pkgs.gnucobol ];
              text = ''
                # Find the COBOL file in the source directory
                cobolfile=$(find ${src} -maxdepth 1 -name "*.cob" -o -name "*.cobol" -o -name "*.cbl" | head -1)
                if [ -n "$cobolfile" ]; then
                  # Compile and run
                  temp_exe=$(mktemp)
                  cobc -x "$cobolfile" -o "$temp_exe"
                  exec "$temp_exe" "$@"
                else
                  echo "No COBOL files found in ${src}"
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
