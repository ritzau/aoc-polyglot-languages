{
  description = "Swift environment for AOC solutions";

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
            name = "Swift";
            emoji = "🦉";
            languageTools = with baseLib.pkgs; [
              swift
              swiftPackages.Foundation
              swiftformat
            ];
          };

          # Export mkSolution for Swift solutions to use
          lib = {
            # Wrapper that provides the language name automatically
            mkSolution = args: baseLib.mkSolution ({
              language = "swift";
              languageFlake = self;
            } // args);
            inherit (baseLib) pkgs;
          };
        }) // {
      # Complete solution outputs - eliminates all boilerplate
      mkStandardOutputs = { src ? ./., pname ? "hello-swift", ... }@args:
        flake-utils.lib.eachDefaultSystem (system:
          let
            pkgs = self.lib.${system}.pkgs;
            # Default package that uses swiftc
            defaultPackage = pkgs.stdenv.mkDerivation {
              pname = pname;
              version = "0.1.0";
              src = src;
              nativeBuildInputs = with pkgs; [ swift ];
              buildPhase = ''
                # Find .swift files and compile them
                swiftfile=$(find . -maxdepth 1 -name "*.swift" | head -1)
                if [ -n "$swiftfile" ]; then
                  swiftc -o ${pname} "$swiftfile"
                else
                  echo "No .swift files found"
                  exit 1
                fi
              '';
              installPhase = ''
                mkdir -p $out/bin
                cp ${pname} $out/bin/
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
