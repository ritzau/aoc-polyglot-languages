{ pkgs, base }:
let
  justfile = base.mkJustfile "r";
in
{
  devShell = base.mkLanguageShell {
    name = "R";
    emoji = "📊";
    languageTools = with pkgs; [
      R
    ];
    extraShellHook = ''
      if [ ! -f justfile ]; then
        cp ${justfile} justfile
        echo "📋 Copied R-specific justfile"
      fi
    '';
  };

  mkStandardOutputs =
    args:
    base.mkSolution {
      language = "r";
      package = pkgs.writeShellApplication {
        name = args.pname or "hello-r";
        runtimeInputs = [ pkgs.R ];
        text = ''
          # Find the R file in the source directory
          rfile=$(find ${args.src or ./.} -maxdepth 1 -name "*.R" -o -name "*.r" | head -1)
          if [ -n "$rfile" ]; then
            exec Rscript "$rfile" "$@"
          else
            echo "No R files found in ${args.src or ./.}"
            exit 1
          fi
        '';
      };
    };
}
