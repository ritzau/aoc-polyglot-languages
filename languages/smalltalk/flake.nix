{
  description = "Smalltalk environment for AOC solutions";

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
            gnu-smalltalk
          ];

          shellHook = ''
            echo "💬 Smalltalk AOC Environment"
            echo "Available commands:"
            echo "  gst solution.st"
            echo "  gst -f solution.st"
            echo "  gst -i  (interactive)"
          '';
        };
      });
}