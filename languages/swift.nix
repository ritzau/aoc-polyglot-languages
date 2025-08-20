{ pkgs, base }:
let
  justfile = base.mkJustfile "swift";
in
{
  devShell = base.mkLanguageShell {
    name = "Swift";
    emoji = "🦉";
    languageTools = with pkgs; [
      swift
    ];
    extraShellHook = ''
      if [ ! -f justfile ]; then
        cp ${justfile} justfile
        echo "📋 Copied Swift-specific justfile"
      fi
    '';
  };

  mkStandardOutputs =
    args:
    base.mkSolution {
      language = "swift";
      package = base.buildFunctions.simpleCompiler {
        compiler = pkgs.swift;
        fileExtensions = [ "swift" ];
        compileCmd = "swiftc *.swift -o hello-swift";
      } ({ inherit pkgs; } // args);
    };
}
