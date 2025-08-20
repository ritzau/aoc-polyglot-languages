# Dart AOC Development Commands

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
    dart test

# Clean build artifacts
clean:
    rm -rf .dart_tool/ pubspec.lock && rm -f result

# Lint code
lint:
    dart analyze

# Format code
format:
    dart format *.dart
