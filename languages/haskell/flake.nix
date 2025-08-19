{
  description = "Haskell environment for AOC solutions";

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
          haskellPackages = baseLib.pkgs.haskell.packages.ghc964;
        in
        {
          devShells.default = baseLib.mkLanguageShell {
            name = "Haskell";
            emoji = "λ";
            languageTools = [
              haskellPackages.ghc
              haskellPackages.cabal-install
              haskellPackages.ghcid
              haskellPackages.haskell-language-server
              haskellPackages.hlint
              haskellPackages.ormolu
            ];
          };

          # Export mkSolution for Haskell solutions to use
          lib = {
            # Wrapper that provides the language name automatically
            mkSolution = args: baseLib.mkSolution ({
              language = "haskell";
              languageFlake = self;
            } // args);
            inherit (baseLib) pkgs;
            inherit haskellPackages;
          };
        }) // {
      # Complete solution outputs - eliminates all boilerplate
      mkStandardOutputs = { src ? ./., pname ? "hello-haskell", ... }@args:
        flake-utils.lib.eachDefaultSystem (system:
          let
            pkgs = self.lib.${system}.pkgs;
            haskellPackages = self.lib.${system}.haskellPackages;
            # Default package that uses ghc
            defaultPackage = pkgs.stdenv.mkDerivation {
              pname = pname;
              version = "0.1.0";
              src = src;
              nativeBuildInputs = [ haskellPackages.ghc ];
              buildPhase = ''
                # Find .hs files and compile them
                hsfile=$(find . -maxdepth 1 -name "*.hs" | head -1)
                if [ -n "$hsfile" ]; then
                  ghc -o ${pname} "$hsfile"
                else
                  echo "No .hs files found"
                  exit 1
                fi
              '';
              installPhase = ''
                mkdir -p $out/bin
                cp ${pname} $out/bin/
              '';
            };
            # Remove src and pname from args to pass to mkSolution
            cleanArgs = builtins.removeAttrs args [ "src" "pname" ];
          in
          self.lib.${system}.mkSolution ({
            package = defaultPackage;
          } // cleanArgs));
    };
}
