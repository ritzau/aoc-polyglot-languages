{
  pkgs,
  base,
  justfilePath ? null,
}:
{
  devShell = base.mkLanguageShell {
    name = "C#";
    emoji = "🔷";
    languageTools = with pkgs; [
      dotnet-sdk_8
      mono
      omnisharp-roslyn
    ];
    extraShellHook =
      if justfilePath != null then
        ''
          export JUSTFILE_CSHARP="${justfilePath}"
          # Create a cache directory and symlink to language justfile
          mkdir -p .cache
          if [ ! -L .cache/csharp.justfile ]; then
            ln -sf "${justfilePath}" .cache/csharp.justfile
            echo "📋 Linked .cache/csharp.justfile to language definition"
          fi
        ''
      else
        "";
  };

  mkStandardOutputs =
    args:
    base.mkSolution {
      language = "csharp";
      package = base.buildFunctions.simpleCompiler {
        compiler = pkgs.mono;
        fileExtensions = [ "cs" ];
        compileCmd = "mcs -out:hello-csharp.exe *.cs";
      } args;
    };
}
