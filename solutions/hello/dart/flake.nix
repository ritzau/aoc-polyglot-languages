{
  description = "Hello World Dart";
  inputs = {
    dart-lang.url = "path:/Users/ritzau/src/slask/aoc-nix/languages/dart";
  };
  outputs =
    { self, dart-lang }:
    dart-lang.mkStandardOutputs {
      src = ./.;
      pname = "hello-dart";
    };
}
