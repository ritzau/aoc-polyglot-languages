{
  pkgs,
  base,
  justfilePath ? null,
}:
{
  devShell = base.mkLanguageShell {
    name = "PHP";
    emoji = "🐘";
    languageTools = with pkgs; [
      php
    ];
    extraShellHook =
      if justfilePath != null then
        ''
          export JUSTFILE_PHP="${justfilePath}"
          # Create a cache directory and symlink to language justfile
          mkdir -p .cache
          if [ ! -L .cache/php.justfile ]; then
            ln -sf "${justfilePath}" .cache/php.justfile
            echo "📋 Linked .cache/php.justfile to language definition"
          fi
        ''
      else
        "";
  };

  mkStandardOutputs =
    args:
    base.mkSolution {
      language = "php";
      package = pkgs.writeShellApplication {
        name = args.pname or "hello-php";
        runtimeInputs = [ pkgs.php ];
        text = ''
          # Find the php file in the source directory
          phpfile=$(find ${args.src or ./.} -maxdepth 1 -name "*.php" | head -1)
          if [ -n "$phpfile" ]; then
            exec php "$phpfile" "$@"
          else
            echo "No PHP files found in ${args.src or ./.}"
            exit 1
          fi
        '';
      };
    };
}
