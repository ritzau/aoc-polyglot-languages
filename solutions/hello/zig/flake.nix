{
  description = "Hello World Zig";

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
            zig
            zls
          ];

          shellHook = ''
            echo "⚡ Hello Zig Environment"
            echo "Run: zig run hello.zig"
          '';
        };

        packages.default = pkgs.stdenv.mkDerivation {
          pname = "hello-zig";
          version = "0.1.0";
          src = ./.;
          nativeBuildInputs = [ pkgs.zig ];
          buildPhase = ''
            zig build-exe hello.zig
          '';
          installPhase = ''
            mkdir -p $out/bin
            cp hello $out/bin/hello-zig
          '';
        };

        apps.default = {
          type = "app";
          program = "${pkgs.writeShellScript "run-zig" ''
            ${pkgs.zig}/bin/zig run ${./hello.zig}
          ''}";
        };
      });
}
