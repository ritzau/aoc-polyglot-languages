{
  description = "Hello World Swift";
  inputs = {
    swift-lang.url = "path:/Users/ritzau/src/slask/aoc-nix/languages/swift";
  };
  outputs =
    { self, swift-lang }:
    swift-lang.mkStandardOutputs {
      src = ./.;
      pname = "hello-swift";
    };
}
