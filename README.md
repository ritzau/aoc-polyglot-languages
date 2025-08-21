# AOC Polyglot Languages

A Nix flake library providing language environments and build functions for Advent of Code solutions across 21+ programming languages.

## Features

- **21+ Languages**: Java, Kotlin, Scala, Python, C, C++, Rust, Go, Zig, Clojure, D, Fortran, Swift, Tcl, Perl, Ruby, PHP, Haskell, OCaml, Elixir, Lisp, and more
- **Unified API**: Simple `mkDefaultOutputs` function for all languages
- **Type Safety**: Typed package parameters (e.g., `jdk = pkgs.jdk21`, `python = pkgs.python312`)
- **Cross-Platform**: Works on macOS, Linux (x86_64, aarch64)
- **Dev Environments**: Language-specific development shells with tools and libraries
- **Build Systems**: Automatic package creation with apps, checks, and development shells

## Quick Start

### Basic Usage

Create a `flake.nix` for any supported language:

```nix
{
  description = "Hello World Python";

  inputs = {
    polyglot.url = "github:ritzau/aoc-polyglot-languages";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, polyglot, ... }:
    polyglot.lib.python.mkDefaultOutputs {
      inherit (self) description;
      src = ./.;
    };
}
```

### Language-Specific Examples

**Java with JDK 21:**

```nix
polyglot.lib.java.mkDefaultOutputs {
  inherit (self) description;
  src = ./.;
  jdk = pkgs.jdk21;
}
```

**C with GCC:**

```nix
polyglot.lib.c.mkDefaultOutputs {
  inherit (self) description;
  src = ./.;
  gcc = pkgs.gcc;
}
```

**Python with Custom Version:**

```nix
polyglot.lib.python.mkDefaultOutputs {
  inherit (self) description;
  src = ./.;
  python = pkgs.python312;
}
```

## Supported Languages

### JVM Languages

- **Java** - With configurable JDK version
- **Kotlin** - JVM target with JDK selection
- **Scala** - With sbt and configurable JDK

### Systems Languages

- **C** - With configurable GCC version
- **C++** - With g++ and common libraries
- **Rust** - With Cargo and development tools
- **Go** - With Go toolchain and common packages
- **Zig** - With Zig compiler and tools

### Scripting Languages

- **Python** - With configurable version and scientific libraries (NumPy, NetworkX, etc.)
- **Perl** - With CPAN modules
- **Ruby** - With gems and development tools
- **PHP** - With Composer and extensions

### Functional Languages

- **Haskell** - With GHC and common packages
- **OCaml** - With OPAM and development environment
- **Elixir** - With Mix and OTP
- **Lisp** - With SBCL and Quicklisp

### Other Languages

- **Clojure** - With Leiningen and tools
- **D** - With LDC compiler
- **Fortran** - With gfortran
- **Swift** - With Swift compiler (macOS/Linux)
- **Tcl** - With Tcl/Tk environment

## API Reference

### `mkDefaultOutputs`

Creates a complete flake with packages, apps, checks, and dev shells.

**Parameters:**

- `src` - Source directory (usually `./`)
- `description` - Package description (usually `inherit (self) description`)
- `pname` - Package name (optional, auto-derived from directory)
- `version` - Package version (default: "0.1.0")
- Language-specific parameters:
  - `jdk` - JDK package for JVM languages
  - `gcc` - GCC package for C/C++
  - `python` - Python package for Python

**Returns:**

- `packages.default` - Built executable package
- `apps.default` - Runnable application
- `devShells.default` - Development environment
- `checks.build` - Build verification

## Development Environment

Each language provides a rich development environment:

```bash
# Enter development shell
nix develop

# Build the package
nix build

# Run the application
nix run

# Run tests (if available)
nix flake check
```

### Available Tools

Development shells include:

- Language-specific compiler/interpreter
- Package managers (cargo, npm, pip, etc.)
- Development tools (LSP, formatters, linters)
- Common AOC libraries (data structures, algorithms)
- Universal tools (git, rg, fd, bat, jq, hyperfine)

## File Structure

Your project should have:

```
your-project/
├── flake.nix          # Flake configuration
├── .envrc             # direnv configuration (optional)
├── source files       # Your code (main.rs, solution.py, etc.)
└── input files        # AOC input data
```

## Integration with AOC Workflows

This library is designed to work with AOC solution repositories:

1. **Multi-language solutions**: Each day/language gets its own directory with a simple flake
2. **Benchmarking**: Use `hyperfine` to compare solutions across languages
3. **Testing**: Built-in support for example input validation
4. **Development**: Language-specific shells with AOC-relevant libraries

## Examples

See the `examples/` directory for complete working examples of each supported language.

## Contributing

See [DEVELOPMENT.md](DEVELOPMENT.md) for contribution guidelines, architecture details, and development setup.

## License

MIT License - see LICENSE file for details.
