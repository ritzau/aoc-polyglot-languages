{
  description = "Hello World Fortran";
  inputs = {
    fortran-lang.url = "path:/Users/ritzau/src/slask/aoc-nix/languages/fortran";
  };
  outputs =
    { self, fortran-lang }:
    fortran-lang.mkStandardOutputs {
      src = ./.;
      pname = "hello-fortran";
    };
}
