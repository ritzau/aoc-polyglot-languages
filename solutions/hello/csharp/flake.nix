{
  description = "Hello World C#";

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
          ];

          shellHook = ''
            echo "🔷 Hello C# Environment"
            echo "Run: mcs Hello.cs && mono Hello.exe"
          '';
        };

        apps.default = {
          type = "app";
          program = "${pkgs.writeShellScript "run-csharp" ''
            cd ${./.}
            ${pkgs.mono}/bin/mcs Hello.cs
            ${pkgs.mono}/bin/mono Hello.exe
          ''}";
        };
      });
}
