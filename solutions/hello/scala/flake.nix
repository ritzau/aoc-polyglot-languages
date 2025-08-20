{
  description = "Hello World Scala";
  inputs = {
    scala-lang.url = "path:/Users/ritzau/src/slask/aoc-nix/languages/scala";
  };
  outputs =
    { self, scala-lang }:
    scala-lang.mkStandardOutputs {
      src = ./.;
      pname = "hello-scala";
    };
}
