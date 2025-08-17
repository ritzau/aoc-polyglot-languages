{
  description = "C environment for AOC solutions";

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
            gnumake
            gdb
            pkg-config
          ];

          shellHook = ''
            echo "🔧 C AOC Environment"
            echo "Available commands:"
            echo "  gcc -std=c11 -O2 solution.c -o solution"
            echo "  clang -std=c11 -O2 solution.c -o solution"
            echo "  make"
            echo "  gdb ./solution"
          '';
        };
      });
}
