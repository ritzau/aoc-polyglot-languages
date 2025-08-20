# TypeScript AOC Development Commands

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
    npm test

# Clean build artifacts
clean:
    rm -rf node_modules/ *.js
    rm -f result

# Lint code
lint:
    eslint hello.ts

# Format code
format:
    prettier --write hello.ts
