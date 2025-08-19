{
  description = "Python environment for AOC solutions";

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
          python = baseLib.pkgs.python311;
          pythonPackages = python.pkgs;
        in
        {
          devShells.default = baseLib.mkLanguageShell {
            name = "Python";
            emoji = "🐍";
            languageTools = [
              python
              pythonPackages.pip
              pythonPackages.pytest
              pythonPackages.black
              pythonPackages.isort
              pythonPackages.mypy
              pythonPackages.numpy
              pythonPackages.matplotlib
              pythonPackages.networkx
              pythonPackages.sympy
            ];
          };

          # Export mkSolution for Python solutions to use
          lib = {
            # Wrapper that provides the language name automatically
            mkSolution = args: baseLib.mkSolution ({
              language = "python";
              languageFlake = self;
            } // args);
            inherit (baseLib) pkgs;
          };
        }) // {
      # Complete solution outputs - eliminates all boilerplate
      mkStandardOutputs = { src ? ./., pname ? "hello-python", ... }@args:
        flake-utils.lib.eachDefaultSystem (system:
          let
            pkgs = self.lib.${system}.pkgs;
            python = pkgs.python311;
            # Default package that uses python interpreter
            defaultPackage = pkgs.stdenv.mkDerivation {
              pname = pname;
              version = "0.1.0";
              src = src;
              nativeBuildInputs = [ python ];
              buildPhase = ''
                # Python scripts don't need compilation, but we can do syntax check
                python -m py_compile *.py
              '';
              installPhase = ''
                                mkdir -p $out/bin
                                # Find .py files and create executable wrapper
                                pyfile=$(find . -maxdepth 1 -name "*.py" | head -1)
                                if [ -n "$pyfile" ]; then
                                  cat > $out/bin/${pname} << EOF
                #!/bin/sh
                exec ${python}/bin/python "\$(dirname "\$0")/../$pyfile" "\$@"
                EOF
                                  chmod +x $out/bin/${pname}
                                  cp "$pyfile" $out/
                                else
                                  echo "No .py files found"
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
