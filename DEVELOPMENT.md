# Development Guide

This document covers the internal architecture, development setup, and contribution guidelines for the AOC Polyglot Languages library.

## Architecture Overview

### Core Components

```
aoc-polyglot-languages/
├── flake.nix              # Main flake exposing language libraries
├── lib/
│   ├── base.nix          # Common functionality and utilities
│   └── build-functions.nix # Package building functions
├── languages/            # Language-specific implementations
│   ├── python.nix
│   ├── java.nix
│   └── ...
└── justfiles/           # Task runners for each language
    ├── python.justfile
    └── ...
```

### Key Design Principles

1. **Unified API**: All languages use the same `mkDefaultOutputs` function signature
2. **Type Safety**: Package parameters are typed (e.g., `pkgs.jdk21`) not strings
3. **System Abstraction**: Languages handle cross-platform differences internally
4. **Composability**: Base functionality shared across all languages

## API Architecture

### `mkDefaultOutputs` Function

Located in `flake.nix`, this is the main entry point:

```nix
mkLangFlake = {
  src,
  description ? null,
  pname ? null,
  version ? "0.1.0",
  jdk ? null,        # JVM languages
  gcc ? null,        # C/C++
  python ? null,     # Python
  extraArgs ? {},
}:
flake-utils.lib.eachDefaultSystem (system:
  # ... implementation
)
```

The function:

1. Handles multi-system builds via `eachDefaultSystem`
2. Creates system-specific `pkgs` and base functionality
3. Imports language-specific configuration
4. Calls language's `mkStandardOutputs` with processed arguments

### Language Implementation Pattern

Each language in `languages/` follows this pattern:

```nix
{ pkgs, base, justfilePath ? null }:
let
  solution = args:
    let
      # Extract language-specific parameters
      selectedPackage = args.paramName or pkgs.defaultPackage;
    in
    let
      # Create dev shell with language tools
      devShell = base.mkLanguageShell {
        name = "Language Name";
        emoji = "🔥";
        languageTools = [ ... ];
      };
    in
    # Create solution package
    (base.mkSolution {
      language = "langname";
      package = base.buildFunctions.buildType { ... } args;
    }) // {
      devShells.default = devShell;
    };
in
{
  mkStandardOutputs = args: solution args;
}
```

### Base Library (`lib/base.nix`)

Provides common functionality:

- `mkSolution`: Creates standard flake outputs
- `mkLanguageShell`: Creates development environments
- `derivePname`: Extracts package name from source path
- `parseDescription`: Extracts metadata from description

### Build Functions (`lib/build-functions.nix`)

Language-agnostic build patterns:

- `interpreter`: For scripted languages (Python, Ruby, etc.)
- `compiler`: For compiled languages (C, Go, etc.)
- `jvm`: For JVM languages (Java, Kotlin, Scala)

## Development Setup

### Prerequisites

- Nix with flakes enabled
- Git
- direnv (recommended)

### Local Development

1. **Clone the repository:**

   ```bash
   git clone https://github.com/ritzau/aoc-polyglot-languages
   cd aoc-polyglot-languages
   ```

2. **Enter development environment:**

   ```bash
   nix develop
   # or with direnv
   echo "use flake" > .envrc && direnv allow
   ```

3. **Test changes:**

   ```bash
   # Check all outputs build
   nix flake check

   # Test specific language
   nix build .#python.packages.x86_64-darwin.default
   ```

## Adding a New Language

### 1. Create Language Implementation

Create `languages/newlang.nix`:

```nix
{ pkgs, base, justfilePath ? null }:
let
  solution = args:
    let
      # Extract language-specific parameters
      selectedTool = args.tool or pkgs.defaultTool;

      devShell = base.mkLanguageShell {
        name = "New Language";
        emoji = "🆕";
        languageTools = with pkgs; [
          selectedTool
          # other tools
        ];
      };
    in
    (base.mkSolution {
      language = "newlang";
      package = base.buildFunctions.compiler {
        compiler = selectedTool;
        fileExtensions = [ "nl" ];
        compileCommand = "${selectedTool}/bin/compile";
      } args;
    }) // {
      devShells.default = devShell;
    };
in
{
  mkStandardOutputs = args: solution args;
}
```

