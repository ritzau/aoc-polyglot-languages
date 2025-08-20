{
  description = "Hello World JavaScript";
  inputs = {
    javascript-lang.url = "path:/Users/ritzau/src/slask/aoc-nix/languages/javascript";
  };
  outputs =
    { self, javascript-lang }:
    javascript-lang.mkStandardOutputs {
      src = ./.;
      pname = "hello-javascript";
    };
}
