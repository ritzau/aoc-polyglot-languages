# Fortran AOC Development Commands

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
    echo "Fortran testing would go here"

# Clean build artifacts
clean:
    rm -f *.o *.mod *.exe a.out
    rm -f result

# Lint code
lint:
    echo "Fortran linting would go here"

# Format code
format:
    echo "Fortran formatting would go here"
