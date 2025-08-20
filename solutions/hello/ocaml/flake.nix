{
  description = "Hello World OCaml";
  inputs = {
    ocaml-lang.url = "path:/Users/ritzau/src/slask/aoc-nix/languages/ocaml";
  };
  outputs =
    { self, ocaml-lang }:
    ocaml-lang.mkStandardOutputs {
      src = ./.;
      pname = "hello-ocaml";
    };
}
