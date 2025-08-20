{ pkgs, base }:
let
  justfile = base.mkJustfile "c";
in
{
  devShell = base.mkLanguageShell {
    name = "C";
    emoji = "🔧";
    languageTools = with pkgs; [
      gcc
      clang
      gnumake
      gdb
      pkg-config
      clang-tools
    ];
    extraShellHook = ''
      if [ ! -f justfile ]; then
        cp ${justfile} justfile
        echo "📋 Copied C-specific justfile"
      fi
    '';
  };

  mkStandardOutputs =
    args:
    base.mkSolution {
      language = "c";
      package = base.buildFunctions.makeBuild {
        buildInputs = with pkgs; [ gcc ];
      } ({ inherit pkgs; } // args);
    };
}
