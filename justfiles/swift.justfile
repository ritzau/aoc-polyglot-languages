# Swift AOC Development Commands

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
    swift test

# Clean build artifacts
clean:
    rm -rf *.o .build/
    rm -f result

# Lint code
lint:
    echo "Swift linting would go here"

# Format code
format:
    swiftformat *.swift
