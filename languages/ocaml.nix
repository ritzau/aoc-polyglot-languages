{ pkgs, base }:
let
  justfile = base.mkJustfile "ocaml";
in
{
  devShell = base.mkLanguageShell {
    name = "OCaml";
    emoji = "🐫";
    languageTools = with pkgs; [
      ocaml
      ocamlPackages.ocamlbuild
    ];
    extraShellHook = ''
      if [ ! -f justfile ]; then
        cp ${justfile} justfile
        echo "📋 Copied OCaml-specific justfile"
      fi
    '';
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
