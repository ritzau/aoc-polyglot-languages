{
  pkgs,
  base,
  justfilePath ? null,
}:
let
  devShell = base.mkLanguageShell {
    name = "Scala";
    emoji = "🎭";
    languageTools = with pkgs; [
      jdk21
      scala
      sbt
    ];
    extraShellHook =
      if justfilePath != null then
        ''
          export JUSTFILE_SCALA="${justfilePath}"
          # Create a cache directory and symlink to language justfile
          mkdir -p .cache
          if [ ! -L .cache/scala.justfile ]; then
            ln -sf "${justfilePath}" .cache/scala.justfile
            echo "📋 Linked .cache/scala.justfile to language definition"
          fi
        ''
      else
        "";
  };

  solution =
    args:
    base.mkSolution {
      language = "scala";
      package = base.buildFunctions.simpleCompiler {
        compiler = pkgs.scala;
        fileExtensions = [ "scala" ];
        compileCmd = "scalac *.scala && jar cfe hello-scala.jar Main *.class";
      } (args // { pkgs = pkgs; });
    };
in
{
  mkStandardOutputs = args: (solution args) // { devShells.default = devShell; };
}
