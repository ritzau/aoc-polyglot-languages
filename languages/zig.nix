{ pkgs, base }:
let
  justfile = base.mkJustfile "zig";
in
{
  devShell = base.mkLanguageShell {
    name = "Zig";
    emoji = "⚡";
    languageTools = with pkgs; [
      zig
      zls
    ];
    extraShellHook = ''
      if [ ! -f justfile ]; then
        cp ${justfile} justfile
        echo "📋 Copied Zig-specific justfile"
      fi
    '';
  };

  mkStandardOutputs =
    args:
    base.mkSolution {
      language = "zig";
      package = base.buildFunctions.simpleCompiler {
        compiler = pkgs.zig;
        fileExtensions = [ "zig" ];
        compileCmd = "export HOME=$TMPDIR ZIG_LOCAL_CACHE_DIR=$TMPDIR/zig-cache ZIG_GLOBAL_CACHE_DIR=$TMPDIR/zig-cache && mkdir -p $TMPDIR/zig-cache && zig build-exe *.zig -femit-bin=hello-zig --cache-dir $TMPDIR/zig-cache";
      } ({ inherit pkgs; } // args);
    };
}
