# Go AOC Development Commands

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
    go test

# Clean build artifacts
clean:
    go clean
    rm -f result

# Lint code
lint:
    golangci-lint run

# Format code
format:
    go fmt .
