{
  pkgs,
  base,
  justfilePath ? null,
}:
let
  devShell = base.mkLanguageShell {
    name = "Tcl";
    emoji = "🪶";
    languageTools = with pkgs; [
      tcl
    ];
    extraShellHook =
      if justfilePath != null then
        ''
          export JUSTFILE_TCL="${justfilePath}"
          # Create a cache directory and symlink to language justfile
          mkdir -p .cache
          if [ ! -L .cache/tcl.justfile ]; then
            ln -sf "${justfilePath}" .cache/tcl.justfile
            echo "📋 Linked .cache/tcl.justfile to language definition"
          fi
        ''
      else
        "";
  };

  solution =
    args:
    base.mkSolution {
      language = "tcl";
      package = base.buildFunctions.scriptRunner {
        interpreter = pkgs.tcl;
        fileExtensions = [ "tcl" ];
        interpreterName = "tclsh";
      } (args // { pkgs = pkgs; });
    };
in
{
  mkStandardOutputs = args: (solution args) // { devShells.default = devShell; };
}
