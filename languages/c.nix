{ pkgs, base }:
{
  devShell = base.mkLanguageShell {
    name = "C";
    emoji = "🔧";
    languageTools = with pkgs; [
      gcc
      clang
      gnumake
      gdb
      pkg-config
      clang-tools
    ];
  };

  mkStandardOutputs = args: base.mkSolution {
    language = "c";
    package = base.buildFunctions.makeBuild {
      buildInputs = with pkgs; [ gcc ];
    } ({ inherit pkgs; } // args);
  };
}