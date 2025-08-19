{
  description = "Dart environment for AOC solutions";

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
            name = "Dart";
            emoji = "🎯";
            languageTools = with baseLib.pkgs; [
              dart
              flutter
            ];
          };

          # Export mkSolution for Dart solutions to use
          lib = {
            # Wrapper that provides the language name automatically
            mkSolution = args: baseLib.mkSolution ({
              language = "dart";
              languageFlake = self;
            } // args);
            inherit (baseLib) pkgs;
          };
        }) // {
      # Complete solution outputs - eliminates all boilerplate
      mkStandardOutputs = { src ? ./., pname ? "hello-dart", ... }@args:
        flake-utils.lib.eachDefaultSystem (system:
          let
            pkgs = self.lib.${system}.pkgs;
            # Default package that creates a wrapper script
            defaultPackage = pkgs.writeShellApplication {
              name = pname;
              runtimeInputs = [ pkgs.dart ];
              text = ''
                # Find the dart file in the source directory
                dartfile=$(find ${src} -maxdepth 1 -name "*.dart" | head -1)
                if [ -n "$dartfile" ]; then
                  exec dart "$dartfile" "$@"
                else
                  echo "No .dart files found in ${src}"
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
