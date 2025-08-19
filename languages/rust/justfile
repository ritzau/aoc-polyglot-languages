# Rust AOC Development Commands

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
    cargo test

# Clean build artifacts
clean:
    cargo clean
    rm -f result

# Lint code
lint:
    cargo clippy

# Format code
format:
    cargo fmt
