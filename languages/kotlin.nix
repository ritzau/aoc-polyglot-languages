{
  pkgs,
  base,
  justfilePath ? null,
}:
let
  devShell = base.mkLanguageShell {
    name = "Kotlin";
    emoji = "🟣";
    languageTools = with pkgs; [
      jdk21
      kotlin
      gradle
    ];
    extraShellHook =
      if justfilePath != null then
        ''
          export JUSTFILE_KOTLIN="${justfilePath}"
          # Create a cache directory and symlink to language justfile
          mkdir -p .cache
          if [ ! -L .cache/kotlin.justfile ]; then
            ln -sf "${justfilePath}" .cache/kotlin.justfile
            echo "📋 Linked .cache/kotlin.justfile to language definition"
          fi
        ''
      else
        "";
  };

  solution =
    args:
    let
      # Extract JDK package from args, default to jdk21
      selectedJdk = args.jdk or pkgs.jdk21;
    in
    base.mkSolution {
      language = "kotlin";
      package = base.buildFunctions.kotlinBuild {
        mainClass = "HelloKt";
        jdk = selectedJdk;
      } (args // { pkgs = pkgs; });
    };
in
{
  mkStandardOutputs = args: (solution args) // { devShells.default = devShell; };
}
