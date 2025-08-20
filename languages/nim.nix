{ pkgs, base }:
let
  justfile = base.mkJustfile "nim";
in
{
  devShell = base.mkLanguageShell {
    name = "Nim";
    emoji = "👑";
    languageTools = with pkgs; [
      nim
    ];
    extraShellHook = ''
      if [ ! -f justfile ]; then
        cp ${justfile} justfile
        echo "📋 Copied Nim-specific justfile"
      fi
    '';
  };

  mkStandardOutputs =
    args:
    base.mkSolution {
      language = "nim";
      package = base.buildFunctions.simpleCompiler {
        compiler = pkgs.nim;
        fileExtensions = [ "nim" ];
        compileCmd = "nim compile --verbosity:0 -o:hello-nim *.nim";
      } args;
    };
}
