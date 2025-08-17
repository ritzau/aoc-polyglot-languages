{
  description = "Hello World C++";

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
            gcc
            clang
            cmake
            ninja
          ];

          shellHook = ''
            echo "⚡ Hello C++ Environment"
            echo "Run: g++ -std=c++20 -O2 hello.cpp -o hello-cpp"
          '';
        };

        packages.default = pkgs.stdenv.mkDerivation {
          pname = "hello-cpp";
          version = "0.1.0";
          src = ./.;
          nativeBuildInputs = [ pkgs.cmake pkgs.gcc ];
          buildPhase = ''
            g++ -std=c++20 -O2 hello.cpp -o hello-cpp
          '';
          installPhase = ''
            mkdir -p $out/bin
            cp hello-cpp $out/bin/
          '';
        };

        apps.default = {
          type = "app";
          program = "${pkgs.writeShellScript "run-cpp" ''
            cd ${./.}
            ${pkgs.gcc}/bin/g++ -std=c++20 -O2 hello.cpp -o hello-cpp
            ./hello-cpp
          ''}";
        };
      });
}