{ pkgs, base }:
let
  justfile = base.mkJustfile "clojure";
in
{
  devShell = base.mkLanguageShell {
    name = "Clojure";
    emoji = "🔁";
    languageTools = with pkgs; [
      clojure
      openjdk
    ];
    extraShellHook = ''
      if [ ! -f justfile ]; then
        cp ${justfile} justfile
        echo "📋 Copied Clojure-specific justfile"
      fi
    '';
  };

  mkStandardOutputs =
    args:
    base.mkSolution {
      language = "clojure";
      package = base.buildFunctions.scriptRunner {
        interpreter = pkgs.clojure;
        fileExtensions = [ "clj" ];
        interpreterName = "clojure";
        runtimeInputs = [ pkgs.openjdk ];
      } ({ inherit pkgs; } // args);
    };
}
