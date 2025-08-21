{
  description = "Polyglot language environments for Advent of Code solutions";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        # Import base functionality
        base = import ./lib/base.nix { inherit pkgs; };
        buildFunctions = import ./lib/build-functions.nix { inherit pkgs; };

        # Combine base functionality
        baseLib = base // {
          inherit buildFunctions;
          mkJustfile = base.mkJustfile self;
        };

        # Import all language definitions
        languages = {
          c = import ./languages/c.nix {
            inherit pkgs;
            base = baseLib;
            justfilePath = ./justfiles/c.justfile;
          };
          cpp = import ./languages/cpp.nix {
            inherit pkgs;
            base = baseLib;
            justfilePath = ./justfiles/cpp.justfile;
          };
          python = import ./languages/python.nix {
            inherit pkgs;
            base = baseLib;
            justfilePath = ./justfiles/python.justfile;
          };
          rust = import ./languages/rust.nix {
            inherit pkgs;
            base = baseLib;
            justfilePath = ./justfiles/rust.justfile;
          };
          go = import ./languages/go.nix {
            inherit pkgs;
            base = baseLib;
            justfilePath = ./justfiles/go.justfile;
          };
          haskell = import ./languages/haskell.nix {
            inherit pkgs;
            base = baseLib;
            justfilePath = ./justfiles/haskell.justfile;
          };
          javascript = import ./languages/javascript.nix {
            inherit pkgs;
            base = baseLib;
            justfilePath = ./justfiles/javascript.justfile;
          };
          typescript = import ./languages/typescript.nix {
            inherit pkgs;
            base = baseLib;
            justfilePath = ./justfiles/typescript.justfile;
          };
          java = import ./languages/java.nix {
            inherit pkgs;
            base = baseLib;
            justfilePath = ./justfiles/java.justfile;
          };
          kotlin = import ./languages/kotlin.nix {
            inherit pkgs;
            base = baseLib;
            justfilePath = ./justfiles/kotlin.justfile;
          };
          d = import ./languages/d.nix {
            inherit pkgs;
            base = baseLib;
            justfilePath = ./justfiles/d.justfile;
          };
          swift = import ./languages/swift.nix {
            inherit pkgs;
            base = baseLib;
            justfilePath = ./justfiles/swift.justfile;
          };
          zig = import ./languages/zig.nix {
            inherit pkgs;
            base = baseLib;
            justfilePath = ./justfiles/zig.justfile;
          };
          nim = import ./languages/nim.nix {
            inherit pkgs;
            base = baseLib;
            justfilePath = ./justfiles/nim.justfile;
          };
          scala = import ./languages/scala.nix {
            inherit pkgs;
            base = baseLib;
            justfilePath = ./justfiles/scala.justfile;
          };
          elixir = import ./languages/elixir.nix {
            inherit pkgs;
            base = baseLib;
            justfilePath = ./justfiles/elixir.justfile;
          };
          dart = import ./languages/dart.nix {
            inherit pkgs;
            base = baseLib;
            justfilePath = ./justfiles/dart.justfile;
          };
          csharp = import ./languages/csharp.nix {
            inherit pkgs;
            base = baseLib;
            justfilePath = ./justfiles/csharp.justfile;
          };
          cobol = import ./languages/cobol.nix {
            inherit pkgs;
            base = baseLib;
            justfilePath = ./justfiles/cobol.justfile;
          };
          r = import ./languages/r.nix {
            inherit pkgs;
            base = baseLib;
            justfilePath = ./justfiles/r.justfile;
          };
          php = import ./languages/php.nix {
            inherit pkgs;
            base = baseLib;
            justfilePath = ./justfiles/php.justfile;
          };
          lua = import ./languages/lua.nix {
            inherit pkgs;
            base = baseLib;
            justfilePath = ./justfiles/lua.justfile;
          };
          perl = import ./languages/perl.nix {
            inherit pkgs;
            base = baseLib;
            justfilePath = ./justfiles/perl.justfile;
          };
          ruby = import ./languages/ruby.nix {
            inherit pkgs;
            base = baseLib;
            justfilePath = ./justfiles/ruby.justfile;
          };
          ocaml = import ./languages/ocaml.nix {
            inherit pkgs;
            base = baseLib;
            justfilePath = ./justfiles/ocaml.justfile;
          };
          clojure = import ./languages/clojure.nix {
            inherit pkgs;
            base = baseLib;
            justfilePath = ./justfiles/clojure.justfile;
          };
          lisp = import ./languages/lisp.nix {
            inherit pkgs;
            base = baseLib;
            justfilePath = ./justfiles/lisp.justfile;
          };
          fortran = import ./languages/fortran.nix {
            inherit pkgs;
            base = baseLib;
            justfilePath = ./justfiles/fortran.justfile;
          };
          ada = import ./languages/ada.nix {
            inherit pkgs;
            base = baseLib;
            justfilePath = ./justfiles/ada.justfile;
          };
          tcl = import ./languages/tcl.nix {
            inherit pkgs;
            base = baseLib;
            justfilePath = ./justfiles/tcl.justfile;
          };
        }
        // pkgs.lib.optionalAttrs (pkgs.stdenv.isLinux) {
          # Linux-only languages due to package availability
          julia = import ./languages/julia.nix {
            inherit pkgs;
            base = baseLib;
            justfilePath = ./justfiles/julia.justfile;
          };
          objc = import ./languages/objc.nix {
            inherit pkgs;
            base = baseLib;
            justfilePath = ./justfiles/objc.justfile;
          };
          smalltalk = import ./languages/smalltalk.nix {
            inherit pkgs;
            base = baseLib;
            justfilePath = ./justfiles/smalltalk.justfile;
          };
        };

      in
      {
        # Universal development shell with all tools
        devShells = {
          default = base.mkLanguageShell {
            name = "AOC Polyglot";
            emoji = "🎄";
            languageTools = [ ]; # No language-specific tools in universal shell
            extraShellHook = ''
              echo "Available languages: c, cpp, python, rust, go, haskell, javascript, etc."
              echo "Navigate to solution directories to get language-specific environments"
              echo "Run 'nix develop .#<language>' to enter specific language shells"
            '';
          };
        }
        // builtins.mapAttrs (_: lang: lang.devShell) languages;

        # Expose solution builders for each language
        lib =
          builtins.mapAttrs (_: lang: {
            mkStandardOutputs = lang.mkStandardOutputs;
          }) languages
          // {
            # Simplified flake template
            mkSimpleFlake = base.mkSimpleFlake languages flake-utils;
          };

        # Expose justfiles for each language
        justfiles = {
          c = ./justfiles/c.justfile;
          cpp = ./justfiles/cpp.justfile;
          python = ./justfiles/python.justfile;
          rust = ./justfiles/rust.justfile;
          go = ./justfiles/go.justfile;
          haskell = ./justfiles/haskell.justfile;
          javascript = ./justfiles/javascript.justfile;
          typescript = ./justfiles/typescript.justfile;
          java = ./justfiles/java.justfile;
          kotlin = ./justfiles/kotlin.justfile;
          d = ./justfiles/d.justfile;
          swift = ./justfiles/swift.justfile;
          zig = ./justfiles/zig.justfile;
          nim = ./justfiles/nim.justfile;
          scala = ./justfiles/scala.justfile;
          elixir = ./justfiles/elixir.justfile;
          dart = ./justfiles/dart.justfile;
          csharp = ./justfiles/csharp.justfile;
          cobol = ./justfiles/cobol.justfile;
          r = ./justfiles/r.justfile;
          php = ./justfiles/php.justfile;
          lua = ./justfiles/lua.justfile;
          perl = ./justfiles/perl.justfile;
          ruby = ./justfiles/ruby.justfile;
          ocaml = ./justfiles/ocaml.justfile;
          clojure = ./justfiles/clojure.justfile;
          lisp = ./justfiles/lisp.justfile;
          fortran = ./justfiles/fortran.justfile;
          ada = ./justfiles/ada.justfile;
          tcl = ./justfiles/tcl.justfile;
        }
        // pkgs.lib.optionalAttrs (pkgs.stdenv.isLinux) {
          # Linux-only language justfiles
          julia = ./justfiles/julia.justfile;
          objc = ./justfiles/objc.justfile;
          smalltalk = ./justfiles/smalltalk.justfile;
        };

        # Also expose the base functionality for custom use
        baseLib = baseLib;
      }
    );
}
