{
  pkgs,
  base,
  justfilePath ? null,
}:
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
    extraShellHook =
      if justfilePath != null then
        ''
          export JUSTFILE_RUST="${justfilePath}"
          # Create a cache directory and symlink to language justfile
          mkdir -p .cache
          if [ ! -L .cache/rust.justfile ]; then
            ln -sf "${justfilePath}" .cache/rust.justfile
            echo "📋 Linked .cache/rust.justfile to language definition"
          fi
        ''
      else
        "";
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
