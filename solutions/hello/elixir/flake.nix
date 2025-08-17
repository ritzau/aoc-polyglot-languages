{
  description = "Hello World Elixir";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            elixir
            erlang
          ];

          shellHook = ''
            echo "💧 Hello Elixir Environment"
            echo "Run: elixir hello.exs"
          '';
        };

        apps.default = {
          type = "app";
          program = "${pkgs.elixir}/bin/elixir";
          args = [ "${./hello.exs}" ];
        };
      });
}
