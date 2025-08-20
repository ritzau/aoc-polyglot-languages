{
  description = "Hello World Tcl";
  inputs = {
    tcl-lang.url = "path:/Users/ritzau/src/slask/aoc-nix/languages/tcl";
  };
  outputs =
    { self, tcl-lang }:
    tcl-lang.mkStandardOutputs {
      src = ./.;
      pname = "hello-tcl";
    };
}
