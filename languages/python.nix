{
  pkgs,
  base,
  justfilePath ? null,
}:
let
  python = pkgs.python311;

  devShell = base.mkLanguageShell {
    name = "Python";
    emoji = "🐍";
    languageTools = with python.pkgs; [
      python
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

  solution =
    args:
    base.mkSolution {
      language = "python";
      package = base.buildFunctions.interpreter {
        interpreter = python;
        fileExtensions = [ "py" ];
      } (args // { pkgs = pkgs; });
    };
in
{
  mkStandardOutputs =
    args:
    (solution args)
    // {
      devShells.default = devShell;
    };
}
