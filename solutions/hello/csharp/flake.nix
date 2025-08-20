{
  description = "Hello World C#";
  inputs = {
    csharp-lang.url = "path:/Users/ritzau/src/slask/aoc-nix/languages/csharp";
  };
  outputs =
    { self, csharp-lang }:
    csharp-lang.mkStandardOutputs {
      src = ./.;
      pname = "hello-csharp";
    };
}
