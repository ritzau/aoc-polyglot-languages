{
  pkgs,
  base,
  justfilePath ? null,
}:
let
  devShell = base.mkLanguageShell {
    name = "Java";
    emoji = "☕";
    languageTools = with pkgs; [
      jdk21
      gradle
      maven
    ];
    extraShellHook =
      if justfilePath != null then
        ''
          export JUSTFILE_JAVA="${justfilePath}"
          # Create a cache directory and symlink to language justfile
          mkdir -p .cache
          if [ ! -L .cache/java.justfile ]; then
            ln -sf "${justfilePath}" .cache/java.justfile
            echo "📋 Linked .cache/java.justfile to language definition"
          fi
        ''
      else
        "";
  };

  solution =
    args:
    base.mkSolution {
      language = "java";
      package = base.buildFunctions.simpleCompiler {
        compiler = pkgs.jdk21;
        fileExtensions = [ "java" ];
        compileCmd = "javac *.java && jar cfe hello-java.jar Main *.class";
      } (args // { pkgs = pkgs; });
    };
in
{
  mkStandardOutputs = args: (solution args) // { devShells.default = devShell; };
}
