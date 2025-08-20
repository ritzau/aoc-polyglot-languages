{
  description = "Hello World TypeScript";
  inputs = {
    typescript-lang.url = "path:/Users/ritzau/src/slask/aoc-nix/languages/typescript";
  };
  outputs =
    { self, typescript-lang }:
    typescript-lang.mkStandardOutputs {
      src = ./.;
      pname = "hello-typescript";
    };
}
