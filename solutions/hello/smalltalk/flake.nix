{
  description = "Hello World Smalltalk";

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
            echo "💬 Hello Smalltalk Environment"
            echo "Run: gst hello.st"
          '';
        };

        apps.default = {
          type = "app";
          program = "${pkgs.gnu-smalltalk}/bin/gst";
          args = [ "${./hello.st}" ];
        };
      });
}
