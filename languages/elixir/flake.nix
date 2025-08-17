{
  description = "Elixir environment for AOC solutions";

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
            elixir-ls
          ];

          shellHook = ''
            echo "💧 Elixir AOC Environment"
            echo "Available commands:"
            echo "  elixir solution.exs"
            echo "  iex solution.exs"
            echo "  mix new project && mix run"
            echo "  mix test"
          '';
        };
      });
}