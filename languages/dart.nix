{
  pkgs,
  base,
  justfilePath ? null,
}:
{
  devShell = base.mkLanguageShell {
    name = "Dart";
    emoji = "🎯";
    languageTools = with pkgs; [
      dart
    ];
    extraShellHook =
      if justfilePath != null then
        ''
          export JUSTFILE_DART="${justfilePath}"
          # Create a cache directory and symlink to language justfile
          mkdir -p .cache
          if [ ! -L .cache/dart.justfile ]; then
            ln -sf "${justfilePath}" .cache/dart.justfile
            echo "📋 Linked .cache/dart.justfile to language definition"
          fi
        ''
      else
        "";
  };

  mkStandardOutputs =
    args:
    base.mkSolution {
      language = "dart";
      package = base.buildFunctions.interpreter {
        interpreter = pkgs.dart;
        fileExtensions = [ "dart" ];
      } args;
    };
}
