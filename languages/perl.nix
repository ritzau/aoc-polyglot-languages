{
  pkgs,
  base,
  justfilePath ? null,
}:
let
  devShell = base.mkLanguageShell {
    name = "Perl";
    emoji = "🐪";
    languageTools = with pkgs; [
      perl
    ];
    extraShellHook =
      if justfilePath != null then
        ''
          export JUSTFILE_PERL="${justfilePath}"
          # Create a cache directory and symlink to language justfile
          mkdir -p .cache
          if [ ! -L .cache/perl.justfile ]; then
            ln -sf "${justfilePath}" .cache/perl.justfile
            echo "📋 Linked .cache/perl.justfile to language definition"
          fi
        ''
      else
        "";
  };

  solution =
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
in
{
  mkStandardOutputs = args: (solution args) // { devShells.default = devShell; };
}
