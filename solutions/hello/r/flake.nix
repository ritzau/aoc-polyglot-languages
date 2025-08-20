{
  description = "Hello World R";
  inputs = {
    r-lang.url = "path:/Users/ritzau/src/slask/aoc-nix/languages/r";
  };
  outputs =
    { self, r-lang }:
    r-lang.mkStandardOutputs {
      src = ./.;
      pname = "hello-r";
    };
}
