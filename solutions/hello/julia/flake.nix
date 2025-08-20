{
  description = "Hello World Julia";
  inputs = {
    julia-lang.url = "path:/Users/ritzau/src/slask/aoc-nix/languages/julia";
  };
  outputs =
    { self, julia-lang }:
    julia-lang.mkStandardOutputs {
      src = ./.;
      pname = "hello-julia";
    };
}
