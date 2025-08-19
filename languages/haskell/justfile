# Haskell AOC Development Commands

# Show available commands
default:
    @just --list

# Build the solution (via nix build)
build:
    nix build

# Run the solution (via nix run)
run:
    nix run

# Run tests
test:
    cabal test

# Clean build artifacts
clean:
    rm -rf dist/ dist-newstyle/ *.hi *.o
    rm -f result

# Lint code
lint:
    hlint *.hs

# Format code
format:
    ormolu --mode inplace *.hs
