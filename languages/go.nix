{
  pkgs,
  base,
  justfilePath ? null,
}:
{
  devShell = base.mkLanguageShell {
    name = "Go";
    emoji = "🐹";
    languageTools = with pkgs; [
      go
      gopls
      gofumpt
      golangci-lint
    ];
    extraShellHook =
      if justfilePath != null then
        ''
          export JUSTFILE_GO="${justfilePath}"
          # Create a cache directory and symlink to language justfile
          mkdir -p .cache
          if [ ! -L .cache/go.justfile ]; then
            ln -sf "${justfilePath}" .cache/go.justfile
            echo "📋 Linked .cache/go.justfile to language definition"
          fi
        ''
      else
        "";
  };

  mkStandardOutputs =
    args:
    base.mkSolution {
      language = "go";
      package = base.buildFunctions.buildSystem (
        buildArgs:
        pkgs.buildGoModule (
          {
            version = "0.1.0";
            vendorHash = null; # For simple AOC solutions
          }
          // buildArgs
        )
      ) args;
    };
}
