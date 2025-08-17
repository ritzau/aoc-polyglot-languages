{
  description = "Zig environment for AOC solutions";

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
            zig
            zls
          ];

          shellHook = ''
            echo "⚡ Zig AOC Environment"
            echo "Available commands:"
            echo "  zig run solution.zig"
            echo "  zig build-exe solution.zig"
            echo "  zig test solution.zig"
            echo "  zig fmt solution.zig"
          '';
        };
      });
}