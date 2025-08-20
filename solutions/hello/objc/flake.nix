{
  description = "Hello World Objective-C";
  inputs = {
    objc-lang.url = "path:/Users/ritzau/src/slask/aoc-nix/languages/objc";
  };
  outputs =
    { self, objc-lang }:
    objc-lang.mkStandardOutputs {
      src = ./.;
      pname = "hello-objc";
    };
}
