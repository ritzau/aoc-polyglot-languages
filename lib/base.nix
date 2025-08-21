{ pkgs }:
let
  # Universal tools available in all language environments
  universalTools = with pkgs; [
    # Core development tools
    git
    direnv
    nix-direnv
    just
    delta
    bottom
    ripgrep

    # Text editors and utilities
    vim
    curl
    wget
    jq

    # Benchmarking and profiling
    hyperfine
    time

    # Code formatting and linting
    pre-commit
    clang-tools # includes clang-format
    nixfmt-rfc-style
    nodePackages.prettier

    # Additional useful tools
    fastfetch
    htop
    fd # Fast find replacement
    tree # Directory tree viewer
    bat # Better cat with syntax highlighting
    yq # YAML processor

    # File compression and archiving
    unzip
    gzip
  ];
in
{
  # Export universalTools
  inherit universalTools;

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
      extraShellHook ? "", # Additional shell hook commands
    }:
    pkgs.mkShell {
      buildInputs =
        (if includeUniversalTools then universalTools else [ pkgs.just ]) ++ languageTools ++ extraInputs;

      shellHook = ''
        echo "${emoji} ${name} AOC Environment"
        echo "Use 'just --list' to see available commands"
        echo ""
        echo "Universal tools available:"
        echo "  git, just, rg, fd, tree, bat, jq, yq, curl, wget"
        echo "  hyperfine, delta, bottom, htop, pre-commit"
        echo "  vim, clang-format, nixfmt, prettier"
        ${extraShellHook}
      '';
    };

  # Generate a justfile for a language (requires flake root path)
  mkJustfile =
    flakeRoot: language:
    pkgs.writeText "justfile" (builtins.readFile "${flakeRoot}/justfiles/${language}.justfile");

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
      defaultChecks = (
        if package != null then
          {
            build = package;
          }
        else
          { }
      );

    in
    {
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

  # Language-specific simplified flake template
  mkLanguageSimpleFlake =
    language: langConfig: flake-utils: self:
    {
      description ? null,
      pname ? null,
      version ? "0.1.0",
      jdk ? "jdk21",
      extraArgs ? { },
    }:
    let
      # Use self.description or provided description
      finalDescription =
        if description != null then
          description
        else if self ? description then
          self.description
        else
          "Unnamed ${language} solution";

      # Use self.outPath as source
      src = self.outPath;

      # Extract last two path segments for default pname
      pathStr = toString src;
      pathParts = pkgs.lib.strings.splitString "/" pathStr;
      # Filter out empty strings and take last 2
      nonEmptyParts = builtins.filter (x: x != "") pathParts;
      numParts = builtins.length nonEmptyParts;
      lastTwo =
        if numParts >= 2 then
          [
            (builtins.elemAt nonEmptyParts (numParts - 2))
            (builtins.elemAt nonEmptyParts (numParts - 1))
          ]
        else
          nonEmptyParts;
      defaultPname = builtins.concatStringsSep "-" lastTwo;
      finalPname = if pname != null then pname else defaultPname;

      # Prepare extra arguments with JDK for JVM languages
      jvmLanguages = [
        "java"
        "kotlin"
        "scala"
      ];
      isJvmLang = builtins.elem language jvmLanguages;
      finalExtraArgs = extraArgs // (if isJvmLang then { inherit jdk; } else { });
    in
    flake-utils.lib.eachDefaultSystem (
      system:
      langConfig.mkStandardOutputs (
        {
          inherit src version;
          pname = finalPname;
        }
        // finalExtraArgs
      )
    );
}
