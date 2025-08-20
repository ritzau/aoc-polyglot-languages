{ pkgs, base }:
let
  justfile = base.mkJustfile "kotlin";
in
{
  devShell = base.mkLanguageShell {
    name = "Kotlin";
    emoji = "🟣";
    languageTools = with pkgs; [
      jdk21
      kotlin
      gradle
    ];
    extraShellHook = ''
      if [ ! -f justfile ]; then
        cp ${justfile} justfile
        echo "📋 Copied Kotlin-specific justfile"
      fi
    '';
  };

  mkStandardOutputs =
    args:
    base.mkSolution {
      language = "kotlin";
      package = base.buildFunctions.simpleCompiler {
        compiler = pkgs.kotlin;
        fileExtensions = [ "kt" ];
        compileCmd = "kotlinc *.kt -include-runtime -d hello-kotlin.jar";
      } args;
    };
}
