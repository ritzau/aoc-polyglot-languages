{ pkgs, base }:
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
  };

  mkStandardOutputs = args: base.mkSolution {
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
    ) ({ inherit pkgs; } // args);
  };
}