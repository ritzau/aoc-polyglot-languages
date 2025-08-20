# Python AOC Development Commands

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
    pytest

# Clean build artifacts
clean:
    find . -name "*.pyc" -delete
    find . -name "__pycache__" -delete
    rm -f result

# Lint code
lint:
    mypy solution.py

# Format code
format:
    black .
