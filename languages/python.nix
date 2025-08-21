{
  pkgs,
  base,
  justfilePath ? null,
}:
let
  solution =
    args:
    let
      # Extract Python package from args, default to python311
      selectedPython = args.python or pkgs.python311;
    in
    let
      devShell = base.mkLanguageShell {
        name = "Python";
        emoji = "🐍";
        languageTools = with selectedPython.pkgs; [
          selectedPython
          pip
          pytest
          black
          isort
          mypy
          numpy
          matplotlib
          networkx
          sympy
        ];
        extraShellHook =
          if justfilePath != null then
            ''
              export JUSTFILE_PYTHON="${justfilePath}"
              # Create a cache directory and symlink to language justfile
              mkdir -p .cache
              if [ ! -L .cache/python.justfile ]; then
                ln -sf "${justfilePath}" .cache/python.justfile
                echo "📋 Linked .cache/python.justfile to language definition"
              fi
            ''
          else
            "";
      };
    in
    (base.mkSolution {
      language = "python";
      package = base.buildFunctions.interpreter {
        interpreter = selectedPython;
        fileExtensions = [ "py" ];
      } (args // { pkgs = pkgs; });
    })
    // {
      devShells.default = devShell;
    };
in
{
  mkStandardOutputs = args: solution args;
}
