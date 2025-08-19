{
  description = "Base language environment for AOC solutions";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        # Create a dev shell with language-specific tools
        mkLanguageShell =
          { name
          , # Language name (e.g., "Rust", "C++")
            emoji
          , # Emoji for the language (e.g., "🦀", "⚡")
            languageTools
          , # List of language-specific packages
            extraInputs ? [ ]  # Optional additional packages
          }: pkgs.mkShell {
            buildInputs = with pkgs; [
              # Common tools for all languages
              just
            ] ++ languageTools ++ extraInputs;

            shellHook = ''
              echo "${emoji} ${name} AOC Environment"
              echo "Use 'just --list' to see available commands"
            '';
          };

        # Create a solution flake with language inheritance
        mkSolution =
          { language
          , # Language name (e.g., "rust", "c", "cpp")
            languageFlake
          , # The language flake to inherit from
            package ? null
          , # Optional package build configuration
            app ? null
          , # Optional app configuration override
            checks ? { }
          , # Optional additional checks
            formatter ? null # Optional formatter override
          }:
          let
            # Default app that tries to run the built package
            defaultApp =
              if package != null then {
                type = "app";
                program = "${package}/bin/hello-${language}";
              } else null;

            # Default checks - package builds if provided, otherwise just dev shell
            defaultChecks = (if package != null then {
              build = package;
            } else { }) // {
              devShell = languageFlake.devShells.${system}.default;
            };

            result = {
              # Always inherit dev shell from language
              devShells.default = languageFlake.devShells.${system}.default;

              # Always provide checks for nix flake check
              checks = defaultChecks // checks;
            } // (if package != null then {
              packages.default = package;
            } else { }) // (if (app != null || defaultApp != null) then {
              apps.default = if app != null then app else defaultApp;
            } else { }) // (if formatter != null then {
              formatter = formatter;
            } else { });
          in
          result;
      in
      {
        # Export the helper functions for language flakes to use
        lib = {
          inherit mkLanguageShell;
          inherit mkSolution;
          inherit pkgs;
        };
      });
}
