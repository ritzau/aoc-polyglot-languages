{
  description = "Scala environment for AOC solutions";

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
            name = "Scala";
            emoji = "🎭";
            languageTools = with baseLib.pkgs; [
              jdk21
              scala_3
              sbt
              scalafmt
            ];
          };

          # Export mkSolution for Scala solutions to use
          lib = {
            # Wrapper that provides the language name automatically
            mkSolution = args: baseLib.mkSolution ({
              language = "scala";
              languageFlake = self;
            } // args);
            inherit (baseLib) pkgs;
          };
        }) // {
      # Complete solution outputs - eliminates all boilerplate
      mkStandardOutputs = { src ? ./., pname ? "hello-scala", ... }@args:
        flake-utils.lib.eachDefaultSystem (system:
          let
            pkgs = self.lib.${system}.pkgs;
            jdk = pkgs.jdk21;
            scala = pkgs.scala_3;
            # Default package that uses scalac
            defaultPackage = pkgs.stdenv.mkDerivation {
              pname = pname;
              version = "0.1.0";
              src = src;
              nativeBuildInputs = [ jdk scala ];
              buildPhase = ''
                # Find .scala files and compile them
                scalafiles=$(find . -maxdepth 1 -name "*.scala")
                if [ -n "$scalafiles" ]; then
                  scalac $scalafiles
                else
                  echo "No .scala files found"
                  exit 1
                fi
              '';
              installPhase = ''
                                mkdir -p $out/bin
                                # Find Scala source file and extract object name
                                scalafile=$(find . -maxdepth 1 -name "*.scala" | head -1)
                                mainclass=$(grep -o "object [A-Za-z0-9_]*" "$scalafile" | head -1 | cut -d' ' -f2)
                                if [ -n "$mainclass" ]; then
                                  cat > $out/bin/${pname} << EOF
                #!/bin/sh
                exec ${scala}/bin/scala -cp "\$(dirname "\$0")/../" "$mainclass" "\$@"
                EOF
                                  chmod +x $out/bin/${pname}
                                  cp *.class $out/
                                else
                                  echo "No compiled .class files found"
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
