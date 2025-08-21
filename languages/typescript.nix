{
  pkgs,
  base,
  justfilePath ? null,
}:
let
  devShell = base.mkLanguageShell {
    name = "TypeScript";
    emoji = "🔷";
    languageTools = with pkgs; [
      nodejs_20
      typescript
    ];
    extraShellHook =
      if justfilePath != null then
        ''
          export JUSTFILE_TYPESCRIPT="${justfilePath}"
          # Create a cache directory and symlink to language justfile
          mkdir -p .cache
          if [ ! -L .cache/typescript.justfile ]; then
            ln -sf "${justfilePath}" .cache/typescript.justfile
            echo "📋 Linked .cache/typescript.justfile to language definition"
          fi
        ''
      else
        "";
  };

  solution =
    args:
    base.mkSolution {
      language = "typescript";
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
            nativeBuildInputs = [
              pkgs.typescript
              pkgs.nodejs_20
            ];
            buildPhase = ''
              tsc *.ts --outDir dist
            '';
            installPhase = ''
              mkdir -p $out/bin
              echo '#!/usr/bin/env bash' > $out/bin/${pname}
              echo 'exec ${pkgs.nodejs_20}/bin/node ${placeholder "out"}/lib/*.js "$@"' >> $out/bin/${pname}
              chmod +x $out/bin/${pname}

              mkdir -p $out/lib
              cp dist/*.js $out/lib/
            '';
          }
        )
          (args // { pkgs = pkgs; });
    };
in
{
  mkStandardOutputs = args: (solution args) // { devShells.default = devShell; };
}
