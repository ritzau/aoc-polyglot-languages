{
  pkgs,
  base,
  justfilePath ? null,
}:
let
  devShell = base.mkLanguageShell {
    name = "Julia";
    emoji = "🔢";
    languageTools = with pkgs; [
      julia-bin
    ];
    extraShellHook =
      if justfilePath != null then
        ''
          export JUSTFILE_JULIA="${justfilePath}"
          # Create a cache directory and symlink to language justfile
          mkdir -p .cache
          if [ ! -L .cache/julia.justfile ]; then
            ln -sf "${justfilePath}" .cache/julia.justfile
            echo "📋 Linked .cache/julia.justfile to language definition"
          fi
        ''
      else
        "";
  };

  solution =
    args:
    base.mkSolution {
      language = "julia";
      package = pkgs.writeShellApplication {
        name = args.pname or "hello-julia";
        runtimeInputs = [ pkgs.julia-bin ];
        text = ''
          # Find the julia file in the source directory
          juliafile=$(find ${args.src or ./.} -maxdepth 1 -name "*.jl" | head -1)
          if [ -n "$juliafile" ]; then
            exec julia "$juliafile" "$@"
          else
            echo "No .jl files found in ${args.src or ./.}"
            exit 1
          fi
        '';
      };
    };
in
{
  mkStandardOutputs = args: (solution args) // { devShells.default = devShell; };
  mkDefaultOutputs = args: (solution args) // { devShells.default = devShell; };
}
