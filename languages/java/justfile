# Java AOC Development Commands

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
    @if [ -f build.gradle ] || [ -f build.gradle.kts ]; then \
        gradle test; \
    elif [ -f pom.xml ]; then \
        mvn test; \
    else \
        echo "No test framework configured"; \
    fi

# Clean build artifacts
clean:
    @if [ -f build.gradle ] || [ -f build.gradle.kts ]; then \
        gradle clean; \
    elif [ -f pom.xml ]; then \
        mvn clean; \
    else \
        rm -f *.class; \
    fi
    rm -f result

# Lint code
lint:
    @if [ -f build.gradle ] || [ -f build.gradle.kts ]; then \
        gradle check; \
    elif [ -f pom.xml ]; then \
        mvn checkstyle:check; \
    else \
        echo "No linter configured"; \
    fi

# Format code
format:
    @if [ -f build.gradle ] || [ -f build.gradle.kts ]; then \
        gradle spotlessApply; \
    elif [ -f pom.xml ]; then \
        mvn spotless:apply; \
    else \
        echo "No formatter configured"; \
    fi
