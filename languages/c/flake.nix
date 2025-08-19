{
  description = "C environment for AOC solutions";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    base = {
      url = "path:/Users/ritzau/src/slask/aoc-nix/languages/base";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
  };

  outputs = { self, nixpkgs, flake-utils, base }:
    flake-utils.lib.eachDefaultSystem
      (system:
        let
          baseLib = base.lib.${system};
        in
        {
          devShells.default = baseLib.mkLanguageShell {
            name = "C";
            emoji = "🔧";
            languageTools = with baseLib.pkgs; [
              gcc
              clang
              gnumake
              gdb
              pkg-config
              clang-tools # includes clang-format and clang-tidy
            ];
          };

          # Export mkSolution for C solutions to use
          lib = {
            # Wrapper that provides the language name automatically
            mkSolution = args: baseLib.mkSolution ({
              language = "c";
              languageFlake = self;
            } // args);
            inherit (baseLib) pkgs;
          };
        }) // {
      # Complete solution outputs - eliminates all boilerplate
      mkStandardOutputs = args: flake-utils.lib.eachDefaultSystem (system:
        let
          pkgs = self.lib.${system}.pkgs;
          # Default package that uses just build
          defaultPackage = pkgs.stdenv.mkDerivation {
            pname = "hello-c";
            version = "0.1.0";
            src = ./.;
            nativeBuildInputs = with pkgs; [ just gcc gnumake ];
            buildPhase = ''
              just build
            '';
            installPhase = ''
              mkdir -p $out/bin
              find . -name "hello-c" -executable -type f -exec cp {} $out/bin/ \;
            '';
          };
        in
        self.lib.${system}.mkSolution ({
          package = defaultPackage;
        } // args));
    };
}
