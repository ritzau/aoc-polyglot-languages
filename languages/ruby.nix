{
  pkgs,
  base,
  justfilePath ? null,
}:
let
  devShell = base.mkLanguageShell {
    name = "Ruby";
    emoji = "💎";
    languageTools = with pkgs; [
      ruby
    ];
    extraShellHook =
      if justfilePath != null then
        ''
          export JUSTFILE_RUBY="${justfilePath}"
          # Create a cache directory and symlink to language justfile
          mkdir -p .cache
          if [ ! -L .cache/ruby.justfile ]; then
            ln -sf "${justfilePath}" .cache/ruby.justfile
            echo "📋 Linked .cache/ruby.justfile to language definition"
          fi
        ''
      else
        "";
  };

  solution =
    args:
    base.mkSolution {
      language = "ruby";
      package = base.buildFunctions.scriptRunner {
        interpreter = pkgs.ruby;
        fileExtensions = [ "rb" ];
        interpreterName = "ruby";
      } (args // { pkgs = pkgs; });
    };
in
{
  mkStandardOutputs = args: (solution args) // { devShells.default = devShell; };
}
