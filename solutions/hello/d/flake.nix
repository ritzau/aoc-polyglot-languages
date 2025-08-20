{
  description = "Hello World D";
  inputs = {
    d-lang.url = "path:/Users/ritzau/src/slask/aoc-nix/languages/d";
  };
  outputs =
    { self, d-lang }:
    d-lang.mkStandardOutputs {
      src = ./.;
      pname = "hello-d";
    };
}
