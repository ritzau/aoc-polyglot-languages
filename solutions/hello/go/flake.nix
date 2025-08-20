{
  description = "Hello World Go";

  inputs = {
    go-lang.url = "path:/Users/ritzau/src/slask/aoc-nix/languages/go";
  };

  outputs =
    { self, go-lang }:
    go-lang.mkStandardOutputs {
      src = ./.;
      pname = "hello-go";
    };
}
