{
  description = "Hello World Python";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        python = pkgs.python311;
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            python
            pythonPackages.black
          ];

          shellHook = ''
            echo "🐍 Hello Python Environment"
            echo "Run: python hello.py"
          '';
        };

        apps.default = {
          type = "app";
          program = "${python}/bin/python";
          args = [ "${./hello.py}" ];
        };
      });
}