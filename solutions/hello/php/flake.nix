{
  description = "Hello World PHP";
  inputs = {
    php-lang.url = "path:/Users/ritzau/src/slask/aoc-nix/languages/php";
  };
  outputs =
    { self, php-lang }:
    php-lang.mkStandardOutputs {
      src = ./.;
      pname = "hello-php";
    };
}
