{ pkgs, base }:
let
  justfile = base.mkJustfile "fortran";
in
{
  devShell = base.mkLanguageShell {
    name = "Fortran";
    emoji = "🏗️";
    languageTools = with pkgs; [
      gfortran
    ];
    extraShellHook = ''
      if [ ! -f justfile ]; then
        cp ${justfile} justfile
        echo "📋 Copied Fortran-specific justfile"
      fi
    '';
  };

  mkStandardOutputs =
    args:
    base.mkSolution {
      language = "fortran";
      package = base.buildFunctions.simpleCompiler {
        compiler = pkgs.gfortran;
        fileExtensions = [
          "f90"
          "f95"
          "f"
        ];
        compileCmd = "gfortran *.f90 -o hello-fortran || gfortran *.f95 -o hello-fortran || gfortran *.f -o hello-fortran";
      } ({ inherit pkgs; } // args);
    };
}
