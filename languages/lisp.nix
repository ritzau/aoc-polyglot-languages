{
  pkgs,
  base,
  justfilePath ? null,
}:
let
  devShell = base.mkLanguageShell {
    name = "Lisp";
    emoji = "🔥";
    languageTools = with pkgs; [
      sbcl # Steel Bank Common Lisp
      clisp # GNU Common Lisp
    ];
    extraShellHook =
      if justfilePath != null then
        ''
          export JUSTFILE_LISP="${justfilePath}"
          # Create a cache directory and symlink to language justfile
          mkdir -p .cache
          if [ ! -L .cache/lisp.justfile ]; then
            ln -sf "${justfilePath}" .cache/lisp.justfile
            echo "📋 Linked .cache/lisp.justfile to language definition"
          fi
        ''
      else
        "";
  };

  solution =
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
      } (args // { pkgs = pkgs; });
    };
in
{
  mkStandardOutputs = args: (solution args) // { devShells.default = devShell; };
}
