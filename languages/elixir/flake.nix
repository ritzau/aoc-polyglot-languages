{
  description = "Elixir environment for AOC solutions";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    base = {
      url = "path:/Users/ritzau/src/slask/aoc-nix/languages/base";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      base,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        baseLib = base.lib.${system};
      in
      {
        devShells.default = baseLib.mkLanguageShell {
          name = "Elixir";
          emoji = "💧";
          languageTools = with baseLib.pkgs; [
            elixir
            erlang
            elixir-ls
          ];
        };

        # Export mkSolution for Elixir solutions to use
        lib = {
          # Wrapper that provides the language name automatically
          mkSolution =
            args:
            baseLib.mkSolution (
              {
                language = "elixir";
                languageFlake = self;
              }
              // args
            );
          inherit (baseLib) pkgs;
        };
      }
    )
    // {
      # Complete solution outputs - eliminates all boilerplate
      mkStandardOutputs =
        {
          src ? ./.,
          pname ? "hello-elixir",
          ...
        }@args:
        flake-utils.lib.eachDefaultSystem (
          system:
          let
            pkgs = self.lib.${system}.pkgs;
            # Default package that uses elixir interpreter
            defaultPackage = pkgs.stdenv.mkDerivation {
              pname = pname;
              version = "0.1.0";
              src = src;
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
                                  cat > $out/bin/${pname} << EOF
                #!/bin/sh
                exec ${pkgs.elixir}/bin/elixir "\$(dirname "\$0")/../$exsfile" "\$@"
                EOF
                                  chmod +x $out/bin/${pname}
                                  cp "$exsfile" $out/
                                else
                                  echo "No .exs files found"
                                  exit 1
                                fi
              '';
            };
            # Remove src and pname from args to pass to mkSolution
            cleanArgs = builtins.removeAttrs args [
              "src"
              "pname"
            ];
          in
          self.lib.${system}.mkSolution (
            {
              package = defaultPackage;
            }
            // cleanArgs
          )
        );
    };
}
