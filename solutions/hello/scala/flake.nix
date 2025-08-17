{
  description = "Hello World Scala";

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
            scala_3
            sbt
          ];

          shellHook = ''
            echo "🎭 Hello Scala Environment"
            echo "Run: scala Hello.scala"
          '';
        };

        apps.default = {
          type = "app";
          program = "${pkgs.writeShellScript "run-scala" ''
            ${pkgs.scala_3}/bin/scala ${./Hello.scala}
          ''}";
        };
      });
}