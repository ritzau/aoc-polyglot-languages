{
  pkgs,
  base,
  justfilePath ? null,
}:
{
  devShell = base.mkLanguageShell {
    name = "D";
    emoji = "🎯";
    languageTools = with pkgs; [
      ldc
      dub
      gdb
    ];
    extraShellHook =
      if justfilePath != null then
        ''
          export JUSTFILE_D="${justfilePath}"
          # Create a cache directory and symlink to language justfile
          mkdir -p .cache
          if [ ! -L .cache/d.justfile ]; then
            ln -sf "${justfilePath}" .cache/d.justfile
            echo "📋 Linked .cache/d.justfile to language definition"
          fi
        ''
      else
        "";
  };

  mkStandardOutputs =
    args:
    base.mkSolution {
      language = "d";
      package = base.buildFunctions.buildSystem (
        buildArgs:
        pkgs.stdenv.mkDerivation {
          pname = buildArgs.pname or "hello-d";
          version = "0.1.0";
          src = buildArgs.src;
          nativeBuildInputs = with pkgs; [ ldc ];
          buildPhase = ''
            # Find .d files and compile them
            dfile=$(find . -maxdepth 1 -name "*.d" | head -1)
            if [ -n "$dfile" ]; then
              ldc2 -of=${buildArgs.pname or "hello-d"} "$dfile"
            else
              echo "No .d files found"
              exit 1
            fi
          '';
          installPhase = ''
            mkdir -p $out/bin
            cp ${buildArgs.pname or "hello-d"} $out/bin/
          '';
        }
      ) args;
    };
}
