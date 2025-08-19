# Julia AOC Development Commands

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
    julia --project=. -e "using Pkg; Pkg.test()"

# Clean build artifacts
clean:
    rm -rf Manifest.toml .julia/
    rm -f result

# Lint code
lint:
    echo "Julia linting would go here"

# Format code
format:
    julia -e "using JuliaFormatter; format(\".\")" || echo "JuliaFormatter not available"
