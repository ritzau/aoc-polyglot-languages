# PHP AOC Development Commands

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
    echo "PHP testing would go here"

# Clean build artifacts
clean:
    rm -f result

# Lint code
lint:
    php -l *.php || echo "PHP syntax check would go here"

# Format code
format:
    echo "PHP formatting would go here"
