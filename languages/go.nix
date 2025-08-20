{ pkgs, base }:
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
  };

  mkStandardOutputs = args: base.mkSolution {
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