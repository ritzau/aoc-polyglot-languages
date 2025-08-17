{
  description = "Hello World Tcl";

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
            echo "🎭 Hello Tcl Environment"
            echo "Run: tclsh hello.tcl"
          '';
        };

        apps.default = {
          type = "app";
          program = "${pkgs.tcl}/bin/tclsh";
          args = [ "${./hello.tcl}" ];
        };
      });
}