# Scala AOC Development Commands

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
    sbt test

# Clean build artifacts
clean:
    rm -rf *.class target/ project/target/
    rm -f result

# Lint code
lint:
    echo "Scala linting would go here"

# Format code
format:
    scalafmt *.scala
