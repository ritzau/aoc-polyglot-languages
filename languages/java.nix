{ pkgs, base }:
let
  justfile = base.mkJustfile "java";
in
{
  devShell = base.mkLanguageShell {
    name = "Java";
    emoji = "☕";
    languageTools = with pkgs; [
      jdk21
      gradle
      maven
    ];
    extraShellHook = ''
      if [ ! -f justfile ]; then
        cp ${justfile} justfile
        echo "📋 Copied Java-specific justfile"
      fi
    '';
  };

  mkStandardOutputs =
    args:
    base.mkSolution {
      language = "java";
      package = base.buildFunctions.simpleCompiler {
        compiler = pkgs.jdk21;
        fileExtensions = [ "java" ];
        compileCmd = "javac *.java && jar cfe hello-java.jar Main *.class";
      } ({ inherit pkgs; } // args);
    };
}
