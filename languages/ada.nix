{
  pkgs,
  base,
  justfilePath ? null,
}:
let
  devShell = base.mkLanguageShell {
    name = "Ada";
    emoji = "🏛️";
    languageTools = with pkgs; [
      gnat-bootstrap
      # Note: gprbuild removed as it depends on full gnat compiler
      # which fails to build from source. gnatmake is sufficient for AOC.
    ];
    extraShellHook =
      if justfilePath != null then
        ''
          export JUSTFILE_ADA="${justfilePath}"
          # Create a cache directory and symlink to language justfile
          mkdir -p .cache
          if [ ! -L .cache/ada.justfile ]; then
            ln -sf "${justfilePath}" .cache/ada.justfile
            echo "📋 Linked .cache/ada.justfile to language definition"
          fi
        ''
      else
        "";
  };

  solution =
    args:
    base.mkSolution {
      language = "ada";
      package = base.buildFunctions.simpleCompiler {
        compiler = pkgs.gnat-bootstrap;
        fileExtensions = [ "adb" ];
        compileCmd = ''
          # Find the ada file in the source directory
          adafile=$(find . -maxdepth 1 -name "*.adb" | head -1)
          if [ -n "$adafile" ]; then
            gnatmake "$adafile"
          else
            echo "No Ada files found"
            exit 1
          fi
        '';
      } (args // { pkgs = pkgs; });
    };
in
{
  mkStandardOutputs = args: (solution args) // { devShells.default = devShell; };
  mkDefaultOutputs = args: (solution args) // { devShells.default = devShell; };
}
