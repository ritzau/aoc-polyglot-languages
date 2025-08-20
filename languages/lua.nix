{ pkgs, base }:
let
  justfile = base.mkJustfile "lua";
in
{
  devShell = base.mkLanguageShell {
    name = "Lua";
    emoji = "🌙";
    languageTools = with pkgs; [
      lua
    ];
    extraShellHook = ''
      if [ ! -f justfile ]; then
        cp ${justfile} justfile
        echo "📋 Copied Lua-specific justfile"
      fi
    '';
  };

  mkStandardOutputs =
    args:
    base.mkSolution {
      language = "lua";
      package = base.buildFunctions.interpreter {
        interpreter = pkgs.lua;
        fileExtensions = [ "lua" ];
      } args;
    };
}
