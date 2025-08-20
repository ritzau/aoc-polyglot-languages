{ pkgs, base }:
let
  haskellPackages = pkgs.haskellPackages;
  justfile = base.mkJustfile "haskell";
in
{
  devShell = base.mkLanguageShell {
    name = "Haskell";
    emoji = "λ";
    languageTools = with haskellPackages; [
      ghc
      cabal-install
      ghcid
      haskell-language-server
      hlint
      ormolu
    ];
    extraShellHook = ''
      if [ ! -f justfile ]; then
        cp ${justfile} justfile
        echo "📋 Copied Haskell-specific justfile"
      fi
    '';
  };

  mkStandardOutputs =
    args:
    base.mkSolution {
      language = "haskell";
      package = base.buildFunctions.simpleCompiler {
        compiler = haskellPackages.ghc;
        fileExtensions = [ "hs" ];
        compileCmd = "ghc -o hello-haskell *.hs";
      } ({ inherit pkgs; } // args);
    };
}
