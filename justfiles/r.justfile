# R AOC Development Commands

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
    echo "R testing would go here"

# Clean build artifacts
clean:
    rm -f .RData .Rhistory
    rm -f result

# Lint code
lint:
    echo "R linting would go here"

# Format code
format:
    echo "R formatting would go here"
