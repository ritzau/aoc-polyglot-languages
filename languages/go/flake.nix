{
  description = "Go environment for AOC solutions";

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
            go_1_21
            gopls
            golangci-lint
            gotools
            air  # Live reload
          ];

          shellHook = ''
            echo "🐹 Go AOC Environment"
            echo "Available commands:"
            echo "  go run main.go      - Run the solution"
            echo "  go test             - Run tests"
            echo "  go fmt              - Format code"
            echo "  golangci-lint run   - Lint code"
            echo "  air                 - Live reload"
          '';
        };
      });
}