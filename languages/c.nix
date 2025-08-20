{
  pkgs,
  base,
  justfilePath ? null,
}:
{
  devShell = base.mkLanguageShell {
    name = "C";
    emoji = "🔧";
    languageTools = with pkgs; [
      gcc
      clang
      gnumake
      gdb
      pkg-config
      clang-tools
    ];
    extraShellHook =
      if justfilePath != null then
        ''
          export JUSTFILE_C="${justfilePath}"
          # Create a cache directory and symlink to language justfile
          mkdir -p .cache
          if [ ! -L .cache/c.justfile ]; then
            ln -sf "${justfilePath}" .cache/c.justfile
            echo "📋 Linked .cache/c.justfile to language definition"
          fi
        ''
      else
        "";
  };

  mkStandardOutputs =
    args:
    base.mkSolution {
      language = "c";
      package = base.buildFunctions.makeBuild {
        buildInputs = with pkgs; [ gcc ];
      } ({ inherit pkgs; } // args);
    };
}
