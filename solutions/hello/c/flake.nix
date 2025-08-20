{
  description = "Hello World C";

  inputs = {
    c-lang.url = "path:/Users/ritzau/src/slask/aoc-nix/languages/c";
  };

  outputs =
    { self, c-lang }:
    c-lang.mkStandardOutputs {
      src = ./.;
      pname = "hello-c";
    };
}
