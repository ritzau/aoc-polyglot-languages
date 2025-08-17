# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a polyglot Advent of Code (AOC) repository using Nix flakes and direnv for reproducible development environments. The project supports multiple programming languages with hierarchical flake inheritance.

## Directory Structure

```
aoc-nix/
├── flake.nix                    # Root flake with common tools
├── .envrc                       # Root direnv config  
├── languages/                   # Language-specific flakes
│   ├── rust/flake.nix          # Rust toolchain + dependencies
│   ├── python/flake.nix        # Python + common packages
│   ├── haskell/flake.nix       # GHC + common packages
│   ├── javascript/flake.nix    # Node.js + TypeScript
│   └── go/flake.nix            # Go toolchain
├── inputs/                      # Shared input files (symlinked)
│   └── YEAR/dayXX.txt
└── solutions/                   # Year/day/language solutions
    └── YEAR/dayXX/LANGUAGE/     # Individual solution flakes
```

## Development Environment

This project uses Nix flakes with direnv for automatic environment switching:

- `nix develop` - Enter the root development shell
- `direnv allow` - Enable automatic environment switching
- Navigate to any solution directory to get language-specific tools

## Common Development Commands

**Root level:**
- `nix flake update` - Update all flake dependencies
- `hyperfine` - Benchmark solutions across languages

**Rust solutions (solutions/YEAR/dayXX/rust/):**
- `cargo run` - Run the solution
- `cargo test` - Run tests
- `cargo watch -x run` - Watch and run on changes
- `bacon` - Background code checker

**Python solutions (solutions/YEAR/dayXX/python/):**
- `python solution.py` - Run the solution
- `pytest` - Run tests
- `black .` - Format code
- `mypy solution.py` - Type check

**Haskell solutions (solutions/YEAR/dayXX/haskell/):**
- `runhaskell Solution.hs` - Run the solution
- `ghcid` - Interactive development
- `hlint Solution.hs` - Linting
- `ormolu Solution.hs` - Format code

**JavaScript/TypeScript solutions (solutions/YEAR/dayXX/javascript/):**
- `node solution.js` - Run JS solution
- `ts-node solution.ts` - Run TS solution
- `npm test` - Run tests
- `eslint solution.ts` - Lint code

**Go solutions (solutions/YEAR/dayXX/go/):**
- `go run main.go` - Run the solution
- `go test` - Run tests
- `go fmt` - Format code
- `golangci-lint run` - Lint code

## Project Architecture

**Flake Hierarchy:**
- Root flake: Common tools (git, direnv, benchmarking)
- Language flakes: Language-specific toolchains and libraries
- Solution flakes: Inherit from language flakes + solution-specific deps

**Input Management:**
- Input files stored in `inputs/YEAR/dayXX.txt`
- Symlinked to solution directories as `input`
- Personal input files are gitignored per AOC guidelines

**Solution Structure:**
- Each solution is self-contained with its own flake
- Solutions include example tests using AOC example inputs
- Template structure for quick setup of new solutions

## Creating New Solutions

1. **Create solution directory:**
   ```bash
   mkdir -p solutions/2024/day01/rust
   cd solutions/2024/day01/rust
   ```

2. **Copy template files:**
   - Use existing solutions as templates
   - Ensure proper flake.nix inheritance
   - Add .envrc file: `echo "use flake" > .envrc`

3. **Link input file:**
   ```bash
   ln -s ../../../../inputs/2024/day01.txt input
   ```

4. **Enable direnv:**
   ```bash
   direnv allow
   ```

## Language-Specific Notes

**Rust:** Solutions include Cargo.toml and can be built as packages
**Python:** Uses Python 3.11 with common AOC libraries (numpy, networkx, etc.)
**Haskell:** Uses GHC 9.6.4 with HLS for development
**JavaScript:** Supports both JS and TS with Node.js 20
**Go:** Uses Go 1.21 with common development tools