{ pkgs, base }:
let
  justfile = base.mkJustfile "smalltalk";
in
{
  devShell = base.mkLanguageShell {
    name = "Smalltalk";
    emoji = "💬";
    languageTools = with pkgs; [
      gnu-smalltalk
    ];
    extraShellHook = ''
      if [ ! -f justfile ]; then
        cp ${justfile} justfile
        echo "📋 Copied Smalltalk-specific justfile"
      fi
    '';
  };

  mkStandardOutputs =
    args:
    base.mkSolution {
      language = "smalltalk";
      package = base.buildFunctions.scriptRunner {
        interpreter = pkgs.gnu-smalltalk;
        fileExtensions = [ "st" ];
        interpreterName = "gst";
        interpreterArgs = [ "-f" ];
      } args;
    };
}
