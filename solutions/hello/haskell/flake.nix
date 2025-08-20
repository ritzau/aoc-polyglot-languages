{
  description = "Hello World Haskell";
  inputs = {
    haskell-lang.url = "path:/Users/ritzau/src/slask/aoc-nix/languages/haskell";
  };
  outputs =
    { self, haskell-lang }:
    haskell-lang.mkStandardOutputs {
      src = ./.;
      pname = "hello-haskell";
    };
}
