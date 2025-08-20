# Elixir AOC Development Commands

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
    mix test

# Clean build artifacts
clean:
    mix clean
    rm -rf _build/ deps/
    rm -f result

# Lint code
lint:
    mix credo

# Format code
format:
    mix format
