{
  description = "TypeScript environment for AOC solutions";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    base = {
      url = "path:/Users/ritzau/src/slask/aoc-nix/languages/base";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
  };

  outputs = { self, nixpkgs, flake-utils, base }:
    flake-utils.lib.eachDefaultSystem
      (system:
        let
          baseLib = base.lib.${system};
        in
        {
          devShells.default = baseLib.mkLanguageShell {
            name = "TypeScript";
            emoji = "📘";
            languageTools = with baseLib.pkgs; [
              nodejs_20
              nodePackages.typescript
              nodePackages.ts-node
              nodePackages.eslint
              nodePackages.prettier
              nodePackages."@types/node"
              bun
              deno
            ];
          };

          # Export mkSolution for TypeScript solutions to use
          lib = {
            # Wrapper that provides the language name automatically
            mkSolution = args: baseLib.mkSolution ({
              language = "typescript";
              languageFlake = self;
            } // args);
            inherit (baseLib) pkgs;
          };
        }) // {
      # Complete solution outputs - eliminates all boilerplate
      mkStandardOutputs = { src ? ./., pname ? "hello-typescript", ... }@args:
        flake-utils.lib.eachDefaultSystem (system:
          let
            pkgs = self.lib.${system}.pkgs;
            nodejs = pkgs.nodejs_20;
            typescript = pkgs.nodePackages.typescript;
            # Default package that compiles TypeScript to JavaScript
            defaultPackage = pkgs.stdenv.mkDerivation {
              pname = pname;
              version = "0.1.0";
              src = src;
              nativeBuildInputs = [ nodejs typescript ];
              buildPhase = ''
                # Compile TypeScript to JavaScript
                tsfile=$(find . -maxdepth 1 -name "*.ts" | head -1)
                if [ -n "$tsfile" ]; then
                  tsc --target ES2020 --module CommonJS "$tsfile"
                else
                  echo "No .ts files found"
                  exit 1
                fi
              '';
              installPhase = ''
                                mkdir -p $out/bin
                                # Find compiled .js file and create executable wrapper
                                jsfile=$(find . -maxdepth 1 -name "*.js" | head -1)
                                if [ -n "$jsfile" ]; then
                                  cat > $out/bin/${pname} << EOF
                #!/bin/sh
                exec ${nodejs}/bin/node "\$(dirname "\$0")/../$jsfile" "\$@"
                EOF
                                  chmod +x $out/bin/${pname}
                                  cp "$jsfile" $out/
                                else
                                  echo "No compiled .js files found"
                                  exit 1
                                fi
              '';
            };
            # Remove src and pname from args to pass to mkSolution
            cleanArgs = builtins.removeAttrs args [ "src" "pname" ];
          in
          self.lib.${system}.mkSolution ({
            package = defaultPackage;
          } // cleanArgs));
    };
}
