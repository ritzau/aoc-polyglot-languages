{
  pkgs,
  base,
  justfilePath ? null,
}:
{
  devShell = base.mkLanguageShell {
    name = "Nim";
    emoji = "👑";
    languageTools = with pkgs; [
      nim
    ];
    extraShellHook =
      if justfilePath != null then
        ''
          export JUSTFILE_NIM="${justfilePath}"
          # Create a cache directory and symlink to language justfile
          mkdir -p .cache
          if [ ! -L .cache/nim.justfile ]; then
            ln -sf "${justfilePath}" .cache/nim.justfile
            echo "📋 Linked .cache/nim.justfile to language definition"
          fi
        ''
      else
        "";
  };

  mkStandardOutputs =
    args:
    base.mkSolution {
      language = "nim";
      package = base.buildFunctions.simpleCompiler {
        compiler = pkgs.nim;
        fileExtensions = [ "nim" ];
        compileCmd = "nim compile --verbosity:0 -o:hello-nim *.nim";
      } args;
    };
}
