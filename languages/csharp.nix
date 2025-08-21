{
  pkgs,
  base,
  justfilePath ? null,
}:
let
  devShell = base.mkLanguageShell {
    name = "C#";
    emoji = "🔷";
    languageTools = with pkgs; [
      dotnet-sdk_8
      # Note: mono removed in favor of modern .NET SDK
      omnisharp-roslyn
    ];
    extraShellHook =
      if justfilePath != null then
        ''
          export JUSTFILE_CSHARP="${justfilePath}"
          # Create a cache directory and symlink to language justfile
          mkdir -p .cache
          if [ ! -L .cache/csharp.justfile ]; then
            ln -sf "${justfilePath}" .cache/csharp.justfile
            echo "📋 Linked .cache/csharp.justfile to language definition"
          fi
        ''
      else
        "";
  };

  solution =
    args:
    base.mkSolution {
      language = "csharp";
      package = pkgs.writeShellApplication {
        name = args.pname or "hello-csharp";
        runtimeInputs = [ pkgs.dotnet-sdk_8 ];
        text = ''
          # Create temporary directory for .NET project
          tmpdir=$(mktemp -d)
          cd "$tmpdir"

          # Find C# source file
          srcfile=$(find ${args.src or ./.} -maxdepth 1 -name "*.cs" | head -1)
          if [ -z "$srcfile" ]; then
            echo "No .cs files found in ${args.src or ./.}"
            exit 1
          fi

          # Create a minimal .NET project
          dotnet new console --force --use-program-main

          # Copy our source file over the template
          cp "$srcfile" Program.cs

          # Run the program
          exec dotnet run "$@"
        '';
      };
    };
in
{
  mkStandardOutputs = args: (solution args) // { devShells.default = devShell; };
  mkDefaultOutputs = args: (solution args) // { devShells.default = devShell; };
}
