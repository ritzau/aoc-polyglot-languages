{ pkgs }:
{
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
    hyperfine # Benchmarking tool
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

  # Create a solution configuration
  mkSolution =
    {
      language,
      # Language name (e.g., "rust", "c", "cpp")
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

      # Default checks - package builds if provided
      defaultChecks =
        (
          if package != null then
            {
              build = package;
            }
          else
            { }
        );

      result = {
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
}