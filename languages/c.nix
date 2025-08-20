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
          # Create a language justfile that can be imported
          if [ ! -f .justfile-c ]; then
            cp "${justfilePath}" .justfile-c
            echo "📋 Created .justfile-c from language definition"
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
