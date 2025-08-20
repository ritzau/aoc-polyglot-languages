{
  description = "Day 1 Python solution";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        python = pkgs.python311;
        pythonPackages = python.pkgs;
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            python
            pythonPackages.pytest
            pythonPackages.black
            pythonPackages.mypy
          ];

          shellHook = ''
            echo "🐍 Day 1 Python Solution"
            echo "Run: python solution.py"
          '';
        };
      }
    );
}
