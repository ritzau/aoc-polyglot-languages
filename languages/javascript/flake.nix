{
  description = "JavaScript environment for AOC solutions";

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
            name = "JavaScript";
            emoji = "🟨";
            languageTools = with baseLib.pkgs; [
              nodejs_20
              nodePackages.npm
              nodePackages.eslint
              nodePackages.prettier
            ];
          };

          # Export mkSolution for JavaScript solutions to use
          lib = {
            # Wrapper that provides the language name automatically
            mkSolution = args: baseLib.mkSolution ({
              language = "javascript";
              languageFlake = self;
            } // args);
            inherit (baseLib) pkgs;
          };
        }) // {
      # Complete solution outputs - eliminates all boilerplate
      mkStandardOutputs = { src ? ./., pname ? "hello-javascript", ... }@args:
        flake-utils.lib.eachDefaultSystem (system:
          let
            pkgs = self.lib.${system}.pkgs;
            nodejs = pkgs.nodejs_20;
            # Default package that uses node
            defaultPackage = pkgs.stdenv.mkDerivation {
              pname = pname;
              version = "0.1.0";
              src = src;
              nativeBuildInputs = [ nodejs ];
              buildPhase = ''
                # JavaScript doesn't need compilation, but we can do syntax check
                node -c *.js 2>/dev/null || true
              '';
              installPhase = ''
                                mkdir -p $out/bin
                                # Find .js files and create executable wrapper
                                jsfile=$(find . -maxdepth 1 -name "*.js" | head -1)
                                if [ -n "$jsfile" ]; then
                                  cat > $out/bin/${pname} << EOF
                #!/bin/sh
                exec ${nodejs}/bin/node "\$(dirname "\$0")/../$jsfile" "\$@"
                EOF
                                  chmod +x $out/bin/${pname}
                                  cp "$jsfile" $out/
                                else
                                  echo "No .js files found"
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
