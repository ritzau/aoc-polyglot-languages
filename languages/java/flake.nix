{
  description = "Java environment for AOC solutions";

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
            jdk21
            gradle
            maven
          ];

          shellHook = ''
            echo "☕ Java AOC Environment"
            echo "Available commands:"
            echo "  javac Solution.java && java Solution"
            echo "  gradle run"
            echo "  mvn compile exec:java"
            echo "  java --version: $(java --version | head -1)"
          '';
        };
      });
}