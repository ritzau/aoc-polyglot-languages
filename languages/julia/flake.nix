{
  description = "Julia environment for AOC solutions";

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
            name = "Julia";
            emoji = "🔢";
            languageTools = with baseLib.pkgs; [
              julia
            ];
          };

          # Export mkSolution for Julia solutions to use
          lib = {
            # Wrapper that provides the language name automatically
            mkSolution = args: baseLib.mkSolution ({
              language = "julia";
              languageFlake = self;
            } // args);
            inherit (baseLib) pkgs;
          };
        }) // {
      # Complete solution outputs - eliminates all boilerplate
      mkStandardOutputs = { src ? ./., pname ? "hello-julia", ... }@args:
        flake-utils.lib.eachDefaultSystem (system:
          let
            pkgs = self.lib.${system}.pkgs;
            # Default package that creates a wrapper script for Julia
            defaultPackage = pkgs.writeShellApplication {
              name = pname;
              runtimeInputs = [ pkgs.julia ];
              text = ''
                # Find the julia file in the source directory
                juliafile=$(find ${src} -maxdepth 1 -name "*.jl" | head -1)
                if [ -n "$juliafile" ]; then
                  exec julia "$juliafile" "$@"
                else
                  echo "No .jl files found in ${src}"
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
