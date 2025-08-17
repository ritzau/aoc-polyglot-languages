{
  description = "Hello World D";

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
            dmd
            ldc
            dub
          ];

          shellHook = ''
            echo "🎯 Hello D Environment"
            echo "Run: dmd hello.d"
          '';
        };

        packages.default = pkgs.stdenv.mkDerivation {
          pname = "hello-d";
          version = "0.1.0";
          src = ./.;
          nativeBuildInputs = [ pkgs.dmd ];
          buildPhase = ''
            dmd hello.d
          '';
          installPhase = ''
            mkdir -p $out/bin
            cp hello $out/bin/hello-d
          '';
        };

        apps.default = {
          type = "app";
          program = "${self.packages.${system}.default}/bin/hello-d";
        };
      });
}
