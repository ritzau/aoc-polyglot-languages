{
  description = "Hello World Kotlin";

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
            kotlin
          ];

          shellHook = ''
            echo "🎯 Hello Kotlin Environment"
            echo "Run: kotlinc hello.kt -include-runtime -d hello.jar && java -jar hello.jar"
          '';
        };

        apps.default = {
          type = "app";
          program = "${pkgs.writeShellScript "run-kotlin" ''
            cd ${./.}
            ${pkgs.kotlin}/bin/kotlinc hello.kt -include-runtime -d hello.jar
            ${pkgs.jdk21}/bin/java -jar hello.jar
          ''}";
        };
      });
}
