{ pkgs, base }:
let
  justfile = base.mkJustfile "csharp";
in
{
  devShell = base.mkLanguageShell {
    name = "C#";
    emoji = "🔷";
    languageTools = with pkgs; [
      dotnet-sdk_8
      mono
      omnisharp-roslyn
    ];
    extraShellHook = ''
      if [ ! -f justfile ]; then
        cp ${justfile} justfile
        echo "📋 Copied C#-specific justfile"
      fi
    '';
  };

  mkStandardOutputs =
    args:
    base.mkSolution {
      language = "csharp";
      package = base.buildFunctions.simpleCompiler {
        compiler = pkgs.mono;
        fileExtensions = [ "cs" ];
        compileCmd = "mcs -out:hello-csharp.exe *.cs";
      } args;
    };
}
