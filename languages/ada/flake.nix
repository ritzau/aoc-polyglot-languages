{
  description = "Ada environment for AOC solutions";

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
            gnat
            gprbuild
            gdb
          ];

          shellHook = ''
            echo "🏛️ Ada AOC Environment"
            echo "Available commands:"
            echo "  gnatmake solution.adb"
            echo "  gprbuild solution.gpr"
            echo "  gnatclean solution"
            echo "  gdb ./solution"
          '';
        };
      });
}
