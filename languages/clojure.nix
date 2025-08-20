{
  pkgs,
  base,
  justfilePath ? null,
}:
let
  devShell = base.mkLanguageShell {
    name = "Clojure";
    emoji = "🔁";
    languageTools = with pkgs; [
      clojure
      openjdk
    ];
    extraShellHook =
      if justfilePath != null then
        ''
          export JUSTFILE_CLOJURE="${justfilePath}"
          # Create a cache directory and symlink to language justfile
          mkdir -p .cache
          if [ ! -L .cache/clojure.justfile ]; then
            ln -sf "${justfilePath}" .cache/clojure.justfile
            echo "📋 Linked .cache/clojure.justfile to language definition"
          fi
        ''
      else
        "";
  };

  solution =
    args:
    base.mkSolution {
      language = "clojure";
      package = base.buildFunctions.scriptRunner {
        interpreter = pkgs.clojure;
        fileExtensions = [ "clj" ];
        interpreterName = "clojure";
        runtimeInputs = [ pkgs.openjdk ];
      } (args // { pkgs = pkgs; });
    };
in
{
  mkStandardOutputs = args: (solution args) // { devShells.default = devShell; };
}
