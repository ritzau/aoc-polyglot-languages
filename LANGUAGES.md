# Language Support Status

This document tracks the current status of all supported languages in the AOC polyglot environment, including test results and known issues.

## ✅ Working Languages (25)

These languages are fully functional and ready for Advent of Code challenges:

| Language       | Status     | Test Result                        |
| -------------- | ---------- | ---------------------------------- |
| **C**          | ✅ Working | "Hello, World from C! 🔧"          |
| **C++**        | ✅ Working | "Hello, World from C++! ⚡"        |
| **Clojure**    | ✅ Working | "Hello, World from Clojure! 🔁"    |
| **D**          | ✅ Working | "Hello, World from D! 🎯"          |
| **Elixir**     | ✅ Working | "Hello, World from Elixir! 💧"     |
| **Fortran**    | ✅ Working | "Hello, World from Fortran! 🏗️"    |
| **Go**         | ✅ Working | "Hello, World from Go! 🐹"         |
| **Haskell**    | ✅ Working | "Hello, World from Haskell! λ"     |
| **Java**       | ✅ Working | "Hello, World from Java! ☕"       |
| **JavaScript** | ✅ Working | "Hello, World from JavaScript! 🟨" |
| **Kotlin**     | ✅ Working | "Hello, World from Kotlin! 🎯"     |
| **Lisp**       | ✅ Working | "Hello, World from Lisp! 🔥"       |
| **Nim**        | ✅ Working | "Hello, World from Nim! 👑"        |
| **OCaml**      | ✅ Working | "Hello, World from OCaml! 🐫"      |
| **Perl**       | ✅ Working | "Hello, World from Perl! 🐪"       |
| **PHP**        | ✅ Working | "Hello, World from PHP! 🐘"        |
| **Python**     | ✅ Working | "Hello, World from Python! 🐍"     |
| **R**          | ✅ Working | "Hello, World from R! 📊"          |
| **Ruby**       | ✅ Working | "Hello, World from Ruby! 💎"       |
| **Rust**       | ✅ Working | "Hello, World from Rust! 🦀"       |
| **Scala**      | ✅ Working | "Hello, World from Scala! 🎭"      |
| **Swift**      | ✅ Working | "Hello, World from Swift! 🦉"      |
| **Tcl**        | ✅ Working | "Hello, World from Tcl! 🪶"        |
| **TypeScript** | ✅ Working | "Hello, World from TypeScript! 📘" |
| **Zig**        | ✅ Working | "Hello, World from Zig! ⚡"        |

## ❌ Known Issues (8)

### Linux-Only Languages (3)

These languages are only available on Linux platforms:

| Language        | Issue      | Error                           |
| --------------- | ---------- | ------------------------------- |
| **Julia**       | Linux-only | `attribute 'julia' missing`     |
| **Objective-C** | Linux-only | `attribute 'objc' missing`      |
| **Smalltalk**   | Linux-only | `attribute 'smalltalk' missing` |

### Build Configuration Issues (5)

These languages have build or runtime configuration problems:

| Language  | Issue                  | Error                                                           |
| --------- | ---------------------- | --------------------------------------------------------------- |
| **Ada**   | Missing name attribute | `attribute 'name' missing`                                      |
| **C#**    | Binary format issue    | `Exec format error`                                             |
| **COBOL** | Build failure          | gnucobol documentation build failed                             |
| **Dart**  | Missing name parameter | `writeShellApplication called without required argument 'name'` |
| **Lua**   | Missing name parameter | `writeShellApplication called without required argument 'name'` |

## Testing Information

**Results Summary:**

- **Total Languages:** 33
- **Working:** 25 (76%)
- **Known Issues:** 8 (24%)
- **Success Rate:** 76%

**Test Environment:**

- Platform: macOS (Darwin)
- Date: 2025-08-21
- Flake Version: 51fc0f259151ca0a1c28b30ac89b4437787cc141
- Method: Systematic testing using `nix run` and `nix build`
- Recent Fixes: JavaScript/TypeScript build issues, Nim cache directory, Python configuration
- Result: All recent fixes use mkDefaultOutputs API with typed parameters

## Complete Language List

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

## Contributing

### Fixing Failing Languages

To fix failing languages:

1. **Missing Build Functions:** Implement the missing build functions in `lib/build-functions.nix`
2. **Linux-Only Languages:** These are platform-specific and expected to fail on macOS
3. **Build Issues:** Check language-specific configuration in `languages/[language].nix`

### Adding New Languages

When adding support for new languages:

1. Follow the established patterns in existing language implementations
2. Ensure the language toolchain is reliably available in nixpkgs
3. Test on both macOS and Linux if possible
4. Update this documentation with the new language
5. Add appropriate emoji for the language's development shell

### Current Architecture Status

- **Total Supported**: 33 languages
- **Working Languages**: 25 (76%) fully functional for AOC challenges
- **All Languages**: Use unified `mkDefaultOutputs` API with typed parameters
- **All Languages**: Have consistent development environments with tools
- **All Languages**: Include working hello world examples
- **All Languages**: Use minimal 15-line flake configurations
- **Recent Improvements**: Fixed JavaScript/TypeScript Node.js issues, Nim cache, Python configuration
- **API Migration**: All working languages now use simplified `mkDefaultOutputs` pattern
