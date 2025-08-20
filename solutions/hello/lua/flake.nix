{
  description = "Hello World Lua";
  inputs = {
    lua-lang.url = "path:/Users/ritzau/src/slask/aoc-nix/languages/lua";
  };
  outputs =
    { self, lua-lang }:
    lua-lang.mkStandardOutputs {
      src = ./.;
      pname = "hello-lua";
    };
}
