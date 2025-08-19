{
  description = "Fortran environment for AOC solutions";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    base = {
      url = "path:/Users/ritzau/src/slask/aoc-nix/languages/base";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
  };

  outputs = { self, nixpkgs, flake-utils, base }:
    flake-utils.lib.eachDefaultSystem
      (system:
        let
          baseLib = base.lib.${system};
        in
        {
          devShells.default = baseLib.mkLanguageShell {
            name = "Fortran";
            emoji = "🏗️";
            languageTools = with baseLib.pkgs; [
              gfortran
            ];
          };

          # Export mkSolution for Fortran solutions to use
          lib = {
            # Wrapper that provides the language name automatically
            mkSolution = args: baseLib.mkSolution ({
              language = "fortran";
              languageFlake = self;
            } // args);
            inherit (baseLib) pkgs;
          };
        }) // {
      # Complete solution outputs - eliminates all boilerplate
      mkStandardOutputs = { src ? ./., pname ? "hello-fortran", ... }@args:
        flake-utils.lib.eachDefaultSystem (system:
          let
            pkgs = self.lib.${system}.pkgs;
            # Default package that creates a wrapper script for Fortran
            defaultPackage = pkgs.writeShellApplication {
              name = pname;
              runtimeInputs = [ pkgs.gfortran ];
              text = ''
                # Find the fortran file in the source directory
                fortranfile=$(find ${src} -maxdepth 1 -name "*.f90" -o -name "*.f95" -o -name "*.f" | head -1)
                if [ -n "$fortranfile" ]; then
                  # Compile and run
                  temp_exe=$(mktemp)
                  gfortran "$fortranfile" -o "$temp_exe"
                  exec "$temp_exe" "$@"
                else
                  echo "No Fortran files found in ${src}"
                  exit 1
                fi
              '';
            };
            # Remove src and pname from args to pass to mkSolution
            cleanArgs = builtins.removeAttrs args [ "src" "pname" ];
          in
          self.lib.${system}.mkSolution ({
            package = defaultPackage;
          } // cleanArgs));
    };
}
