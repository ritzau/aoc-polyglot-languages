{
  description = "Java environment for AOC solutions";

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
            name = "Java";
            emoji = "☕";
            languageTools = with baseLib.pkgs; [
              jdk21
              gradle
              maven
            ];
          };

          # Export mkSolution for Java solutions to use
          lib = {
            # Wrapper that provides the language name automatically
            mkSolution = args: baseLib.mkSolution ({
              language = "java";
              languageFlake = self;
            } // args);
            inherit (baseLib) pkgs;
          };
        }) // {
      # Complete solution outputs - eliminates all boilerplate
      mkStandardOutputs = { src ? ./., pname ? "hello-java", ... }@args:
        flake-utils.lib.eachDefaultSystem (system:
          let
            pkgs = self.lib.${system}.pkgs;
            jdk = pkgs.jdk21;
            # Default package that uses javac
            defaultPackage = pkgs.stdenv.mkDerivation {
              pname = pname;
              version = "0.1.0";
              src = src;
              nativeBuildInputs = [ jdk ];
              buildPhase = ''
                # Find .java files and compile them
                javafiles=$(find . -maxdepth 1 -name "*.java")
                if [ -n "$javafiles" ]; then
                  javac $javafiles
                else
                  echo "No .java files found"
                  exit 1
                fi
              '';
              installPhase = ''
                              mkdir -p $out/bin
                              # Find main class and create executable wrapper
                              mainclass=$(find . -maxdepth 1 -name "*.class" | head -1 | sed 's/.*\///' | sed 's/\.class$//')
                              if [ -n "$mainclass" ]; then
                                cat > $out/bin/${pname} << EOF
                #!/bin/sh
                exec ${jdk}/bin/java -cp "\$(dirname "\$0")/../" "$mainclass" "\$@"
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
