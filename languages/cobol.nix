{ pkgs, base }:
let
  justfile = base.mkJustfile "cobol";
in
{
  devShell = base.mkLanguageShell {
    name = "COBOL";
    emoji = "🏢";
    languageTools = with pkgs; [
      gnucobol
    ];
    extraShellHook = ''
      if [ ! -f justfile ]; then
        cp ${justfile} justfile
        echo "📋 Copied COBOL-specific justfile"
      fi
    '';
  };

  mkStandardOutputs =
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
}
