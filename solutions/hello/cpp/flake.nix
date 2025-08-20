{
  description = "Hello World C++";

  inputs = {
    cpp-lang.url = "path:/Users/ritzau/src/slask/aoc-nix/languages/cpp";
  };

  outputs =
    { self, cpp-lang }:
    cpp-lang.mkStandardOutputs {
      src = ./.;
      pname = "hello-cpp";
    };
}
