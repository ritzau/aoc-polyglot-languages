{
  pkgs,
  base,
  justfilePath ? null,
}:
let
  # Override gnucobol to remove heavy TeX dependencies for faster builds
  gnucobol-minimal = pkgs.gnucobol.overrideAttrs (oldAttrs: {
    # Disable documentation build to avoid massive TeX dependencies
    configureFlags = (oldAttrs.configureFlags or [ ]) ++ [
      "--disable-doc"
      "--without-help2man"
    ];
    # Remove documentation-related build inputs
    nativeBuildInputs = builtins.filter (
      pkg:
      let
        name = pkg.pname or pkg.name or "";
      in
      !(builtins.elem name [
        "texlive-2025-env"
        "help2man"
        "texinfo"
      ])
    ) (oldAttrs.nativeBuildInputs or [ ]);
  });

  devShell = base.mkLanguageShell {
    name = "COBOL";
    emoji = "🏢";
    languageTools = [
      gnucobol-minimal
    ];
    extraShellHook =
      if justfilePath != null then
        ''
          export JUSTFILE_COBOL="${justfilePath}"
          # Create a cache directory and symlink to language justfile
          mkdir -p .cache
          if [ ! -L .cache/cobol.justfile ]; then
            ln -sf "${justfilePath}" .cache/cobol.justfile
            echo "📋 Linked .cache/cobol.justfile to language definition"
          fi
        ''
      else
        "";
  };

  solution =
    args:
    base.mkSolution {
      language = "cobol";
      package = pkgs.writeShellApplication {
        name = args.pname or "hello-cobol";
        runtimeInputs = [ gnucobol-minimal ];
        text = ''
          # Find the COBOL file in the source directory
          cobolfile=$(find ${args.src or ./.} -maxdepth 1 -name "*.cob" -o -name "*.cobol" -o -name "*.cbl" | head -1)
          if [ -n "$cobolfile" ]; then
            # Compile and run
            temp_exe=$(mktemp)
            cobc -x "$cobolfile" -o "$temp_exe"
            exec "$temp_exe" "$@"
          else
            echo "No COBOL files found in ${args.src or ./.}"
            exit 1
          fi
        '';
      };
    };
in
{
  mkStandardOutputs = args: (solution args) // { devShells.default = devShell; };
  mkDefaultOutputs = args: (solution args) // { devShells.default = devShell; };
}
