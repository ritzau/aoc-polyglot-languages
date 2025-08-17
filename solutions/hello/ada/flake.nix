{
  description = "Hello World Ada";

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
            gnat
            gprbuild
          ];

          shellHook = ''
            echo "🏛️ Hello Ada Environment"
            echo "Run: gnatmake hello.adb"
          '';
        };

        packages.default = pkgs.stdenv.mkDerivation {
          pname = "hello-ada";
          version = "0.1.0";
          src = ./.;
          nativeBuildInputs = [ pkgs.gnat ];
          buildPhase = ''
            gnatmake hello.adb
          '';
          installPhase = ''
            mkdir -p $out/bin
            cp hello $out/bin/hello-ada
          '';
        };

        apps.default = {
          type = "app";
          program = "${self.packages.${system}.default}/bin/hello-ada";
        };
      });
}
