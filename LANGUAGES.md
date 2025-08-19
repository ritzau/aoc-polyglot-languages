# Language Support Status

This document tracks the current language support status and lists potential languages for future implementation.

## Currently Supported Languages (33)

### Systems Programming

- **C** 🔧 - GCC compiler with Make build system
- **C++** ⚙️ - GCC compiler with CMake build system
- **Rust** 🦀 - Cargo build system with comprehensive toolchain
- **Go** 🐹 - Go toolchain with module support
- **Zig** ⚡ - Zig compiler with build system
- **Nim** 👑 - Nim compiler with package manager
- **D** 🎯 - DMD compiler with DUB package manager
- **Swift** 🐦 - Swift compiler (macOS/Linux)
- **Fortran** 🏗️ - gfortran compiler for scientific computing
- **Ada** 🏛️ - GNAT compiler for safety-critical systems

### JVM Ecosystem

- **Java** ☕ - OpenJDK with Gradle/Maven support
- **Scala** 🎭 - Scala compiler with sbt build tool
- **Kotlin** 🎪 - Kotlin compiler with Gradle support
- **Clojure** 🔁 - Clojure with Leiningen/CLI tools

### Functional Programming

- **Haskell** λ - GHC compiler with Cabal/Stack
- **OCaml** 🐫 - OCaml compiler with opam package manager
- **Elixir** 💧 - Elixir with Mix build tool
- **Lisp** 🔥 - SBCL (Steel Bank Common Lisp)

### Scripting & Dynamic Languages

- **Python** 🐍 - Python 3 with pip and common libraries
- **JavaScript** 🟨 - Node.js runtime
- **TypeScript** 📘 - TypeScript compiler with Node.js
- **Perl** 🐪 - Perl interpreter with CPAN
- **Ruby** 💎 - Ruby interpreter with gems
- **PHP** 🐘 - PHP interpreter
- **Lua** 🌙 - Lua interpreter
- **R** 📊 - R statistical computing environment
- **Tcl** 🪶 - Tcl/Tk interpreter

### Enterprise & Legacy

- **C#** 💼 - .NET runtime and compiler
- **COBOL** 🏢 - GnuCOBOL compiler for legacy systems

### Modern Languages

- **Dart** 🎯 - Dart SDK for cross-platform development
- **Julia** 🔢 - Julia for scientific computing

### Object-Oriented

- **Objective-C** 🍎 - Clang with Foundation framework
- **Smalltalk** 💬 - GNU Smalltalk environment

## Potential Future Languages

### High Priority - Available in Nixpkgs

#### Logic & Constraint Programming

- **Prolog** - Available via `swi-prolog` - Logic programming paradigm
- **Erlang** - Available - Concurrent/distributed programming (we have Elixir but not pure Erlang)

#### Functional Programming

- **Racket** - Available - Modern Lisp dialect with great tooling
- **Scheme** - Available via `guile`, `chicken`, `mit-scheme` - Classic Lisp
- **Standard ML** - Available via `smlnj` - Academic functional language
- **F#** - Available - Functional .NET language

#### Modern Systems Languages

- **Crystal** - Available - Ruby-like syntax with static typing and performance
- **V** - Might be available - Simple, fast systems language

#### Specialized Languages

- **Octave** - Available - MATLAB-compatible scientific computing
- **Forth** - Available via `gforth` - Stack-based concatenative language
- **Vala** - Available - C#-like syntax that compiles to C
- **Assembly** - Available via `nasm`, `gas` - Low-level programming

#### Shell/Text Processing

- **Awk** - Available via `gawk`/`mawk` - Text processing
- **Bash** - Available - Shell scripting
- **Fish** - Available - Modern shell with scripting
- **PowerShell** - Available - Microsoft's cross-platform shell

### Medium Priority - Research Needed

#### Educational/Research Languages

- **COMAL** - Educational language, availability uncertain
- **J** - Array programming language, might be available
- **APL** - Array programming, might have open implementations

### Low Priority - Esoteric/Niche

#### Esoteric Languages

- **Brainfuck** - Esoteric language, interpreters might exist
- **Befunge** - Stack-based esoteric language
- **Malbolge** - Deliberately difficult esoteric language

### Not Feasible - Proprietary/Platform-Specific

#### Commercial/Proprietary

- **Visual Basic** - Windows-specific, proprietary
- **Delphi/Object Pascal** - Some free implementations exist but limited
- **ABAP** - SAP proprietary
- **Apex** - Salesforce proprietary
- **LabVIEW** - National Instruments proprietary
- **MATLAB** - MathWorks proprietary (Octave available as alternative)

## Implementation Notes

### Adding New Languages

To add a new language to the polyglot setup:

1. **Check Availability**: Verify the language toolchain is available in nixpkgs
2. **Create Language Flake**: Implement `languages/{language}/flake.nix` with:
   - Unified build system using `mkStandardOutputs`
   - Development shell with `mkLanguageShell`
   - Appropriate emoji and toolchain
3. **Add Justfile**: Create `languages/{language}/justfile` with standard commands
4. **Create Hello Sample**: Implement `solutions/hello/{language}/` with:
   - Ultra-minimal flake using the language flake
   - Solution-specific justfile with import
   - Working hello world program
5. **Test Integration**: Verify `nix build`, `nix run`, and `just` commands work

### Language Selection Criteria

When considering new languages, prioritize based on:

1. **Availability**: Must be available in nixpkgs
2. **Relevance**: Useful for competitive programming or educational purposes
3. **Paradigm Coverage**: Fills gaps in programming paradigm representation
4. **Community Interest**: Popular or historically significant languages
5. **Maintenance**: Stable toolchain with active development

### Current Status

- **Total Supported**: 33 languages
- **All Languages**: Use unified build system with `nix build`/`nix run`
- **All Languages**: Have consistent `just` command interface
- **All Languages**: Include working hello world examples
- **All Languages**: Use 6-8 line ultra-minimal solution flakes

## Contributing

When adding support for new languages:

1. Follow the established patterns in existing language implementations
2. Ensure the language toolchain is reliably available in nixpkgs
3. Test on both macOS and Linux if possible
4. Update this documentation with the new language
5. Add appropriate emoji for the language's development shell
