# Lisp AOC Development Commands

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
    echo "Lisp testing would go here"

# Clean build artifacts
clean:
    rm -f *.fasl *.o *.exe
    rm -f result

# Lint code
lint:
    echo "Lisp linting would go here"

# Format code
format:
    echo "Lisp formatting would go here"
