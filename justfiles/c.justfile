# C AOC Development Commands

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
    make test

# Clean build artifacts
clean:
    make clean || true
    rm -f result

# Lint code
lint:
    make lint

# Format code
format:
    make format
