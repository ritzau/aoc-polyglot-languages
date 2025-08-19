{
  description = "Kotlin environment for AOC solutions";

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
            name = "Kotlin";
            emoji = "🎯";
            languageTools = with baseLib.pkgs; [
              jdk21
              kotlin
              gradle
            ];
          };

          # Export mkSolution for Kotlin solutions to use
          lib = {
            # Wrapper that provides the language name automatically
            mkSolution = args: baseLib.mkSolution ({
              language = "kotlin";
              languageFlake = self;
            } // args);
            inherit (baseLib) pkgs;
          };
        }) // {
      # Complete solution outputs - eliminates all boilerplate
      mkStandardOutputs = { src ? ./., pname ? "hello-kotlin", ... }@args:
        flake-utils.lib.eachDefaultSystem (system:
          let
            pkgs = self.lib.${system}.pkgs;
            # Default package that uses gradle build
            defaultPackage = pkgs.stdenv.mkDerivation {
              pname = pname;
              version = "0.1.0";
              src = src;
              nativeBuildInputs = with pkgs; [ jdk21 kotlin ];
              buildPhase = ''
                # Compile Kotlin source to jar
                find src -name "*.kt" -exec kotlinc {} -include-runtime -d ${pname}.jar \;
              '';
              installPhase = ''
                                mkdir -p $out/bin
                                # Create executable wrapper script
                                cat > $out/bin/${pname} << EOF
                #!/bin/sh
                exec java -jar \$(dirname "\$0")/${pname}.jar "\$@"
                EOF
                                chmod +x $out/bin/${pname}
                                # Copy jar file
                                cp ${pname}.jar $out/bin/
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
