{
  description = "Polyglot Advent of Code solutions with Nix flakes";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            # Core tools
            git
            direnv
            nix-direnv
            just

            # Text editors and utilities
            vim
            curl
            wget
            jq

            # Benchmarking and profiling
            hyperfine
            time

            # Code formatting and linting
            pre-commit
            clang-tools # includes clang-format
            nixpkgs-fmt
            nodePackages.prettier

            # Build all script (compiled languages only)
            (writeShellScriptBin "build-all" ''
              echo "Building compiled AOC solutions..."
              for solution in solutions/*/*/rust solutions/*/*/go solutions/*/*/cpp solutions/*/*/c solutions/*/*/zig solutions/*/*/d solutions/*/*/nim solutions/*/*/swift solutions/hello/rust solutions/hello/go solutions/hello/cpp solutions/hello/c solutions/hello/zig solutions/hello/d solutions/hello/nim solutions/hello/swift solutions/hello/ada; do
                if [ -d "$solution" ] && [ -f "$solution/flake.nix" ]; then
                  echo "Building $solution..."
                  nix build ./"$solution" --impure || echo "Failed to build $solution"
                fi
              done
              echo "Done! (Skipped interpreted languages)"
            '')
          ];

          shellHook = ''
            echo "🎄 Advent of Code Polyglot Environment"
            echo "Available languages: rust, python, haskell, javascript, go"
            echo "Commands:"
            echo "  build-all - Build all solutions"
            echo "  just --list - Show all available just commands"
            echo "  pre-commit install - Set up git hooks (run once)"
            echo "  pre-commit run --all-files - Format all files"
            echo "Navigate to solutions/YEAR/dayXX/LANGUAGE/ to work on specific solutions"
            echo "Use 'direnv allow' in language directories to enable language-specific environments"
          '';
        };

        # Note: To build all solutions, run individual builds
        # nix build ./solutions/2024/day01/rust
        # Or create a script to build all
      });
}
