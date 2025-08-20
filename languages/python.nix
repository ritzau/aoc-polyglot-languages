{ pkgs, base }:
let
  python = pkgs.python311;
  justfile = base.mkJustfile "python";
in
{
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
    extraShellHook = ''
      if [ ! -f justfile ]; then
        cp ${justfile} justfile
        echo "📋 Copied Python-specific justfile"
      fi
    '';
  };

  mkStandardOutputs =
    args:
    base.mkSolution {
      language = "python";
      package = base.buildFunctions.interpreter {
        interpreter = python;
        fileExtensions = [ "py" ];
      } ({ inherit pkgs; } // args);
    };
}
