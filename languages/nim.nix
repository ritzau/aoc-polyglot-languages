{
  pkgs,
  base,
  justfilePath ? null,
}:
let
  devShell = base.mkLanguageShell {
    name = "Nim";
    emoji = "👑";
    languageTools = with pkgs; [
      nim
    ];
    extraShellHook =
      if justfilePath != null then
        ''
          export JUSTFILE_NIM="${justfilePath}"
          # Create a cache directory and symlink to language justfile
          mkdir -p .cache
          if [ ! -L .cache/nim.justfile ]; then
            ln -sf "${justfilePath}" .cache/nim.justfile
            echo "📋 Linked .cache/nim.justfile to language definition"
          fi
        ''
      else
        "";
  };

  solution =
    args:
    base.mkSolution {
      language = "nim";
      package =
        (
          {
            pkgs,
            src ? ./.,
            pname,
            ...
          }@buildArgs:
          pkgs.stdenv.mkDerivation {
            inherit pname src;
            version = "0.1.0";
            nativeBuildInputs = [ pkgs.nim ];
            # Set up a proper cache directory for Nim
            buildPhase = ''
              export HOME=$TMPDIR
              mkdir -p $HOME/.cache/nim
              nim compile --verbosity:0 -o:${pname} *.nim
            '';
            installPhase = ''
              mkdir -p $out/bin
              cp ${pname} $out/bin/
            '';
          }
        )
          (args // { pkgs = pkgs; });
    };
in
{
  mkStandardOutputs = args: (solution args) // { devShells.default = devShell; };
}
