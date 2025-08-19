{
  description = "Hello World COBOL";
  inputs = {
    cobol-lang.url = "path:/Users/ritzau/src/slask/aoc-nix/languages/cobol";
  };
  outputs = { self, cobol-lang }:
    cobol-lang.mkStandardOutputs {
      src = ./.;
      pname = "hello-cobol";
    };
}
