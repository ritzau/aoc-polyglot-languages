# COBOL AOC Development Commands

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
    echo "COBOL testing would go here"

# Clean build artifacts
clean:
    rm -f *.o *.exe a.out
    rm -f result

# Lint code
lint:
    echo "COBOL linting would go here"

# Format code
format:
    echo "COBOL formatting would go here"
