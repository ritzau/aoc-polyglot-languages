{
  pkgs,
  base,
  justfilePath ? null,
}:
let
  devShell = base.mkLanguageShell {
    name = "COBOL";
    emoji = "🏢";
    languageTools = with pkgs; [
      gnucobol
    ];
    extraShellHook =
      if justfilePath != null then
        ''
          export JUSTFILE_COBOL="${justfilePath}"
          # Create a cache directory and symlink to language justfile
          mkdir -p .cache
          if [ ! -L .cache/cobol.justfile ]; then
            ln -sf "${justfilePath}" .cache/cobol.justfile
            echo "📋 Linked .cache/cobol.justfile to language definition"
          fi
        ''
      else
        "";
  };

  solution =
    args:
    base.mkSolution {
      language = "cobol";
      package = pkgs.writeShellApplication {
        name = args.pname or "hello-cobol";
        runtimeInputs = [ pkgs.gnucobol ];
        text = ''
          # Find the COBOL file in the source directory
          cobolfile=$(find ${args.src or ./.} -maxdepth 1 -name "*.cob" -o -name "*.cobol" -o -name "*.cbl" | head -1)
          if [ -n "$cobolfile" ]; then
            # Compile and run
            temp_exe=$(mktemp)
            cobc -x "$cobolfile" -o "$temp_exe"
            exec "$temp_exe" "$@"
          else
            echo "No COBOL files found in ${args.src or ./.}"
            exit 1
          fi
        '';
      };
    };
in
{
  mkStandardOutputs = args: (solution args) // { devShells.default = devShell; };
}
