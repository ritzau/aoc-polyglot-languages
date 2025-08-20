{
  pkgs,
  base,
  justfilePath ? null,
}:
let
  devShell = base.mkLanguageShell {
    name = "Ada";
    emoji = "🏛️";
    languageTools = with pkgs; [
      gnat
      gprbuild
    ];
    extraShellHook =
      if justfilePath != null then
        ''
          export JUSTFILE_ADA="${justfilePath}"
          # Create a cache directory and symlink to language justfile
          mkdir -p .cache
          if [ ! -L .cache/ada.justfile ]; then
            ln -sf "${justfilePath}" .cache/ada.justfile
            echo "📋 Linked .cache/ada.justfile to language definition"
          fi
        ''
      else
        "";
  };

  solution =
    args:
    base.mkSolution {
      language = "ada";
      package = base.buildFunctions.buildSystem (
        buildArgs:
        pkgs.stdenv.mkDerivation {
          version = "0.1.0";
          nativeBuildInputs = [ pkgs.gnat ];
          buildPhase = ''
            # Find the ada file in the source directory
            adafile=$(find . -maxdepth 1 -name "*.adb" | head -1)
            if [ -n "$adafile" ]; then
              gnatmake "$adafile"
            else
              echo "No Ada files found"
              exit 1
            fi
          '';
          installPhase = ''
            mkdir -p $out/bin
            # Find the compiled executable (without .adb extension)
            exe=$(find . -maxdepth 1 -type f -executable ! -name "*.adb" ! -name "*.ali" ! -name "*.o" | head -1)
            if [ -n "$exe" ]; then
              cp "$exe" $out/bin/${buildArgs.pname or "hello-ada"}
            else
              echo "No executable found"
              exit 1
            fi
          '';
        }
        // buildArgs
      ) args;
    };
in
{
  mkStandardOutputs = args: (solution args) // { devShells.default = devShell; };
}
