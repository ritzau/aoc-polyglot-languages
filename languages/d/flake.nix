{
  description = "D environment for AOC solutions";

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
            name = "D";
            emoji = "🎯";
            languageTools = with baseLib.pkgs; [
              ldc
              dub
              gdb
            ];
          };

          # Export mkSolution for D solutions to use
          lib = {
            # Wrapper that provides the language name automatically
            mkSolution = args: baseLib.mkSolution ({
              language = "d";
              languageFlake = self;
            } // args);
            inherit (baseLib) pkgs;
          };
        }) // {
      # Complete solution outputs - eliminates all boilerplate
      mkStandardOutputs = { src ? ./., pname ? "hello-d", ... }@args:
        flake-utils.lib.eachDefaultSystem (system:
          let
            pkgs = self.lib.${system}.pkgs;
            # Default package that uses ldc2
            defaultPackage = pkgs.stdenv.mkDerivation {
              pname = pname;
              version = "0.1.0";
              src = src;
              nativeBuildInputs = with pkgs; [ ldc ];
              buildPhase = ''
                # Find .d files and compile them
                dfile=$(find . -maxdepth 1 -name "*.d" | head -1)
                if [ -n "$dfile" ]; then
                  ldc2 -of=${pname} "$dfile"
                else
                  echo "No .d files found"
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
