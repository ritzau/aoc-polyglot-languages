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
      inherit pname;
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
}
