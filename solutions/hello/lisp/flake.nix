{
  description = "Hello World Lisp";
  inputs = {
    lisp-lang.url = "path:/Users/ritzau/src/slask/aoc-nix/languages/lisp";
  };
  outputs =
    { self, lisp-lang }:
    lisp-lang.mkStandardOutputs {
      src = ./.;
      pname = "hello-lisp";
    };
}
