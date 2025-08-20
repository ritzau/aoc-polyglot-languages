# C++ AOC Development Commands

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
    @if [ -f CMakeLists.txt ]; then \
        cd build && ctest; \
    elif [ -f Makefile ]; then \
        make test; \
    else \
        echo "No test framework configured"; \
    fi

# Clean build artifacts
clean:
    rm -rf build/ solution *.o
    rm -f result
    make clean || true

# Lint code
lint:
    @if command -v clang-tidy >/dev/null 2>&1; then \
        clang-tidy *.cpp -- -std=c++20; \
    else \
        echo "clang-tidy not available"; \
    fi

# Format code
format:
    @if command -v clang-format >/dev/null 2>&1; then \
        clang-format -i *.cpp *.hpp; \
    else \
        echo "clang-format not available"; \
    fi
