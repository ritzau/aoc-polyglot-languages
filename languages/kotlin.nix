{
  pkgs,
  base,
  justfilePath ? null,
}:
{
  devShell = base.mkLanguageShell {
    name = "Kotlin";
    emoji = "🟣";
    languageTools = with pkgs; [
      jdk21
      kotlin
      gradle
    ];
    extraShellHook =
      if justfilePath != null then
        ''
          export JUSTFILE_KOTLIN="${justfilePath}"
          # Create a cache directory and symlink to language justfile
          mkdir -p .cache
          if [ ! -L .cache/kotlin.justfile ]; then
            ln -sf "${justfilePath}" .cache/kotlin.justfile
            echo "📋 Linked .cache/kotlin.justfile to language definition"
          fi
        ''
      else
        "";
  };

  mkStandardOutputs =
    args:
    base.mkSolution {
      language = "kotlin";
      package = base.buildFunctions.simpleCompiler {
        compiler = pkgs.kotlin;
        fileExtensions = [ "kt" ];
        compileCmd = "kotlinc *.kt -include-runtime -d hello-kotlin.jar";
      } args;
    };
}
