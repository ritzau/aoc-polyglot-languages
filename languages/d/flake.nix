{
  description = "D environment for AOC solutions";

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
            ldc
            dub
            gdb
          ];

          shellHook = ''
            echo "🎯 D AOC Environment (LDC only)"
            echo "Available commands:"
            echo "  ldc2 solution.d"
            echo "  dub run"
          '';
        };
      });
}
