{
  description = "C# environment for AOC solutions";

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
            dotnet-sdk_8
            mono
            omnisharp-roslyn
          ];

          shellHook = ''
            echo "🔷 C# AOC Environment"
            echo "Available commands:"
            echo "  dotnet new console"
            echo "  dotnet run"
            echo "  mcs solution.cs && mono solution.exe"
            echo "  dotnet build"
          '';
        };
      });
}
