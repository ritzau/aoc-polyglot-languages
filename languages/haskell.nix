{
  pkgs,
  base,
  justfilePath ? null,
}:
let
  haskellPackages = pkgs.haskellPackages;
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
    extraShellHook =
      if justfilePath != null then
        ''
          export JUSTFILE_HASKELL="${justfilePath}"
          # Create a cache directory and symlink to language justfile
          mkdir -p .cache
          if [ ! -L .cache/haskell.justfile ]; then
            ln -sf "${justfilePath}" .cache/haskell.justfile
            echo "📋 Linked .cache/haskell.justfile to language definition"
          fi
        ''
      else
        "";
  };

  mkStandardOutputs =
    args:
    base.mkSolution {
      language = "haskell";
      package = base.buildFunctions.simpleCompiler {
        compiler = haskellPackages.ghc;
        fileExtensions = [ "hs" ];
        compileCmd = "ghc -o hello-haskell *.hs";
      } args;
    };
}
