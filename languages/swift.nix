{
  pkgs,
  base,
  justfilePath ? null,
}:
let
  devShell = base.mkLanguageShell {
    name = "Swift";
    emoji = "🦉";
    languageTools = with pkgs; [
      swift
    ];
    extraShellHook =
      if justfilePath != null then
        ''
          export JUSTFILE_SWIFT="${justfilePath}"
          # Create a cache directory and symlink to language justfile
          mkdir -p .cache
          if [ ! -L .cache/swift.justfile ]; then
            ln -sf "${justfilePath}" .cache/swift.justfile
            echo "📋 Linked .cache/swift.justfile to language definition"
          fi
        ''
      else
        "";
  };

  solution =
    args:
    base.mkSolution {
      language = "swift";
      package = base.buildFunctions.simpleCompiler {
        compiler = pkgs.swift;
        fileExtensions = [ "swift" ];
        compileCmd = "swiftc *.swift -o hello-swift";
      } (args // { pkgs = pkgs; });
    };
in
{
  mkStandardOutputs = args: (solution args) // { devShells.default = devShell; };
}
