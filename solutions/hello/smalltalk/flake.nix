{
  description = "Hello World Smalltalk";
  inputs = {
    smalltalk-lang.url = "path:/Users/ritzau/src/slask/aoc-nix/languages/smalltalk";
  };
  outputs =
    { self, smalltalk-lang }:
    smalltalk-lang.mkStandardOutputs {
      src = ./.;
      pname = "hello-smalltalk";
    };
}
