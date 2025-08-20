{
  pkgs,
  base,
  justfilePath ? null,
}:
{
  devShell = base.mkLanguageShell {
    name = "Elixir";
    emoji = "💧";
    languageTools = with pkgs; [
      elixir
      erlang
      elixir-ls
    ];
    extraShellHook =
      if justfilePath != null then
        ''
          export JUSTFILE_ELIXIR="${justfilePath}"
          # Create a cache directory and symlink to language justfile
          mkdir -p .cache
          if [ ! -L .cache/elixir.justfile ]; then
            ln -sf "${justfilePath}" .cache/elixir.justfile
            echo "📋 Linked .cache/elixir.justfile to language definition"
          fi
        ''
      else
        "";
  };

  mkStandardOutputs =
    args:
    base.mkSolution {
      language = "elixir";
      package = pkgs.stdenv.mkDerivation {
        pname = args.pname or "hello-elixir";
        version = "0.1.0";
        src = args.src or ./.;
        nativeBuildInputs = with pkgs; [ elixir ];
        buildPhase = ''
          # Elixir scripts don't need compilation, but we can do syntax check
          find . -maxdepth 1 -name "*.exs" -exec elixir -c {} \;
        '';
        installPhase = ''
                  mkdir -p $out/bin
                  # Find .exs files and create executable wrapper
                  exsfile=$(find . -maxdepth 1 -name "*.exs" | head -1)
                  if [ -n "$exsfile" ]; then
                    cat > $out/bin/${args.pname or "hello-elixir"} << EOF
          #!/bin/sh
          exec ${pkgs.elixir}/bin/elixir "\$(dirname "\$0")/../$exsfile" "\$@"
          EOF
                    chmod +x $out/bin/${args.pname or "hello-elixir"}
                    cp "$exsfile" $out/
                  else
                    echo "No .exs files found"
                    exit 1
                  fi
        '';
      };
    };
}
