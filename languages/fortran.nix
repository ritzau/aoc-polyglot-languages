{
  pkgs,
  base,
  justfilePath ? null,
}:
{
  devShell = base.mkLanguageShell {
    name = "Fortran";
    emoji = "🏗️";
    languageTools = with pkgs; [
      gfortran
    ];
    extraShellHook =
      if justfilePath != null then
        ''
          export JUSTFILE_FORTRAN="${justfilePath}"
          # Create a cache directory and symlink to language justfile
          mkdir -p .cache
          if [ ! -L .cache/fortran.justfile ]; then
            ln -sf "${justfilePath}" .cache/fortran.justfile
            echo "📋 Linked .cache/fortran.justfile to language definition"
          fi
        ''
      else
        "";
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
      } args;
    };
}
