{
  description = "Hello World Nim";
  inputs = {
    nim-lang.url = "path:/Users/ritzau/src/slask/aoc-nix/languages/nim";
  };
  outputs =
    { self, nim-lang }:
    nim-lang.mkStandardOutputs {
      src = ./.;
      pname = "hello-nim";
    };
}