### 2. Add to Main Flake

In `flake.nix`, add to the languages attrset:

```nix
languages = {
  # ... existing languages
  newlang = import ./languages/newlang.nix {
    inherit pkgs;
    base = baseLib;
    justfilePath = ./justfiles/newlang.justfile;
  };
};
```

### 3. Create Justfile (Optional)

Create `justfiles/newlang.justfile` for common tasks:

```just
# Build the project
build:
    newlang-compiler main.nl

# Run the project
run: build
    ./main

# Test the project
test:
    newlang-test test.nl
```

### 4. Update Documentation

- Add language to `LANGUAGES.md`
- Add example usage to `README.md`
- Test with example project

### 5. Add Tests

Create a test directory structure:

```
tests/newlang/
├── flake.nix
├── main.nl
└── expected_output.txt
```

## Testing

### Manual Testing

```bash
# Check all languages build
nix flake check

# Test specific language builds
cd tests/python && nix build && nix run

# Test dev environments
cd tests/java && nix develop --command javac --version
```

### Automated Testing

The CI system tests:

1. All languages build successfully
2. Dev shells provide expected tools
3. Example projects run correctly
4. Cross-platform compatibility

## Architecture Decisions

### Why `mkDefaultOutputs` over `mkStandardOutputs`?

- More descriptive name indicating it provides standard flake outputs
- Aligns with Nix community conventions
- Indicates this is the primary/recommended function

### Why Typed Parameters?

Instead of `jdk = "jdk21"`, we use `jdk = pkgs.jdk21`:

**Pros:**

- Type safety at evaluation time
- IDE/LSP support for package names
- Clear dependency on specific packages
- Prevents typos in package names

**Cons:**

- More verbose syntax
- Requires knowledge of nixpkgs structure
- Platform-specific package references (current limitation)

### Why Language-Specific Files?

Each language has its own `languages/foo.nix` file:

- **Separation of concerns**: Language logic isolated
- **Maintainability**: Easy to modify one language without affecting others
- **Extensibility**: Simple to add new languages
- **Testing**: Can test languages independently

## Current Limitations

### Cross-Platform Package References

Current issue: Users must specify platform-specific packages:

```nix
python = polyglot.inputs.nixpkgs.legacyPackages.x86_64-darwin.python312;
```

**Proposed Solutions:**

1. Function-based parameters: `mkDefaultOutputs (pkgs: { python = pkgs.python312; })`
2. String-based with smart resolution: `python = "python312"`
3. Lazy evaluation with system context

### Language Coverage

Missing languages that could be added:

- Julia
- Crystal
- Nim
- V
- Odin

## Contribution Guidelines

### Pull Requests

1. **Focus**: One language or feature per PR
2. **Testing**: Include working example
3. **Documentation**: Update README.md and add to LANGUAGES.md
4. **Consistency**: Follow existing patterns and naming

### Code Style

- Use nixfmt for formatting
- Follow existing naming conventions
- Include helpful comments for complex logic
- Use descriptive commit messages

### Review Process

PRs are reviewed for:

- Correctness of Nix code
- Following architectural patterns
- Cross-platform compatibility
- Documentation completeness
- Test coverage

## Release Process

1. Update version numbers
2. Update CHANGELOG.md
3. Test across all supported platforms
4. Create GitHub release
5. Update examples to use new version

## Troubleshooting

### Common Issues

**"attribute missing" errors:**

- Check language name spelling in `polyglot.lib.LANGUAGE`
- Verify language is supported (see LANGUAGES.md)

**"function called with unexpected argument":**

- Check parameter names match language expectations
- Verify typed parameters are correct (e.g., `pkgs.jdk21` not `"jdk21"`)

**Build failures:**

- Check source files exist and have correct extensions
- Verify compiler/interpreter available for platform
- Check for platform-specific dependencies

### Debug Tips

```bash
# Show detailed build output
nix build --show-trace

# Check flake structure
nix flake show

# Inspect dev shell contents
nix develop --command which python

# Check package contents
nix build && ls -la result/
```
