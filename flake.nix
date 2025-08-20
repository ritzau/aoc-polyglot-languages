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
          };
          cpp = import ./languages/cpp.nix {
            inherit pkgs;
            base = baseLib;
          };
          python = import ./languages/python.nix {
            inherit pkgs;
            base = baseLib;
          };
          rust = import ./languages/rust.nix {
            inherit pkgs;
            base = baseLib;
          };
          go = import ./languages/go.nix {
            inherit pkgs;
            base = baseLib;
          };
          haskell = import ./languages/haskell.nix {
            inherit pkgs;
            base = baseLib;
          };
          javascript = import ./languages/javascript.nix {
            inherit pkgs;
            base = baseLib;
          };
          typescript = import ./languages/typescript.nix {
            inherit pkgs;
            base = baseLib;
          };
          java = import ./languages/java.nix {
            inherit pkgs;
            base = baseLib;
          };
          kotlin = import ./languages/kotlin.nix {
            inherit pkgs;
            base = baseLib;
          };
          d = import ./languages/d.nix {
            inherit pkgs;
            base = baseLib;
          };
          swift = import ./languages/swift.nix {
            inherit pkgs;
            base = baseLib;
          };
          zig = import ./languages/zig.nix {
            inherit pkgs;
            base = baseLib;
          };
          nim = import ./languages/nim.nix {
            inherit pkgs;
            base = baseLib;
          };
          scala = import ./languages/scala.nix {
            inherit pkgs;
            base = baseLib;
          };
          elixir = import ./languages/elixir.nix {
            inherit pkgs;
            base = baseLib;
          };
          dart = import ./languages/dart.nix {
            inherit pkgs;
            base = baseLib;
          };
          csharp = import ./languages/csharp.nix {
            inherit pkgs;
            base = baseLib;
          };
          cobol = import ./languages/cobol.nix {
            inherit pkgs;
            base = baseLib;
          };
          r = import ./languages/r.nix {
            inherit pkgs;
            base = baseLib;
          };
          php = import ./languages/php.nix {
            inherit pkgs;
            base = baseLib;
          };
          lua = import ./languages/lua.nix {
            inherit pkgs;
            base = baseLib;
          };
          perl = import ./languages/perl.nix {
            inherit pkgs;
            base = baseLib;
          };
          ruby = import ./languages/ruby.nix {
            inherit pkgs;
            base = baseLib;
          };
          ocaml = import ./languages/ocaml.nix {
            inherit pkgs;
            base = baseLib;
          };
          clojure = import ./languages/clojure.nix {
            inherit pkgs;
            base = baseLib;
          };
          lisp = import ./languages/lisp.nix {
            inherit pkgs;
            base = baseLib;
          };
          fortran = import ./languages/fortran.nix {
            inherit pkgs;
            base = baseLib;
          };
          ada = import ./languages/ada.nix {
            inherit pkgs;
            base = baseLib;
          };
          smalltalk = import ./languages/smalltalk.nix {
            inherit pkgs;
            base = baseLib;
          };
          tcl = import ./languages/tcl.nix {
            inherit pkgs;
            base = baseLib;
          };
        }
        // pkgs.lib.optionalAttrs (pkgs.stdenv.isLinux) {
          julia = import ./languages/julia.nix {
            inherit pkgs;
            base = baseLib;
          };
          objc = import ./languages/objc.nix {
            inherit pkgs;
            base = baseLib;
          };
        };

      in
      {
        # Expose each language as separate dev shell outputs
        devShells = builtins.mapAttrs (_: lang: lang.devShell) languages;

        # Expose solution builders for each language
        lib = builtins.mapAttrs (_: lang: {
          mkStandardOutputs = lang.mkStandardOutputs;
        }) languages;

        # Also expose the base functionality for custom use
        baseLib = baseLib;
      }
    );
}
