# Standard AOC Development Commands Template
# Import this file and override specific commands as needed

# Show available commands
default:
    @just --list

# Build the solution (via nix build)
build:
    nix build

# Run the solution (via nix run)
run:
    nix run

# Run tests (override per language)
test:
    echo "No test command configured for this language"

# Clean build artifacts (override per language)
clean:
    rm -f result

# Lint code (override per language)
lint:
    echo "No lint command configured for this language"

# Format code (override per language)
format:
    echo "No format command configured for this language"
