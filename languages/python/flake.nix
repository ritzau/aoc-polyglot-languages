{
  description = "Python environment for AOC solutions";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        python = pkgs.python311;
        pythonPackages = python.pkgs;
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
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

          shellHook = ''
            echo "🐍 Python AOC Environment"
            echo "Available commands:"
            echo "  python solution.py  - Run the solution"
            echo "  pytest              - Run tests"
            echo "  black .             - Format code"
            echo "  mypy solution.py    - Type check"
          '';
        };
      });
}