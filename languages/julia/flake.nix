{
  description = "Julia environment for AOC solutions";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            julia
          ];

          shellHook = ''
            echo "🔢 Julia AOC Environment"
            echo "Available commands:"
            echo "  julia solution.jl"
            echo "  julia --project=. solution.jl"
            echo "  julia -O3 solution.jl"
            echo "  julia> using Pkg; Pkg.test()"
          '';
        };
      });
}