{
  description = "Hello World Java";
  inputs = {
    java-lang.url = "path:/Users/ritzau/src/slask/aoc-nix/languages/java";
  };
  outputs =
    { self, java-lang }:
    java-lang.mkStandardOutputs {
      src = ./.;
      pname = "hello-java";
    };
}
