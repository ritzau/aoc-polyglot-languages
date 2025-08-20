# Kotlin AOC Development Commands

# Show available commands
default:
    @just --list

# Build the solution (via nix build)
build:
    nix build

# Run the solution (via nix run)
run:
    nix run

# Run tests (via gradle if available)
test:
    @if [ -f build.gradle ] || [ -f build.gradle.kts ]; then \
        gradle test; \
    else \
        echo "No test framework configured for pure kotlinc builds"; \
    fi

# Clean build artifacts
clean:
    rm -rf build/ *.jar *.class
    rm -f result

# Lint code (via gradle if available)
lint:
    @if [ -f build.gradle ] || [ -f build.gradle.kts ]; then \
        gradle ktlintCheck; \
    else \
        echo "No linter configured for pure kotlinc builds"; \
    fi

# Format code (via gradle if available)
format:
    @if [ -f build.gradle ] || [ -f build.gradle.kts ]; then \
        gradle ktlintFormat; \
    else \
        echo "No formatter configured for pure kotlinc builds"; \
    fi
