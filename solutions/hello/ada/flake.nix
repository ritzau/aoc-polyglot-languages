{
  description = "Hello World Ada";
  inputs = {
    ada-lang.url = "path:/Users/ritzau/src/slask/aoc-nix/languages/ada";
  };
  outputs =
    { self, ada-lang }:
    ada-lang.mkStandardOutputs {
      src = ./.;
      pname = "hello-ada";
    };
}
