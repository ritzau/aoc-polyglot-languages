{ pkgs, base }:
let
  justfile = base.mkJustfile "javascript";
in
{
  devShell = base.mkLanguageShell {
    name = "JavaScript";
    emoji = "🟨";
    languageTools = with pkgs; [
      nodejs_20
      npm-check-updates
    ];
    extraShellHook = ''
      if [ ! -f justfile ]; then
        cp ${justfile} justfile
        echo "📋 Copied JavaScript-specific justfile"
      fi
    '';
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
