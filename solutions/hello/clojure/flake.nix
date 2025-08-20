{
  description = "Hello World Clojure";
  inputs = {
    clojure-lang.url = "path:/Users/ritzau/src/slask/aoc-nix/languages/clojure";
  };
  outputs =
    { self, clojure-lang }:
    clojure-lang.mkStandardOutputs {
      src = ./.;
      pname = "hello-clojure";
    };
}
