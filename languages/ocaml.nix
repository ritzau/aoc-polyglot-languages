{
  pkgs,
  base,
  justfilePath ? null,
}:
{
  devShell = base.mkLanguageShell {
    name = "OCaml";
    emoji = "🐫";
    languageTools = with pkgs; [
      ocaml
      ocamlPackages.ocamlbuild
    ];
    extraShellHook =
      if justfilePath != null then
        ''
          export JUSTFILE_OCAML="${justfilePath}"
          # Create a cache directory and symlink to language justfile
          mkdir -p .cache
          if [ ! -L .cache/ocaml.justfile ]; then
            ln -sf "${justfilePath}" .cache/ocaml.justfile
            echo "📋 Linked .cache/ocaml.justfile to language definition"
          fi
        ''
      else
        "";
  };

  mkStandardOutputs =
    args:
    base.mkSolution {
      language = "ocaml";
      package = base.buildFunctions.simpleCompiler {
        compiler = pkgs.ocaml;
        fileExtensions = [ "ml" ];
        compileCmd = "ocamlc -o hello-ocaml *.ml";
      } args;
    };
}
