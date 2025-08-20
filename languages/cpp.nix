{ pkgs, base }:
let
  justfile = base.mkJustfile "cpp";
in
{
  devShell = base.mkLanguageShell {
    name = "C++";
    emoji = "⚡";
    languageTools = with pkgs; [
      gcc
      clang
      cmake
      ninja
      gdb
      pkg-config
      clang-tools
    ];
    extraShellHook = ''
      if [ ! -f justfile ]; then
        cp ${justfile} justfile
        echo "📋 Copied C++-specific justfile"
      fi
    '';
  };

  mkStandardOutputs =
    args:
    base.mkSolution {
      language = "cpp";
      package = base.buildFunctions.cmakeBuild {
        buildInputs = with pkgs; [ gcc ];
      } ({ inherit pkgs; } // args);
    };
}
