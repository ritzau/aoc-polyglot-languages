# C# AOC Development Commands

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
    dotnet test

# Clean build artifacts
clean:
    rm -rf bin/ obj/ *.exe && rm -f result

# Lint code
lint:
    echo "C# linting would go here"

# Format code
format:
    dotnet format
