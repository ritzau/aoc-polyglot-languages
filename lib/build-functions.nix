{ pkgs }:
{
  # For interpreted languages (Python, Ruby, Lua, etc.)
  interpreter =
    { interpreter, fileExtensions }:
    {
      pkgs,
      src ? ./.,
      pname,
      ...
    }@args:
    pkgs.writeShellApplication {
      name = pname;
      runtimeInputs = [ interpreter ];
      text = ''
        srcfile=$(find ${src} -maxdepth 1 ${
          builtins.concatStringsSep " -o " (map (ext: "-name \"*.${ext}\"") fileExtensions)
        } | head -1)
        if [ -n "$srcfile" ]; then
          exec ${interpreter.meta.mainProgram or (builtins.baseNameOf interpreter)} "$srcfile" "$@"
        else
          echo "No source files found in ${src}"
          exit 1
        fi
      '';
    };

  # For script languages with custom interpreter names
  scriptRunner =
    {
      interpreter,
      fileExtensions,
      interpreterName,
      interpreterArgs ? [ ],
      runtimeInputs ? [ ],
    }:
    {
      pkgs,
      src ? ./.,
      pname,
      ...
    }@args:
    pkgs.writeShellApplication {
      name = pname;
      runtimeInputs = [ interpreter ] ++ runtimeInputs;
      text = ''
        srcfile=$(find ${src} -maxdepth 1 ${
          builtins.concatStringsSep " -o " (map (ext: "-name \"*.${ext}\"") fileExtensions)
        } | head -1)
        if [ -n "$srcfile" ]; then
          exec ${interpreterName} ${builtins.concatStringsSep " " interpreterArgs} "$srcfile" "$@"
        else
          echo "No source files found in ${src}"
          exit 1
        fi
      '';
    };

  # For simple compilers (C, C++, Fortran, etc.)
  simpleCompiler =
    {
      compiler,
      fileExtensions,
      compileCmd,
    }:
    {
      pkgs,
      src ? ./.,
      pname,
      ...
    }@args:
    pkgs.stdenv.mkDerivation {
      inherit pname src;
      version = "0.1.0";
      nativeBuildInputs = [ compiler ];
      buildPhase = compileCmd;
      installPhase = ''
        mkdir -p $out/bin
        exe=$(find . -maxdepth 1 -type f -executable ! -name "*.${builtins.head fileExtensions}" | head -1)
        if [ -n "$exe" ]; then
          cp "$exe" $out/bin/${pname}
        else
          echo "No executable found"
          exit 1
        fi
      '';
    };

  # For build system languages (Rust/Cargo, Go modules, etc.)
  buildSystem =
    buildFn:
    {
      src ? ./.,
      pname,
      ...
    }@args:
    buildFn (
      args
      // {
        inherit src pname;
        version = "0.1.0";
      }
    );

  # For make-based builds (C, C++)
  makeBuild =
    {
      buildInputs ? [ ],
      makeTarget ? "",
    }:
    {
      pkgs,
      src ? ./.,
      pname,
      ...
    }@args:
    pkgs.stdenv.mkDerivation {
      inherit pname src;
      version = "0.1.0";
      nativeBuildInputs = with pkgs; [ gnumake ] ++ buildInputs;
      configurePhase = "echo 'Skipping configure phase'";
      buildPhase = "make ${makeTarget}";
      installPhase = ''
        mkdir -p $out/bin
        find . -name "${pname}" -executable -type f -exec cp {} $out/bin/ \;
      '';
    };

  # For cmake-based builds (C++, C)
  cmakeBuild =
    {
      buildInputs ? [ ],
      cmakeFlags ? [ ],
    }:
    {
      pkgs,
      src ? ./.,
      pname,
      ...
    }@args:
    pkgs.stdenv.mkDerivation {
      inherit pname src;
      version = "0.1.0";
      nativeBuildInputs =
        with pkgs;
        [
          cmake
          ninja
        ]
        ++ buildInputs;
      configurePhase = ''
        cmake -B build -G Ninja ${builtins.concatStringsSep " " cmakeFlags}
      '';
      buildPhase = ''
        cmake --build build
      '';
      installPhase = ''
        mkdir -p $out/bin
        find build -name "${pname}" -executable -type f -exec cp {} $out/bin/ \;
      '';
    };

  # For Java compilation and JAR creation
  javaBuild =
    {
      mainClass,
    }:
    {
      pkgs,
      src ? ./.,
      pname,
      ...
    }@args:
    pkgs.writeShellApplication {
      name = pname;
      runtimeInputs = [ pkgs.jdk21 ];
      text = ''
        # Create temporary directory for compilation
        tmpdir=$(mktemp -d)
        cp -r ${src}/* "$tmpdir/"
        cd "$tmpdir"

        # Compile all Java files
        javac ./*.java

        # Create and run JAR
        jar cfe ${pname}.jar ${mainClass} ./*.class
        exec java -jar ${pname}.jar "$@"
      '';
    };

  # For Kotlin compilation and JAR creation
  kotlinBuild =
    {
      mainClass ? "HelloKt",
    }:
    {
      pkgs,
      src ? ./.,
      pname,
      ...
    }@args:
    pkgs.writeShellApplication {
      name = pname;
      runtimeInputs = [
        pkgs.kotlin
        pkgs.jdk21
      ];
      text = ''
        # Create temporary directory for compilation
        tmpdir=$(mktemp -d)
        cp -r ${src}/* "$tmpdir/"
        cd "$tmpdir"

        # Find and compile Kotlin files
        find . -name "*.kt" -exec kotlinc {} -include-runtime -d ${pname}.jar \;

        # Run the JAR
        exec java -jar ${pname}.jar "$@"
      '';
    };

  # For Scala compilation and JAR creation
  scalaBuild =
    {
      mainClass ? "Hello",
    }:
    {
      pkgs,
      src ? ./.,
      pname,
      ...
    }@args:
    pkgs.writeShellApplication {
      name = pname;
      runtimeInputs = [
        pkgs.scala
        pkgs.jdk21
        pkgs.which
      ];
      text = ''
        # Create temporary directory for compilation
        tmpdir=$(mktemp -d)
        cp -r ${src}/* "$tmpdir/"
        cd "$tmpdir"

        # Compile all Scala files
        scalac ./*.scala

        # Create and run JAR
        jar cfe ${pname}.jar ${mainClass} ./*.class
        exec java -jar ${pname}.jar "$@"
      '';
    };
}
