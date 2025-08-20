{
  description = "Base language environment for AOC solutions";

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

        # Universal tools available in all language environments
        universalTools = with pkgs; [
          # Build and task management
          just

          # System information and monitoring
          fastfetch
          htop
          bottom # Alternative to htop

          # File operations and search
          ripgrep # rg - fast text search
          fd # Fast find replacement
          tree # Directory tree viewer
          bat # Better cat with syntax highlighting

          # Text processing and data manipulation
          jq # JSON processor
          yq # YAML processor

          # Version control and network tools
          git
          curl
          wget

          # File compression and archiving
          unzip
          gzip

          # Development utilities
          delta # Better git diff
          hyperfine # Benchmarking tool (already in root)
        ];

        # Create a dev shell with language-specific tools
        mkLanguageShell =
          {
            name,
            # Language name (e.g., "Rust", "C++")
            emoji,
            # Emoji for the language (e.g., "🦀", "⚡")
            languageTools,
            # List of language-specific packages
            extraInputs ? [ ], # Optional additional packages
            includeUniversalTools ? true, # Whether to include universal tools
          }:
          pkgs.mkShell {
            buildInputs =
              (if includeUniversalTools then universalTools else [ pkgs.just ]) ++ languageTools ++ extraInputs;

            shellHook = ''
              echo "${emoji} ${name} AOC Environment"
              echo "Use 'just --list' to see available commands"
              echo ""
              echo "Universal tools available:"
              echo "  rg, fd, tree, bat, jq, yq, git, curl, wget"
              echo "  fastfetch, htop, bottom, delta, hyperfine"
            '';
          };

        # Create a solution flake with language inheritance
        mkSolution =
          {
            language,
            # Language name (e.g., "rust", "c", "cpp")
            languageFlake,
            # The language flake to inherit from
            package ? null,
            # Optional package build configuration
            app ? null,
            # Optional app configuration override
            checks ? { },
            # Optional additional checks
            formatter ? null, # Optional formatter override
            pname ? null, # Optional explicit executable name
          }:
          let
            # Default app that tries to run the built package
            defaultApp =
              if package != null then
                {
                  type = "app";
                  program = "${package}/bin/${if pname != null then pname else "hello-${language}"}";
                }
              else
                null;

            # Default checks - package builds if provided, otherwise just dev shell
            defaultChecks =
              (
                if package != null then
                  {
                    build = package;
                  }
                else
                  { }
              )
              // {
                devShell = languageFlake.devShells.${system}.default;
              };

            result = {
              # Always inherit dev shell from language
              devShells.default = languageFlake.devShells.${system}.default;

              # Always provide checks for nix flake check
              checks = defaultChecks // checks;
            }
            // (
              if package != null then
                {
                  packages.default = package;
                }
              else
                { }
            )
            // (
              if (app != null || defaultApp != null) then
                {
                  apps.default = if app != null then app else defaultApp;
                }
              else
                { }
            )
            // (
              if formatter != null then
                {
                  formatter = formatter;
                }
              else
                { }
            );
          in
          result;

        # Build functions for common language patterns
        buildFunctions = {
          # For interpreted languages (Python, Ruby, Lua, etc.)
          interpreter =
            { interpreter, fileExtensions }:
            {
              pkgs,
              src ? ./.,
              pname,
              ...
            }@args:
            pkgs.writeShellApplication {
              inherit pname;
              runtimeInputs = [ interpreter ];
              text = ''
                srcfile=$(find ${src} -maxdepth 1 ${
                  builtins.concatStringsSep " -o " (map (ext: "-name \"*.${ext}\"") fileExtensions)
                } | head -1)
                if [ -n "$srcfile" ]; then
                  exec ${interpreter.meta.mainProgram or (builtins.baseNameOf interpreter)} "$srcfile" "$@"
                else
                  echo "No source files found in ${src}"
                  exit 1
                fi
              '';
            };

          # For simple compilers (C, C++, Fortran, etc.)
          simpleCompiler =
            {
              compiler,
              fileExtensions,
              compileCmd,
            }:
            {
              pkgs,
              src ? ./.,
              pname,
              ...
            }@args:
            pkgs.stdenv.mkDerivation {
              inherit pname src;
              version = "0.1.0";
              nativeBuildInputs = [ compiler ];
              buildPhase = compileCmd;
              installPhase = ''
                mkdir -p $out/bin
                exe=$(find . -maxdepth 1 -type f -executable ! -name "*.${builtins.head fileExtensions}" | head -1)
                if [ -n "$exe" ]; then
                  cp "$exe" $out/bin/${pname}
                else
                  echo "No executable found"
                  exit 1
                fi
              '';
            };

          # For build system languages (Rust/Cargo, Go modules, etc.)
          buildSystem =
            buildFn:
            {
              pkgs,
              src ? ./.,
              pname,
              ...
            }@args:
            buildFn (
              args
              // {
                inherit pkgs src pname;
                version = "0.1.0";
              }
            );

          # For make-based builds (C, C++)
          makeBuild =
            {
              buildInputs ? [ ],
              makeTarget ? "",
            }:
            {
              pkgs,
              src ? ./.,
              pname,
              ...
            }@args:
            pkgs.stdenv.mkDerivation {
              inherit pname src;
              version = "0.1.0";
              nativeBuildInputs = with pkgs; [ gnumake ] ++ buildInputs;
              configurePhase = "echo 'Skipping configure phase'";
              buildPhase = "make ${makeTarget}";
              installPhase = ''
                mkdir -p $out/bin
                find . -name "${pname}" -executable -type f -exec cp {} $out/bin/ \;
              '';
            };

          # For cmake-based builds (C++, C)
          cmakeBuild =
            {
              buildInputs ? [ ],
              cmakeFlags ? [ ],
            }:
            {
              pkgs,
              src ? ./.,
              pname,
              ...
            }@args:
            pkgs.stdenv.mkDerivation {
              inherit pname src;
              version = "0.1.0";
              nativeBuildInputs =
                with pkgs;
                [
                  cmake
                  ninja
                ]
                ++ buildInputs;
              configurePhase = ''
                cmake -B build -G Ninja ${builtins.concatStringsSep " " cmakeFlags}
              '';
              buildPhase = ''
                cmake --build build
              '';
              installPhase = ''
                mkdir -p $out/bin
                find build -name "${pname}" -executable -type f -exec cp {} $out/bin/ \;
              '';
            };
        };

        # Simplified template for creating language flakes
        # This returns the core configuration that most language flakes need
        languageTemplate =
          {
            language, # Language name (lowercase, e.g., "rust", "python")
            name, # Display name (e.g., "Rust", "Python")
            emoji, # Language emoji
            languageTools, # List of language-specific packages
            buildPattern, # Build pattern: "interpreter", "simpleCompiler", "buildSystem"
            buildConfig, # Config for the build pattern
          }:
          {
            inherit
              language
              name
              emoji
              languageTools
              buildPattern
              buildConfig
              ;
          };

      in
      {
        # Export the helper functions for language flakes to use
        lib = {
          inherit mkLanguageShell;
          inherit mkSolution;
          inherit languageTemplate;
          inherit buildFunctions;
          inherit universalTools;
          inherit pkgs;
        };
      }
    );
}
