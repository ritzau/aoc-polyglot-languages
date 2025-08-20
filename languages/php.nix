{ pkgs, base }:
let
  justfile = base.mkJustfile "php";
in
{
  devShell = base.mkLanguageShell {
    name = "PHP";
    emoji = "🐘";
    languageTools = with pkgs; [
      php
    ];
    extraShellHook = ''
      if [ ! -f justfile ]; then
        cp ${justfile} justfile
        echo "📋 Copied PHP-specific justfile"
      fi
    '';
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
