{ pkgs, base }:
let
  python = pkgs.python311;
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
  };

  mkStandardOutputs = args: base.mkSolution {
    language = "python";
    package = base.buildFunctions.interpreter {
      interpreter = python;
      fileExtensions = [ "py" ];
    } ({ inherit pkgs; } // args);
  };
}