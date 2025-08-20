{
  description = "Objective-C environment for AOC solutions";

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
          name = "Objective-C";
          emoji = "🍎";
          languageTools = with baseLib.pkgs; [
            clang
            gnustep-base
            gnustep-make
          ];
        };

        # Export mkSolution for Objective-C solutions to use
        lib = {
          # Wrapper that provides the language name automatically
          mkSolution =
            args:
            baseLib.mkSolution (
              {
                language = "objc";
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
          pname ? "hello-objc",
          ...
        }@args:
        flake-utils.lib.eachDefaultSystem (
          system:
          let
            pkgs = self.lib.${system}.pkgs;
            # Default package that creates a wrapper script for Objective-C
            defaultPackage = pkgs.stdenv.mkDerivation {
              pname = pname;
              version = "0.1.0";
              src = src;
              nativeBuildInputs = [
                pkgs.clang
                pkgs.gnustep-base
                pkgs.gnustep-make
              ];
              buildPhase = ''
                # Find the objective-c file in the source directory
                objcfile=$(find . -maxdepth 1 -name "*.m" | head -1)
                if [ -n "$objcfile" ]; then
                  clang -framework Foundation "$objcfile" -o ${pname}
                else
                  echo "No Objective-C files found in ${src}"
                  exit 1
                fi
              '';
              installPhase = ''
                mkdir -p $out/bin
                cp ${pname} $out/bin/
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
