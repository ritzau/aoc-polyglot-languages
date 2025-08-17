# AOC Polyglot Task Runner

# Show available commands
default:
    @just --list

# Update all flakes
update:
    nix flake update
    @echo "Root flake updated"
    @for solution in solutions/*/*/* solutions/hello/*; do \
        if [ -d "$solution" ] && [ -f "$solution/flake.nix" ]; then \
            echo "Updating $solution..."; \
            cd "$solution" && nix flake update && cd - > /dev/null; \
        fi \
    done

# Build all solutions (compiled languages only)
build-all:
    @echo "Building compiled AOC solutions..."
    @for solution in solutions/*/*/rust solutions/*/*/go solutions/*/*/cpp solutions/*/*/c solutions/*/*/zig solutions/*/*/d solutions/*/*/nim solutions/*/*/swift solutions/hello/rust solutions/hello/go solutions/hello/cpp solutions/hello/c solutions/hello/zig solutions/hello/d solutions/hello/nim solutions/hello/swift solutions/hello/ada; do \
        if [ -d "$solution" ] && [ -f "$solution/flake.nix" ]; then \
            echo "Building $solution..."; \
            nix build ./"$solution" --impure || echo "Failed to build $solution"; \
        fi \
    done
    @echo "Done! (Skipped interpreted languages)"

# Check all solutions
check-all:
    @echo "Checking all AOC solutions..."
    @for solution in solutions/*/*/* solutions/hello/*; do \
        if [ -d "$solution" ] && [ -f "$solution/flake.nix" ]; then \
            echo "Checking $solution..."; \
            nix flake check ./"$solution" --impure || echo "Failed to check $solution"; \
        fi \
    done
    @echo "Done!"

# Build specific solution: just build 2024 01 rust
build year day lang:
    nix build ./solutions/{{year}}/day{{day}}/{{lang}} --impure

# Run specific solution: just run 2024 01 rust
run year day lang:
    cd solutions/{{year}}/day{{day}}/{{lang}} && nix run . --impure

# Test specific solution: just test 2024 01 rust
test year day lang:
    @if [ -d "solutions/{{year}}/day{{day}}/{{lang}}" ]; then \
        echo "Testing solutions/{{year}}/day{{day}}/{{lang}}..."; \
        cd solutions/{{year}}/day{{day}}/{{lang}}; \
        case "{{lang}}" in \
            rust) cargo test ;; \
            go) go test ;; \
            python) pytest ;; \
            typescript|javascript) npm test ;; \
            java) gradle test || mvn test ;; \
            kotlin) gradle test ;; \
            scala) sbt test ;; \
            csharp) dotnet test ;; \
            julia) julia --project=. -e "using Pkg; Pkg.test()" ;; \
            elixir) mix test ;; \
            dart) dart test ;; \
            swift) swift test ;; \
            nim) nimble test ;; \
            d) dub test ;; \
            zig) zig test solution.zig ;; \
            *) echo "No standard test command for {{lang}}" ;; \
        esac \
    else \
        echo "Solution not found: solutions/{{year}}/day{{day}}/{{lang}}"; \
    fi

# Benchmark solutions for a specific day: just bench 2024 01
bench year day:
    @echo "Benchmarking day {{day}} {{year}}..."
    @solutions=""
    @for lang in rust go cpp c zig d nim python typescript javascript java kotlin scala swift csharp dart elixir julia haskell; do \
        if [ -d "solutions/{{year}}/day{{day}}/$lang" ]; then \
            solutions="$solutions solutions/{{year}}/day{{day}}/$lang"; \
        fi \
    done
    @if [ -n "$solutions" ]; then \
        echo "Found solutions:$solutions"; \
        echo "Building solutions first..."; \
        for solution in $solutions; do \
            nix build ./"$solution"; \
        done; \
        echo "Running benchmarks..."; \
        hyperfine --warmup 3 \
            --export-markdown bench-{{year}}-day{{day}}.md \
            $(for solution in $solutions; do \
                echo "cd $solution && nix run ."; \
            done); \
    else \
        echo "No solutions found for {{year}} day {{day}}"; \
    fi

# Create new solution template: just new 2024 01 rust
new year day lang:
    @mkdir -p solutions/{{year}}/day{{day}}/{{lang}}
    @if [ ! -f "solutions/{{year}}/day{{day}}/{{lang}}/flake.nix" ]; then \
        cp -r solutions/2024/day01/{{lang}}/* solutions/{{year}}/day{{day}}/{{lang}}/; \
        echo "Created solutions/{{year}}/day{{day}}/{{lang}} from template"; \
    else \
        echo "Solution already exists: solutions/{{year}}/day{{day}}/{{lang}}"; \
    fi

# Clean all build artifacts
clean:
    @echo "Cleaning build artifacts..."
    @find . -name result -type l -delete
    @find . -name target -type d -exec rm -rf {} + 2>/dev/null || true
    @find . -name node_modules -type d -exec rm -rf {} + 2>/dev/null || true
    @find . -name __pycache__ -type d -exec rm -rf {} + 2>/dev/null || true
    @echo "Clean complete!"

# Show system information
info:
    @nix run nixpkgs#fastfetch

# Set up pre-commit hooks (run once)
setup-hooks:
    pre-commit install

# Format all files
format:
    pre-commit run --all-files

# Run specific formatter on changed files
format-changed:
    pre-commit run