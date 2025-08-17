{
  description = "C++ environment for AOC solutions";

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
            gcc
            clang
            cmake
            ninja
            gdb
            pkg-config
          ];

          shellHook = ''
            echo "⚡ C++ AOC Environment"
            echo "Available commands:"
            echo "  g++ -std=c++20 -O2 solution.cpp -o solution"
            echo "  clang++ -std=c++20 -O2 solution.cpp -o solution"
            echo "  cmake . && make"
            echo "  gdb ./solution"
          '';
        };
      });
}
