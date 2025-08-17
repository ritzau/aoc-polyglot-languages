{
  description = "Hello World Nim";

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
            nim
            nimble
          ];

          shellHook = ''
            echo "👑 Hello Nim Environment"
            echo "Run: nim r hello.nim"
          '';
        };

        packages.default = pkgs.stdenv.mkDerivation {
          pname = "hello-nim";
          version = "0.1.0";
          src = ./.;
          nativeBuildInputs = [ pkgs.nim ];
          buildPhase = ''
            nim c hello.nim
          '';
          installPhase = ''
            mkdir -p $out/bin
            cp hello $out/bin/hello-nim
          '';
        };

        apps.default = {
          type = "app";
          program = "${pkgs.writeShellScript "run-nim" ''
            ${pkgs.nim}/bin/nim r ${./hello.nim}
          ''}";
        };
      });
}
