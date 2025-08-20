{
  pkgs,
  base,
  justfilePath ? null,
}:
let
  devShell = base.mkLanguageShell {
    name = "Smalltalk";
    emoji = "💬";
    languageTools = with pkgs; [
      gnu-smalltalk
    ];
    extraShellHook =
      if justfilePath != null then
        ''
          export JUSTFILE_SMALLTALK="${justfilePath}"
          # Create a cache directory and symlink to language justfile
          mkdir -p .cache
          if [ ! -L .cache/smalltalk.justfile ]; then
            ln -sf "${justfilePath}" .cache/smalltalk.justfile
            echo "📋 Linked .cache/smalltalk.justfile to language definition"
          fi
        ''
      else
        "";
  };

  solution =
    args:
    base.mkSolution {
      language = "smalltalk";
      package = base.buildFunctions.scriptRunner {
        interpreter = pkgs.gnu-smalltalk;
        fileExtensions = [ "st" ];
        interpreterName = "gst";
        interpreterArgs = [ "-f" ];
      } (args // { pkgs = pkgs; });
    };
in
{
  mkStandardOutputs = args: (solution args) // { devShells.default = devShell; };
}
