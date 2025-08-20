{
  pkgs,
  base,
  justfilePath ? null,
}:
{
  devShell = base.mkLanguageShell {
    name = "JavaScript";
    emoji = "🟨";
    languageTools = with pkgs; [
      nodejs_20
      npm-check-updates
    ];
    extraShellHook =
      if justfilePath != null then
        ''
          export JUSTFILE_JAVASCRIPT="${justfilePath}"
          # Create a cache directory and symlink to language justfile
          mkdir -p .cache
          if [ ! -L .cache/javascript.justfile ]; then
            ln -sf "${justfilePath}" .cache/javascript.justfile
            echo "📋 Linked .cache/javascript.justfile to language definition"
          fi
        ''
      else
        "";
  };

  mkStandardOutputs =
    args:
    base.mkSolution {
      language = "javascript";
      package = base.buildFunctions.interpreter {
        interpreter = pkgs.nodejs_20;
        fileExtensions = [ "js" ];
      } args;
    };
}
