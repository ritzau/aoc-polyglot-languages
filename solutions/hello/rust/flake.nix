{
  description = "Hello World Rust";

  inputs = {
    rust-lang.url = "path:/Users/ritzau/src/slask/aoc-nix/languages/rust";
  };

  outputs =
    { self, rust-lang }:
    rust-lang.mkStandardOutputs {
      src = ./.;
      pname = "hello-rust";
    };
}
