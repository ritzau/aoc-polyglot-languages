{
  description = "Hello World Python";
  inputs = {
    python-lang.url = "path:/Users/ritzau/src/slask/aoc-nix/languages/python";
  };
  outputs =
    { self, python-lang }:
    python-lang.mkStandardOutputs {
      src = ./.;
      pname = "hello-python";
    };
}
