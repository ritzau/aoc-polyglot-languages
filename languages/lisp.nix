{ pkgs, base }:
let
  justfile = base.mkJustfile "lisp";
in
{
  devShell = base.mkLanguageShell {
    name = "Lisp";
    emoji = "🔥";
    languageTools = with pkgs; [
      sbcl # Steel Bank Common Lisp
      clisp # GNU Common Lisp
    ];
    extraShellHook = ''
      if [ ! -f justfile ]; then
        cp ${justfile} justfile
        echo "📋 Copied Lisp-specific justfile"
      fi
    '';
  };

  mkStandardOutputs =
    args:
    base.mkSolution {
      language = "lisp";
      package = base.buildFunctions.scriptRunner {
        interpreter = pkgs.sbcl;
        fileExtensions = [
          "lisp"
          "cl"
        ];
        interpreterName = "sbcl";
        interpreterArgs = [ "--script" ];
      } args;
    };
}
