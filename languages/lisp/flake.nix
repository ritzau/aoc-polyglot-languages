{
  description = "Lisp environment for AOC solutions";

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
            name = "Lisp";
            emoji = "🔥";
            languageTools = with baseLib.pkgs; [
              sbcl # Steel Bank Common Lisp
              clisp # GNU Common Lisp
            ];
          };

          # Export mkSolution for Lisp solutions to use
          lib = {
            # Wrapper that provides the language name automatically
            mkSolution = args: baseLib.mkSolution ({
              language = "lisp";
              languageFlake = self;
            } // args);
            inherit (baseLib) pkgs;
          };
        }) // {
      # Complete solution outputs - eliminates all boilerplate
      mkStandardOutputs = { src ? ./., pname ? "hello-lisp", ... }@args:
        flake-utils.lib.eachDefaultSystem (system:
          let
            pkgs = self.lib.${system}.pkgs;
            # Default package that creates a wrapper script for Lisp
            defaultPackage = pkgs.writeShellApplication {
              name = pname;
              runtimeInputs = [ pkgs.sbcl ];
              text = ''
                # Find the lisp file in the source directory
                lispfile=$(find ${src} -maxdepth 1 -name "*.lisp" -o -name "*.cl" | head -1)
                if [ -n "$lispfile" ]; then
                  exec sbcl --script "$lispfile" "$@"
                else
                  echo "No Lisp files found in ${src}"
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
