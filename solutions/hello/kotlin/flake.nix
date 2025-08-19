{
  description = "Hello World Kotlin";

  inputs = {
    kotlin-lang.url = "path:/Users/ritzau/src/slask/aoc-nix/languages/kotlin";
  };

  outputs = { self, kotlin-lang }:
    kotlin-lang.inputs.flake-utils.lib.eachDefaultSystem (system:
      kotlin-lang.lib.${system}.mkSolution { });
}
