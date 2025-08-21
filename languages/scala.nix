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
    let
      # Extract JDK version from args, default to jdk21
      jdkVersion = args.jdk or "jdk21";
      selectedJdk = pkgs.${jdkVersion};
    in
    base.mkSolution {
      language = "scala";
      package = base.buildFunctions.scalaBuild {
        mainClass = "Hello";
        jdk = selectedJdk;
      } (args // { pkgs = pkgs; });
    };
in
{
  mkStandardOutputs = args: (solution args) // { devShells.default = devShell; };
}
