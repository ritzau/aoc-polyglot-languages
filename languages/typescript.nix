{ pkgs, base }:
let
  justfile = base.mkJustfile "typescript";
in
{
  devShell = base.mkLanguageShell {
    name = "TypeScript";
    emoji = "🔷";
    languageTools = with pkgs; [
      nodejs_20
      typescript
    ];
    extraShellHook = ''
      if [ ! -f justfile ]; then
        cp ${justfile} justfile
        echo "📋 Copied TypeScript-specific justfile"
      fi
    '';
  };

  mkStandardOutputs =
    args:
    base.mkSolution {
      language = "typescript";
      package = base.buildFunctions.simpleCompiler {
        compiler = pkgs.typescript;
        fileExtensions = [ "ts" ];
        compileCmd = "tsc *.ts --outDir dist && node dist/*.js";
      } args;
    };
}
