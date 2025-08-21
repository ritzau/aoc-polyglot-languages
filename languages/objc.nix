{
  pkgs,
  base,
  justfilePath ? null,
}:
let
  # Platform-specific toolchain configuration
  isDarwin = pkgs.stdenv.isDarwin;
  isLinux = pkgs.stdenv.isLinux;

  # Language tools vary by platform
  languageTools = [
    pkgs.clang
  ]
  ++ pkgs.lib.optionals isLinux [
    # GNUstep is needed on Linux
    pkgs.gnustep-base
    pkgs.gnustep-make
  ]
  ++ pkgs.lib.optionals isDarwin [
    # macOS uses native Foundation framework (no additional packages needed)
  ];

  # Build inputs vary by platform
  buildInputs = [
    pkgs.clang
  ]
  ++ pkgs.lib.optionals isLinux [
    pkgs.gnustep-base
    pkgs.gnustep-make
  ];

  devShell = base.mkLanguageShell {
    name = "Objective-C";
    emoji = "🍎";
    languageTools = languageTools;
    extraShellHook =
      if justfilePath != null then
        ''
          export JUSTFILE_OBJC="${justfilePath}"
          # Create a cache directory and symlink to language justfile
          mkdir -p .cache
          if [ ! -L .cache/objc.justfile ]; then
            ln -sf "${justfilePath}" .cache/objc.justfile
            echo "📋 Linked .cache/objc.justfile to language definition"
          fi
        ''
      else
        "";
  };

  solution =
    args:
    base.mkSolution {
      language = "objc";
      package = pkgs.stdenv.mkDerivation {
        pname = args.pname or "hello-objc";
        version = "0.1.0";
        src = args.src or ./.;
        nativeBuildInputs = buildInputs;
        buildPhase =
          if isDarwin then
            ''
              # macOS: Use native Foundation framework
              objcfile=$(find . -maxdepth 1 -name "*.m" | head -1)
              if [ -n "$objcfile" ]; then
                clang -framework Foundation "$objcfile" -o ${args.pname or "hello-objc"}
              else
                echo "No Objective-C files found in ${args.src or ./.}"
                exit 1
              fi
            ''
          else
            ''
              # Linux: Use GNUstep
              objcfile=$(find . -maxdepth 1 -name "*.m" | head -1)
              if [ -n "$objcfile" ]; then
                clang `gnustep-config --objc-flags` `gnustep-config --base-libs` "$objcfile" -o ${args.pname or "hello-objc"}
              else
                echo "No Objective-C files found in ${args.src or ./.}"
                exit 1
              fi
            '';
        installPhase = ''
          mkdir -p $out/bin
          cp ${args.pname or "hello-objc"} $out/bin/
        '';
      };
    };
in
{
  mkStandardOutputs = args: (solution args) // { devShells.default = devShell; };
  mkDefaultOutputs = args: (solution args) // { devShells.default = devShell; };
}
