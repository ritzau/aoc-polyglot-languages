{
  description = "Hello World Perl";
  inputs = {
    perl-lang.url = "path:/Users/ritzau/src/slask/aoc-nix/languages/perl";
  };
  outputs =
    { self, perl-lang }:
    perl-lang.mkStandardOutputs {
      src = ./.;
      pname = "hello-perl";
    };
}
