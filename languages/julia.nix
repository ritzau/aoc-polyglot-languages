{ pkgs, base }:
let
  justfile = base.mkJustfile "julia";
in
{
  devShell = base.mkLanguageShell {
    name = "Julia";
    emoji = "🔢";
    languageTools = with pkgs; [
      julia
    ];
    extraShellHook = ''
      if [ ! -f justfile ]; then
        cp ${justfile} justfile
        echo "📋 Copied Julia-specific justfile"
      fi
    '';
  };

  mkStandardOutputs =
    args:
    base.mkSolution {
      language = "julia";
      package = pkgs.writeShellApplication {
        name = args.pname or "hello-julia";
        runtimeInputs = [ pkgs.julia ];
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
}
