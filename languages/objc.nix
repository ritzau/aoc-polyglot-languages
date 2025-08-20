{
  pkgs,
  base,
  justfilePath ? null,
}:
{
  devShell = base.mkLanguageShell {
    name = "Objective-C";
    emoji = "🍎";
    languageTools = with pkgs; [
      clang
      gnustep-base
      gnustep-make
    ];
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

  mkStandardOutputs =
    args:
    base.mkSolution {
      language = "objc";
      package = pkgs.stdenv.mkDerivation {
        pname = args.pname or "hello-objc";
        version = "0.1.0";
        src = args.src or ./.;
        nativeBuildInputs = [
          pkgs.clang
          pkgs.gnustep-base
          pkgs.gnustep-make
        ];
        buildPhase = ''
          # Find the objective-c file in the source directory
          objcfile=$(find . -maxdepth 1 -name "*.m" | head -1)
          if [ -n "$objcfile" ]; then
            clang -framework Foundation "$objcfile" -o ${args.pname or "hello-objc"}
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
}
