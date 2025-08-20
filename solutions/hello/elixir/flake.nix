{
  description = "Hello World Elixir";
  inputs = {
    elixir-lang.url = "path:/Users/ritzau/src/slask/aoc-nix/languages/elixir";
  };
  outputs =
    { self, elixir-lang }:
    elixir-lang.mkStandardOutputs {
      src = ./.;
      pname = "hello-elixir";
    };
}
