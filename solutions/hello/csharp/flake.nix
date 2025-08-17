{
  description = "Hello World C#";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    csharp-lang = {
      url = "path:/Users/ritzau/src/slask/aoc-nix/languages/csharp";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
  };

  outputs = { self, nixpkgs, flake-utils, csharp-lang }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        # Use the language flake's dev shell directly
        devShells.default = csharp-lang.devShells.${system}.default;

        packages.default = pkgs.stdenv.mkDerivation {
          pname = "hello-csharp";
          version = "0.1.0";
          src = ./.;
          nativeBuildInputs = [ pkgs.mono ];
          buildPhase = ''
            mcs Hello.cs -out:hello-csharp.exe
          '';
          installPhase = ''
                        install -D hello-csharp.exe $out/bin/hello-csharp.exe
                        cat > $out/bin/hello-csharp << EOF
            #!/bin/sh
            exec ${pkgs.mono}/bin/mono $out/bin/hello-csharp.exe "\$@"
            EOF
                        chmod +x $out/bin/hello-csharp
          '';
        };

        apps.default = {
          type = "app";
          program = "${self.packages.${system}.default}/bin/hello-csharp";
        };
      });
}
