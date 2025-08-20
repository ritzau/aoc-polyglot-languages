# Zig AOC Development Commands

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
    zig test solution.zig

# Clean build artifacts
clean:
    rm -rf zig-cache/ zig-out/
    rm -f result

# Lint code
lint:
    zig fmt --check solution.zig

# Format code
format:
    zig fmt solution.zig
