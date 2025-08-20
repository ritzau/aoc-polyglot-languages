{
  pkgs,
  base,
  justfilePath ? null,
}:
{
  devShell = base.mkLanguageShell {
    name = "Lua";
    emoji = "🌙";
    languageTools = with pkgs; [
      lua
    ];
    extraShellHook =
      if justfilePath != null then
        ''
          export JUSTFILE_LUA="${justfilePath}"
          # Create a cache directory and symlink to language justfile
          mkdir -p .cache
          if [ ! -L .cache/lua.justfile ]; then
            ln -sf "${justfilePath}" .cache/lua.justfile
            echo "📋 Linked .cache/lua.justfile to language definition"
          fi
        ''
      else
        "";
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
