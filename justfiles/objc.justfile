# Objective-C AOC Development Commands

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
    echo "Objective-C testing would go here"

# Clean build artifacts
clean:
    rm -f *.o *.exe hello-objc
    rm -f result

# Lint code
lint:
    echo "Objective-C linting would go here"

# Format code
format:
    echo "Objective-C formatting would go here"
