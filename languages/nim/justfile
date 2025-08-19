# Nim AOC Development Commands

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
    nimble test

# Clean build artifacts
clean:
    nimble clean
    rm -f result

# Lint code
lint:
    nim check solution.nim

# Format code
format:
    nimpretty solution.nim
