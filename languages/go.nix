{ pkgs, base }:
let
  justfile = base.mkJustfile "go";
in
{
  devShell = base.mkLanguageShell {
    name = "Go";
    emoji = "🐹";
    languageTools = with pkgs; [
      go
      gopls
      gofumpt
      golangci-lint
    ];
    extraShellHook = ''
      if [ ! -f justfile ]; then
        cp ${justfile} justfile
        echo "📋 Copied Go-specific justfile"
      fi
    '';
  };

  mkStandardOutputs =
    args:
    base.mkSolution {
      language = "go";
      package = base.buildFunctions.buildSystem (
        buildArgs:
        pkgs.buildGoModule (
          {
            version = "0.1.0";
            vendorHash = null; # For simple AOC solutions
          }
          // buildArgs
        )
      ) ({ inherit pkgs; } // args);
    };
}
