{
  description = "Tcl environment for AOC solutions";

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
            tcl
            tk
          ];

          shellHook = ''
            echo "🎭 Tcl AOC Environment"
            echo "Available commands:"
            echo "  tclsh solution.tcl"
            echo "  wish solution.tcl  (for Tk GUI)"
            echo "  tclsh < solution.tcl"
          '';
        };
      });
}
