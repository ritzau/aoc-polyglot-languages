{ pkgs, base }:
let
  justfile = base.mkJustfile "perl";
in
{
  devShell = base.mkLanguageShell {
    name = "Perl";
    emoji = "🐪";
    languageTools = with pkgs; [
      perl
    ];
    extraShellHook = ''
      if [ ! -f justfile ]; then
        cp ${justfile} justfile
        echo "📋 Copied Perl-specific justfile"
      fi
    '';
  };

  mkStandardOutputs =
    args:
    base.mkSolution {
      language = "perl";
      package = pkgs.writeShellApplication {
        name = args.pname or "hello-perl";
        runtimeInputs = [ pkgs.perl ];
        text = ''
          # Find the perl file in the source directory
          perlfile=$(find ${args.src or ./.} -maxdepth 1 -name "*.pl" | head -1)
          if [ -n "$perlfile" ]; then
            exec perl "$perlfile" "$@"
          else
            echo "No Perl files found in ${args.src or ./.}"
            exit 1
          fi
        '';
      };
    };
}
