{ pkgs, base }:
let
  justfile = base.mkJustfile "d";
in
{
  devShell = base.mkLanguageShell {
    name = "D";
    emoji = "🎯";
    languageTools = with pkgs; [
      ldc
      dub
      gdb
    ];
    extraShellHook = ''
      if [ ! -f justfile ]; then
        cp ${justfile} justfile
        echo "📋 Copied D-specific justfile"
      fi
    '';
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
      ) ({ inherit pkgs; } // args);
    };
}
