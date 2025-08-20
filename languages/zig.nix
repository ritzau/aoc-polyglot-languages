{
  pkgs,
  base,
  justfilePath ? null,
}:
let
  devShell = base.mkLanguageShell {
    name = "Zig";
    emoji = "⚡";
    languageTools = with pkgs; [
      zig
      zls
    ];
    extraShellHook =
      if justfilePath != null then
        ''
          export JUSTFILE_ZIG="${justfilePath}"
          # Create a cache directory and symlink to language justfile
          mkdir -p .cache
          if [ ! -L .cache/zig.justfile ]; then
            ln -sf "${justfilePath}" .cache/zig.justfile
            echo "📋 Linked .cache/zig.justfile to language definition"
          fi
        ''
      else
        "";
  };

  solution =
    args:
    base.mkSolution {
      language = "zig";
      package = base.buildFunctions.simpleCompiler {
        compiler = pkgs.zig;
        fileExtensions = [ "zig" ];
        compileCmd = "export HOME=$TMPDIR ZIG_LOCAL_CACHE_DIR=$TMPDIR/zig-cache ZIG_GLOBAL_CACHE_DIR=$TMPDIR/zig-cache && mkdir -p $TMPDIR/zig-cache && zig build-exe *.zig -femit-bin=hello-zig --cache-dir $TMPDIR/zig-cache";
      } args;
    };
in
{
  mkStandardOutputs = args: (solution args) // { devShells.default = devShell; };
}
