{ pkgs, base }:
let
  justfile = base.mkJustfile "ruby";
in
{
  devShell = base.mkLanguageShell {
    name = "Ruby";
    emoji = "💎";
    languageTools = with pkgs; [
      ruby
    ];
    extraShellHook = ''
      if [ ! -f justfile ]; then
        cp ${justfile} justfile
        echo "📋 Copied Ruby-specific justfile"
      fi
    '';
  };

  mkStandardOutputs =
    args:
    base.mkSolution {
      language = "ruby";
      package = base.buildFunctions.scriptRunner {
        interpreter = pkgs.ruby;
        fileExtensions = [ "rb" ];
        interpreterName = "ruby";
      } ({ inherit pkgs; } // args);
    };
}
