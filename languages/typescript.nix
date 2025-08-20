{
  pkgs,
  base,
  justfilePath ? null,
}:
let
  devShell = base.mkLanguageShell {
    name = "TypeScript";
    emoji = "🔷";
    languageTools = with pkgs; [
      nodejs_20
      typescript
    ];
    extraShellHook =
      if justfilePath != null then
        ''
          export JUSTFILE_TYPESCRIPT="${justfilePath}"
          # Create a cache directory and symlink to language justfile
          mkdir -p .cache
          if [ ! -L .cache/typescript.justfile ]; then
            ln -sf "${justfilePath}" .cache/typescript.justfile
            echo "📋 Linked .cache/typescript.justfile to language definition"
          fi
        ''
      else
        "";
  };

  solution =
    args:
    base.mkSolution {
      language = "typescript";
      package = base.buildFunctions.simpleCompiler {
        compiler = pkgs.typescript;
        fileExtensions = [ "ts" ];
        compileCmd = "tsc *.ts --outDir dist && node dist/*.js";
      } (args // { pkgs = pkgs; });
    };
in
{
  mkStandardOutputs = args: (solution args) // { devShells.default = devShell; };
}
