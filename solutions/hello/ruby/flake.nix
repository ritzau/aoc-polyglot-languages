{
  description = "Hello World Ruby";
  inputs = {
    ruby-lang.url = "path:/Users/ritzau/src/slask/aoc-nix/languages/ruby";
  };
  outputs =
    { self, ruby-lang }:
    ruby-lang.mkStandardOutputs {
      src = ./.;
      pname = "hello-ruby";
    };
}
