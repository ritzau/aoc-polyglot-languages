{ pkgs, base }:
let
  justfile = base.mkJustfile "rust";
in
{
  devShell = base.mkLanguageShell {
    name = "Rust";
    emoji = "🦀";
    languageTools = with pkgs; [
      rustc
      cargo
      clippy
      rustfmt
      cargo-watch
    ];
    extraShellHook = ''
      if [ ! -f justfile ]; then
        cp ${justfile} justfile
        echo "📋 Copied Rust-specific justfile"
      fi
    '';
  };

  mkStandardOutputs =
    args:
    base.mkSolution {
      language = "rust";
      package = base.buildFunctions.buildSystem (
        buildArgs:
        pkgs.rustPlatform.buildRustPackage (
          {
            version = "0.1.0";
            cargoLock.lockFile = "${buildArgs.src}/Cargo.lock";
          }
          // buildArgs
        )
      ) args;
    };
}
