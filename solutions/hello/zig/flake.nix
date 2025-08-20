{
  description = "Hello World Zig";
  inputs = {
    zig-lang.url = "path:/Users/ritzau/src/slask/aoc-nix/languages/zig";
  };
  outputs =
    { self, zig-lang }:
    zig-lang.mkStandardOutputs {
      src = ./.;
      pname = "hello-zig";
    };
}
