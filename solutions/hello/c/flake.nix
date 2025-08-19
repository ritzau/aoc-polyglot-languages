{
  description = "Hello World C";

  inputs = {
    base.url = "path:/Users/ritzau/src/slask/aoc-nix/solutions/base";
    c-lang.url = "path:/Users/ritzau/src/slask/aoc-nix/languages/c";
  };

  outputs = { self, base, c-lang }:
    base.inputs.flake-utils.lib.eachDefaultSystem (system:
      let
        baseLib = base.lib.${system};
        package = baseLib.pkgs.stdenv.mkDerivation {
          pname = "hello-c";
          version = "0.1.0";
          src = ./.;
          nativeBuildInputs = [ baseLib.pkgs.gcc baseLib.pkgs.gnumake ];
          buildPhase = ''
            make
          '';
          installPhase = ''
            install -D hello-c $out/bin/hello-c
          '';
        };
      in
      baseLib.mkSolution {
        language = "c";
        description = "Hello World C";
        languageFlake = c-lang;
        package = package;
      });
}
