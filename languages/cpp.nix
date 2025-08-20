{
  pkgs,
  base,
  justfilePath ? null,
}:
{
  devShell = base.mkLanguageShell {
    name = "C++";
    emoji = "⚡";
    languageTools = with pkgs; [
      gcc
      clang
      cmake
      ninja
      gdb
      pkg-config
      clang-tools
    ];
    extraShellHook =
      if justfilePath != null then
        ''
          export JUSTFILE_CPP="${justfilePath}"
          # Create a cache directory and symlink to language justfile
          mkdir -p .cache
          if [ ! -L .cache/cpp.justfile ]; then
            ln -sf "${justfilePath}" .cache/cpp.justfile
            echo "📋 Linked .cache/cpp.justfile to language definition"
          fi
        ''
      else
        "";
  };

  mkStandardOutputs =
    args:
    base.mkSolution {
      language = "cpp";
      package = base.buildFunctions.cmakeBuild {
        buildInputs = with pkgs; [ gcc ];
      } args;
    };
}
