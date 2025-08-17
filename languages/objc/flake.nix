{
  description = "Objective-C environment for AOC solutions";

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
            clang
            gnustep-base
            gnustep-make
            libobjc
          ];

          shellHook = ''
            echo "🍎 Objective-C AOC Environment"
            echo "Available commands:"
            echo "  clang -framework Foundation solution.m -o solution"
            echo "  gcc `gnustep-config --objc-flags` solution.m -o solution"
            echo "  ./solution"
          '';
        };
      });
}
