{
  description = "C# environment for AOC solutions";

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
            name = "C#";
            emoji = "🔷";
            languageTools = with baseLib.pkgs; [
              dotnet-sdk_8
              mono
              omnisharp-roslyn
            ];
          };

          # Export mkSolution for C# solutions to use
          lib = {
            # Wrapper that provides the language name automatically
            mkSolution = args: baseLib.mkSolution ({
              language = "csharp";
              languageFlake = self;
            } // args);
            inherit (baseLib) pkgs;
          };
        }) // {
      # Complete solution outputs - eliminates all boilerplate
      mkStandardOutputs = { src ? ./., pname ? "hello-csharp", ... }@args:
        flake-utils.lib.eachDefaultSystem (system:
          let
            pkgs = self.lib.${system}.pkgs;
            # Default package that uses mcs (Mono C# compiler)
            defaultPackage = pkgs.stdenv.mkDerivation {
              pname = pname;
              version = "0.1.0";
              src = src;
              nativeBuildInputs = with pkgs; [ mono ];
              buildPhase = ''
                # Find .cs files and compile them
                csfile=$(find . -maxdepth 1 -name "*.cs" | head -1)
                if [ -n "$csfile" ]; then
                  mcs -out:${pname}.exe "$csfile"
                else
                  echo "No .cs files found"
                  exit 1
                fi
              '';
              installPhase = ''
                                mkdir -p $out/bin
                                cat > $out/bin/${pname} << 'EOF'
                #!/bin/sh
                exec ${pkgs.mono}/bin/mono ${placeholder "out"}/lib/${pname}.exe "$@"
                EOF
                                chmod +x $out/bin/${pname}
                                mkdir -p $out/lib
                                cp ${pname}.exe $out/lib/
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
