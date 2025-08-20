{
  pkgs,
  base,
  justfilePath ? null,
}:
let
  devShell = base.mkLanguageShell {
    name = "Go";
    emoji = "🐹";
    languageTools = with pkgs; [
      go
      gopls
      gofumpt
      golangci-lint
    ];
    extraShellHook =
      if justfilePath != null then
        ''
          export JUSTFILE_GO="${justfilePath}"
          mkdir -p .cache
          if [ ! -L .cache/go.justfile ]; then
            ln -sf "${justfilePath}" .cache/go.justfile
            echo "📋 Linked .cache/go.justfile to language definition"
          fi
        ''
      else
        "";
  };
in
{
  inherit devShell;

  mkStandardOutputs =
    args:
    (
      base.mkSolution {
        language = "go";
        package = base.buildFunctions.buildSystem (
          buildArgs:
          pkgs.buildGoModule (
            {
              version = "0.1.0";
              vendorHash = null;
            }
            // buildArgs
          )
        ) args;
      }
      // {
        # Assign devShell to devShells.default in the produced solution outputs
        devShells.default = devShell;
      }
    );
}
