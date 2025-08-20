{ pkgs, base }:
let
  justfile = base.mkJustfile "scala";
in
{
  devShell = base.mkLanguageShell {
    name = "Scala";
    emoji = "🎭";
    languageTools = with pkgs; [
      jdk21
      scala
      sbt
    ];
    extraShellHook = ''
      if [ ! -f justfile ]; then
        cp ${justfile} justfile
        echo "📋 Copied Scala-specific justfile"
      fi
    '';
  };

  mkStandardOutputs =
    args:
    base.mkSolution {
      language = "scala";
      package = base.buildFunctions.simpleCompiler {
        compiler = pkgs.scala;
        fileExtensions = [ "scala" ];
        compileCmd = "scalac *.scala && jar cfe hello-scala.jar Main *.class";
      } ({ inherit pkgs; } // args);
    };
}
