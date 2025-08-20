{ pkgs, base }:
let
  justfile = base.mkJustfile "tcl";
in
{
  devShell = base.mkLanguageShell {
    name = "Tcl";
    emoji = "🪶";
    languageTools = with pkgs; [
      tcl
    ];
    extraShellHook = ''
      if [ ! -f justfile ]; then
        cp ${justfile} justfile
        echo "📋 Copied Tcl-specific justfile"
      fi
    '';
  };

  mkStandardOutputs =
    args:
    base.mkSolution {
      language = "tcl";
      package = base.buildFunctions.scriptRunner {
        interpreter = pkgs.tcl;
        fileExtensions = [ "tcl" ];
        interpreterName = "tclsh";
      } ({ inherit pkgs; } // args);
    };
}
