{ pkgs, base }:
let
  justfile = base.mkJustfile "dart";
in
{
  devShell = base.mkLanguageShell {
    name = "Dart";
    emoji = "🎯";
    languageTools = with pkgs; [
      dart
    ];
    extraShellHook = ''
      if [ ! -f justfile ]; then
        cp ${justfile} justfile
        echo "📋 Copied Dart-specific justfile"
      fi
    '';
  };

  mkStandardOutputs =
    args:
    base.mkSolution {
      language = "dart";
      package = base.buildFunctions.interpreter {
        interpreter = pkgs.dart;
        fileExtensions = [ "dart" ];
      } ({ inherit pkgs; } // args);
    };
}
