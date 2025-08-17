{
  description = "Hello World Java";

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
          ];

          shellHook = ''
            echo "☕ Hello Java Environment"
            echo "Run: javac Hello.java && java Hello"
          '';
        };

        apps.default = {
          type = "app";
          program = "${pkgs.writeShellScript "run-java" ''
            cd ${./.}
            ${pkgs.jdk21}/bin/javac Hello.java
            ${pkgs.jdk21}/bin/java Hello
          ''}";
        };
      });
}
