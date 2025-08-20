{
  pkgs,
  base,
  justfilePath ? null,
}:
{
  devShell = base.mkLanguageShell {
    name = "R";
    emoji = "📊";
    languageTools = with pkgs; [
      R
    ];
    extraShellHook =
      if justfilePath != null then
        ''
          export JUSTFILE_R="${justfilePath}"
          # Create a cache directory and symlink to language justfile
          mkdir -p .cache
          if [ ! -L .cache/r.justfile ]; then
            ln -sf "${justfilePath}" .cache/r.justfile
            echo "📋 Linked .cache/r.justfile to language definition"
          fi
        ''
      else
        "";
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
